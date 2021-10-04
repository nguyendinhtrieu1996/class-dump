//
//  GCYAMLFileReader.h
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCYAMLFileReader : NSObject

- (id)readFileAtPath:(NSString *)path error:(NSError **)error;

@end // @interface GCYAMLFileReader

NS_ASSUME_NONNULL_END
