//
//  FMDatabaseServices.h
//  ManageUser
//
//  Created by Le Minh Thien on 7/29/20.
//  Copyright © 2020 Le Minh Thien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMDatabaseServices : NSObject
+(id) getInstance;
-(instancetype) init;
-(void)read:(NSString*)query completion:(void(^ __nullable)(FMResultSet* __nullable result))block;
-(void)insert:(NSString*)query arguments:(NSDictionary*)arguments completion:(void (^ __nullable)(BOOL success))block;
-(void)update:(NSString*)query arguments:(NSDictionary*)arguments completion:(void (^ __nullable)(BOOL success))block;
-(void)remove:(NSString*)query ID:(NSString*)ID completion:(void (^ __nullable)(BOOL success))block;
@end

NS_ASSUME_NONNULL_END
