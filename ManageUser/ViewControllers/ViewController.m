//
//  ViewController.m
//  ManageUser
//
//  Created by Le Minh Thien on 7/28/20.
//  Copyright © 2020 Le Minh Thien. All rights reserved.
//

#import "ViewController.h"
#import "Usermodel.h"
#import "UserTableViewCell.h"
#import <FMDB/FMDB.h>
#import "FMDatabaseServices.h"

typedef enum {
    add,
    update,
    delete
} UserAlertType;

@interface ViewController ()

@end

@implementation ViewController

NSString* identifierUserCell = @"UserTableViewCell";
UIAlertController *alertAdd;
UIAlertController *alertUpdate;
UIAlertController *alertDelete;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self configTableView];
    [self configTextField];
    [self cofigObserver];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // hide keyboard
    [self hideKeyboard];
}

- (void) didRorate:(NSNotification*)notification {
    if (UIDevice.currentDevice.orientation == UIDeviceOrientationPortrait) {
        self.contentView.axis = UILayoutConstraintAxisVertical;
    } else {
        if (UIDevice.currentDevice.orientation == UIDeviceOrientationLandscapeLeft || UIDevice.currentDevice.orientation == UIDeviceOrientationLandscapeRight) {
            self.contentView.axis = UILayoutConstraintAxisHorizontal;
            self.widthUserInputAnchor.active = true;
        }
    }
}

- (void)cofigObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRorate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
    [notificationCenter addObserver:self selector: @selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector: @selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) configTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName: identifierUserCell bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier: identifierUserCell];
}

- (void) configTextField {
    self.txtName.returnKeyType = UIReturnKeyDone;
    self.txtEmail.returnKeyType = UIReturnKeyDone;
    self.txtName.delegate = self;
    self.txtEmail.delegate = self;
}

- (void) getData {
    self.items = [[NSMutableArray<Usermodel*> alloc] init];
    [[FMDatabaseServices getInstance] read:@"Select * from users" completion:^(FMResultSet * _Nullable result) {
        self.items = [Usermodel getList:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (IBAction)actionRefresh:(id)sender {
    [self clearInput];
}

- (void) clearInput {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.txtName.text = @"";
        self.txtEmail.text = @"";
    });
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (void) showAlert :(UserAlertType)type cancel:(void (^ __nullable)(void))blockCancel ok:(void (^ __nullable)(void))blockOk {
    if (type == add) {
        if (alertAdd == nil) {
            alertAdd = [UIAlertController alertControllerWithTitle:@"Thêm mới" message:@"Vui lòng điền đầy đủ thông tin" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [alertAdd addAction:actionOk];
        }
        [self presentViewController:alertAdd animated:true completion:nil];
    } else if (type == update) {
        alertUpdate = [UIAlertController alertControllerWithTitle:@"Cập nhật" message:@"Bạn có muốn cập nhật hay không?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            blockCancel();
        }];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            blockOk();
        }];
        [alertUpdate addAction:actionCancel];
        [alertUpdate addAction:actionOk];
        [self presentViewController:alertUpdate animated:true completion:nil];
    } else if(type == delete) {
        alertDelete = [UIAlertController alertControllerWithTitle:@"Xóa" message:@"Bạn có muốn xóa hay không?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            blockCancel();
        }];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            blockOk();
        }];
        [alertDelete addAction:actionCancel];
        [alertDelete addAction:actionOk];
        [self presentViewController:alertDelete animated:true completion:nil];
    }
}

- (IBAction)actionAdd:(id)sender {
    
    Usermodel *user = [[Usermodel alloc] init: self.txtName.text email:self.txtEmail.text];
    if ([user getValid]) {
        [[FMDatabaseServices getInstance] insert:@"INSERT INTO users (id, name, email) VALUES (:id, :name, :email)" arguments:[user parseDict] completion:^(BOOL success) {
            if(success) {
                [self.items addObject: user ];
                [self.tableView beginUpdates];
                NSArray<NSIndexPath*>* indexPaths = [[NSArray<NSIndexPath*> alloc] initWithObjects:[NSIndexPath indexPathForItem:self.items.count - 1 inSection:0], nil];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation: UITableViewRowAnimationBottom];
                [self.tableView endUpdates];
                [self clearInput];
                //scroll tableview last index
                NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }];
    } else {
        [self showAlert:add cancel:nil ok:nil];
        NSLog(@"Không hợp lệ. Vui lòng điền đầy đủ thông tin");
    }
    [self hideKeyboard];
}

//MARK: -Keyboard
- (void) keyboardWillShow:(NSNotification*)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardValue = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrame = [keyboardValue CGRectValue];
    keyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom = keyboardFrame.size.height + 20;
    self.tableView.contentInset = contentInset;
}

- (void) keyboardWillHide:(NSNotification*)notification {
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInset;
}

// MARK: -TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = (UserTableViewCell*)[tableView dequeueReusableCellWithIdentifier: identifierUserCell forIndexPath: indexPath];
    [cell setUp: self.items[indexPath.row]];
    cell.alertDelegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell.isUpdate) {
    UIAlertController *alertUpdateDirect = [UIAlertController alertControllerWithTitle:@"Cập nhật" message:@"Bạn có muốn cập nhật hay không?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertUpdateDirect addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.items[indexPath.row].name;
    }];
    
    [alertUpdateDirect addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.items[indexPath.row].email;
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.items[indexPath.row].name = alertUpdateDirect.textFields[0].text;
        self.items[indexPath.row].email = alertUpdateDirect.textFields[1].text;
        [self updateUserOnTableView:[self.items[indexPath.row] parseDict] indexPath:indexPath];
    }];
    [alertUpdateDirect addAction:actionCancel];
    [alertUpdateDirect addAction:actionOk];
    [self presentViewController:alertUpdateDirect animated:true completion:nil];
    }
}

// MARK: -TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtName) {
        [self.txtEmail becomeFirstResponder];
    } else if (textField == self.txtEmail) {
        [self hideKeyboard];
    }
    return YES;
}

// MARK: -ALertUserDelegate
- (void)showUpdate:(UITableViewCell *)cell{
    UserTableViewCell *_cell = (UserTableViewCell*)cell;
    [self showAlert:update cancel:^{
        [_cell previousData];
    } ok:^{
        [_cell updateData];
        [self updateUserOnTableView: [_cell.model parseDict] indexPath: [self getIndexPath: _cell.model]];
    }];
    [self hideKeyboard];
}

- (void)showDelete:(UITableViewCell *)cell{
    [self showAlert:delete cancel:^{} ok:^{
        UserTableViewCell *_cell = (UserTableViewCell*)cell;
        [[FMDatabaseServices getInstance] remove:@"DELETE FROM users where id= :id" ID: _cell.model._id completion:^(BOOL success) {
            if(success) {
                // No move getIndexPath() after removed
                NSIndexPath* indexPath = [self getIndexPath:_cell.model];
                [self.items removeObject: _cell.model];
                [self.tableView beginUpdates];
                NSArray<NSIndexPath*>*indexPaths = [[NSArray alloc] initWithObjects: indexPath , nil];
                [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }
        }];
    }];
    [self hideKeyboard];
}

- (void) updateUserOnTableView: (NSDictionary*)arguments indexPath: (NSIndexPath*)indexPath {
    [[FMDatabaseServices getInstance] update:@"UPDATE users SET name= :name, email= :email where id= :id" arguments: arguments completion:^(BOOL success) {
        if (success) {
            [self.tableView beginUpdates];
            NSArray<NSIndexPath*>*indexPaths = [[NSArray alloc] initWithObjects: indexPath , nil];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }];
}

- (NSIndexPath*)getIndexPath: (Usermodel*)user {
    NSInteger row = [self.items indexOfObject: user];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:0];
    return indexPath;
}
@end

