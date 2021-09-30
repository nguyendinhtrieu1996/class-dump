//
//  CDYAMLDataStructure.h
//  class-dump
//
//  Created by Trieu Nguyen on 29/09/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDYAMLDataStructure : NSObject

@property (nonatomic) NSString *interfaceName;

@property (nonatomic) NSMutableArray<NSString *> *ivars;

@property (nonatomic) NSMutableArray<NSString *> *properties;

@property (nonatomic) NSMutableArray<NSString *> *instanceMethods;

@property (nonatomic) NSMutableArray<NSString *> *classMethods;

@property (nonatomic) NSMutableArray<NSString *> *logs;

@end // @interface CDYAMLDataStructure 

NS_ASSUME_NONNULL_END
