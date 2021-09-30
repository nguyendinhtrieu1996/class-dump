//
//  CDYAMLDataStructure.m
//  class-dump
//
//  Created by Trieu Nguyen on 29/09/2021.
//

#import "CDYAMLDataStructure.h"

@implementation CDYAMLDataStructure

- (instancetype)init
{
    self = [super init];
    if (self) {
        _ivars = [NSMutableArray new];
        _properties = [NSMutableArray new];
        _instanceMethods = [NSMutableArray new];
        _classMethods = [NSMutableArray new];
        _logs = [NSMutableArray new];
    }
    return self;
}

@end // @implementation CDYAMLDataStructure
