//
//  ButtonUser.m
//  ManageUser
//
//  Created by Le Minh Thien on 7/28/20.
//  Copyright © 2020 Le Minh Thien. All rights reserved.
//

#import "ButtonUser.h"

@implementation ButtonUser

- (void)drawRect:(CGRect)rect {
    self.layer.borderWidth = 1.5f;
    self.layer.borderColor = UIColor.yellowColor.CGColor;
    self.layer.cornerRadius = 10;
}
@end
