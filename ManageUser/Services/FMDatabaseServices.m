//
//  FMDatabaseServices.m
//  ManageUser
//
//  Created by Le Minh Thien on 7/29/20.
//  Copyright © 2020 Le Minh Thien. All rights reserved.
//

#import "FMDatabaseServices.h"
#import <FMDB/FMDB.h>

static FMDatabaseServices *instance = nil;

@implementation FMDatabaseServices

NSString *createTableSQL = @"CREATE TABLE 'users' ('id' VARCHAR PRIMARY KEY, 'name' TEXT, 'email' TEXT)";
FMDatabase *database = nil;

+ (id)getInstance {
    if (instance == nil) {
        instance = [[FMDatabaseServices alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    [self config];
    return self;
}

-(void) config {
    @try {
        NSURL* fileURL = [[[ NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL: nil create:true error:nil] URLByAppendingPathComponent:@"manageruser.sqlite"];
        
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"manageruser.sqlite"];
        if(path != nil) {
            database = [FMDatabase databaseWithURL: fileURL];
            if (![database open]) {
                NSLog(@"Error connect database");
                return;
            }
            //Create table if It dont exist
            if ([database executeStatements:createTableSQL]) {
                NSLog(@"Created table success");
            } else {
                NSLog(@"Table created or error");
            }
        }
    } @catch(id exception) {
        NSLog(@"%@",[(NSString *)exception lowercaseString]);
    }
}
// MARK: -CRUD FMDB
- (void)read:(NSString *)query completion:(void (^)(FMResultSet * _Nullable))block {
    if(database != nil) {
        if (![database isOpen]) {
            [database open];
        }
        block([database executeQuery:query]);
        [database close];
    }
    else {
        block(nil);
    }
}
-(void)write:(NSString *)query arguments:(NSDictionary *)arguments completion:(void (^)(BOOL))block {
    if(database != nil) {
        if(![database isOpen]) {
            [database open];
        }
        BOOL result = [database executeUpdate:query withParameterDictionary:arguments];
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(result);
            });
        }
        //        [database commit];
        [database close];
    }
    block(NO);
}

- (void)insert:(NSString *)query arguments:(NSDictionary *)arguments completion:(void (^)(BOOL))block {
    [self write:query arguments:arguments completion:block];
}

- (void)update:(NSString *)query arguments:(NSDictionary *)arguments completion:(void (^)(BOOL))block {
    [self write:query arguments:arguments completion:block];
}

- (void)remove:(NSString *)query ID:(NSString*)ID completion:(void (^)(BOOL))block {
    NSDictionary *dictID = @{@"id": ID};
    [self write:query arguments:dictID completion:block];
}
@end

