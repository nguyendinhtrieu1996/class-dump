//
//  GCYAMLFileParser.h
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 04/10/2021.
//

#import <Foundation/Foundation.h>


@class GCYAMLFileReader;
@class GCYAMLDataStructure;


NS_ASSUME_NONNULL_BEGIN

@interface GCYAMLFileParser : NSObject

- (instancetype)initWithYAMLFileReader:(GCYAMLFileReader *)yamlFileReader;

- (nullable NSArray<GCYAMLDataStructure *> *)parseYAMLFileFromPath:(NSString *)path
                                                             error:(NSError **)error;

@end // @interface GCYAMLFileParser

NS_ASSUME_NONNULL_END
