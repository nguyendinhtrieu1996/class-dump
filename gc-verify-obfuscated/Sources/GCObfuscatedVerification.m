//
//  GCObfuscatedVerification.m
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import "GCObfuscatedVerification.h"

#import "GCYAMLFileReader.h"
#import "GCYAMLDataStructure.h"
#import "GCVerifyObfuscatedResponse.h"


#define GC_IsValidClass(obj, class) (obj && [obj isKindOfClass:class])

 
@interface GCObfuscatedVerification ()
{
    GCYAMLFileReader *_yamlFileReader;
}
@end // @interface GCObfuscatedVerification ()


@implementation GCObfuscatedVerification

- (instancetype)init
{
    self = [super init];
    if (self) {
        _yamlFileReader = [GCYAMLFileReader new];
    }
    return self;
}

- (GCVerifyObfuscatedResponse *)verifyWithBlackListFile:(NSString *)blacklistFile
                                             dumpedPath:(NSString *)dumpedPath {
    
    NSError *error = nil;
    id blackListDict = [_yamlFileReader readFileAtPath:blacklistFile error:&error];
    if (error) {
        return [[GCVerifyObfuscatedResponse alloc]
                initWithResult:(GCVerifyObfuscatedResult_Different)
                messages:@[error.description]];
    }
//
//    if (NULL == blackListDict) {
//        return [[GCVerifyObfuscatedResponse alloc]
//                initWithResult:(GCVerifyObfuscatedResult_Different)
//                messages:@[@"Blacklist file not exist"]];
//    }
//
//
//    if (NO == GC_IsValidClass(blackListDict, NSDictionary.class)) {
//        return [[GCVerifyObfuscatedResponse alloc]
//                initWithResult:(GCVerifyObfuscatedResult_Different)
//                messages:@[@"Blacklist is not kind of NSDictionary"]];
//    }
    
    
    
    return nil;
}

- (NSArray<GCYAMLDataStructure *> *)_getYAMLDataStuctureFromBlacklistDict:(NSDictionary *)blacklistDict {
    NSMutableArray<GCYAMLDataStructure *> *result = [NSMutableArray new];
    NSArray *interfaceDict = blacklistDict[@"interfaces"];
    
    if (NO == GC_IsValidClass(interfaceDict, NSArray.class)) {
        return result;
    }
    
    return result;
}

@end // @implementation GCObfuscatedVerification
