//
//  ViewController.h
//  ManageUser
//
//  Created by Le Minh Thien on 7/28/20.
//  Copyright © 2020 Le Minh Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Usermodel.h"
#import "UserTableViewCell.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AlertUserDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIStackView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthUserInputAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthUserContentAnchor;

@property (strong, nonatomic) NSMutableArray<Usermodel*> *items;
- (IBAction)actionRefresh:(id)sender;
- (IBAction)actionAdd:(id)sender;
@end

