//
//  Usermodel.m
//  ManageUser
//
//  Created by Le Minh Thien on 7/28/20.
//  Copyright © 2020 Le Minh Thien. All rights reserved.
//

#import "Usermodel.h"

@implementation Usermodel
-(instancetype)init:(NSString *)name email:(NSString *)email {
    self = [super init];
    NSUUID *uuid = [NSUUID UUID];
    self._id = [uuid UUIDString];
    self.name = name;
    self.email = email;
    return self;
}

- (instancetype)initFromDataBase:(FMResultSet *)result {
    self = [super init];
    self._id = [result stringForColumn:@"id"];
    self.name = [result stringForColumn:@"name"];
    self.email = [result stringForColumn:@"email"];
    return self;
}

-(BOOL)getValid {
    if ([self.name  isEqual: @""] || [self.email  isEqual: @""]) {
        return NO;
    }
    return YES;
}

+ (NSMutableArray<Usermodel *> *)getList:(FMResultSet *)result {
    NSMutableArray<Usermodel *> *list = [[NSMutableArray alloc] init];
    while ([result next]) {
        Usermodel *user = [[Usermodel alloc] initFromDataBase:result];
        [list addObject:user];
    }
    return list;
}

- (NSDictionary *)parseDict {
    NSDictionary *dict = @{@"id": self._id, @"name": self.name, @"email": self.email};
    return dict;
}
@end
