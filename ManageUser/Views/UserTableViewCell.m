//
//  UserTableViewCell.m
//  ManageUser
//
//  Created by Le Minh Thien on 7/28/20.
//  Copyright © 2020 Le Minh Thien. All rights reserved.
//

#import "UserTableViewCell.h"
#import "Usermodel.h"

@implementation UserTableViewCell

@synthesize isUpdate = _isUpdate;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)commonInit{
    [self configTextField];
}

- (void)setIsUpdate:(BOOL)isUpdate {
    _isUpdate = isUpdate;
    if (isUpdate) {
        [self.txtEmail setHidden:YES];
        [self.txtUserName setHidden:YES];
        
        [self.textFieldUserName setHidden:NO];
        [self.textFieldEmail setHidden:NO];
        
        [self.btnUpdate setTitle:@"Cập nhật" forState:normal];
        
    } else {
        [self.txtEmail setHidden:NO];
        [self.txtUserName setHidden:NO];
        
        [self.textFieldUserName setHidden:YES];
        [self.textFieldEmail setHidden:YES];
        
        [self.alertDelegate showUpdate:self];
        [self.btnUpdate setTitle:@"Sửa" forState:normal];
    }
    [self hideKeyboard];
}

- (void) setUI {
    self.txtUserName.text = self.model.name;
    self.txtEmail.text = self.model.email;
    self.textFieldUserName.text = self.model.name;
    self.textFieldEmail.text = self.model.email;
}

- (BOOL) isUpdate {
    return _isUpdate;
}

- (void) configTextField {
    self.textFieldUserName.returnKeyType = UIReturnKeyDone;
    self.textFieldEmail.returnKeyType = UIReturnKeyDone;
    
    self.textFieldUserName.delegate = self;
    self.textFieldEmail.delegate = self;
}

- (void) hideKeyboard {
    [self endEditing:YES];
}

- (IBAction)actionUpdate:(id)sender {
    [self setIsUpdate:!self.isUpdate];
    [self.textFieldUserName becomeFirstResponder];
}

- (IBAction)actionRemove:(id)sender {
    [self.alertDelegate showDelete:self];
}

-(void)setUp:(NSString*)username email:(NSString*)email {
    self.model = [[Usermodel alloc] init:username email:email];
    [self setUI];
}

-(void)setUp:(Usermodel*)model{
    self.model = model;
    [self setUI];
}
// MARK:- hanlde Row
-(void) updateData {
    self.model.name = self.textFieldUserName.text;
    self.model.email = self.textFieldEmail.text;
}

-(void)previousData {
    if (self.model != nil) {
        self.textFieldUserName.text = self.model.name;
        self.textFieldEmail.text = self.model.email;
    }
}

// MARK: - TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.textFieldUserName) {
        [self.textFieldEmail becomeFirstResponder];
    } else if(textField == self.textFieldEmail) {
        [self hideKeyboard];
    }
    return true;
}
@end
