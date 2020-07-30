//
//  UserTableViewCell.h
//  ManageUser
//
//  Created by Le Minh Thien on 7/28/20.
//  Copyright © 2020 Le Minh Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Usermodel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol AlertUserDelegate <NSObject>
- (void) showUpdate:(UITableViewCell*)cell;
- (void) showDelete:(UITableViewCell*)cell;
@end

@interface UserTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *txtUserName;
@property (weak, nonatomic) IBOutlet UILabel *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;

@property (assign, nonatomic) BOOL isUpdate;
@property (assign, nonatomic) id<AlertUserDelegate> alertDelegate;
@property (strong, nonatomic) Usermodel* model;

- (IBAction)actionUpdate:(id)sender;
- (IBAction)actionRemove:(id)sender;
-(void)setUp:(NSString*)username email:(NSString*)email;
-(void)setUp:(Usermodel*)model;

// MARK: - handle Data
-(void)previousData;
-(void)updateData;

@property (strong, nonatomic) NSString* identifer;
@end

NS_ASSUME_NONNULL_END
