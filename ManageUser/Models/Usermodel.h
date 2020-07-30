//
//  Usermodel.h
//  ManageUser
//
//  Created by Le Minh Thien on 7/28/20.
//  Copyright © 2020 Le Minh Thien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface Usermodel : NSObject
@property (strong, nonatomic) NSString* _id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* email;
-(instancetype)init :(NSString*)name email:(NSString*)email;
-(instancetype)initFromDataBase:(FMResultSet*) result;
+(NSMutableArray<Usermodel*>*) getList:(FMResultSet*) result;
-(NSDictionary*)parseDict;
-(BOOL)getValid;
@end

NS_ASSUME_NONNULL_END
