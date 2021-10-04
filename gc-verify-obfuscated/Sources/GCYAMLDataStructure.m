//
//  GCYAMLDataStructure.m
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import "GCYAMLDataStructure.h"


@interface GCYAMLDataStructure ()
{
    
}
@end // @interface GCYAMLDataStructure ()


@implementation GCYAMLDataStructure

- (instancetype)init
{
    self = [super init];
    if (self) {
        _instanceMethodsDict = [NSMutableDictionary new];
        _classMethodsDict = [NSMutableDictionary new];
        _ivarsDict = [NSMutableDictionary new];
        _propertiesDict = [NSMutableDictionary new];
    }
    return self;
}

- (instancetype)initWithInterfaceName:(NSString *)interfaceName {
    self = [self init];
    if (self) {
        _interfaceName = interfaceName;
    }
    return self;
}

@end // @implementation GCYAMLDataStructure
