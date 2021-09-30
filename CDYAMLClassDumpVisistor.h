//
//  CDYAMLClassDumpVisistor.h
//  class-dump
//
//  Created by Trieu Nguyen on 29/09/2021.
//

#import "CDVisitor.h"

#import "CDTypeController.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDYAMLClassDumpVisistor : CDVisitor <CDTypeControllerDelegate>

@property (nonatomic, readonly) NSString *outputPath;

- (instancetype)initWithOutputPath:(NSString *)outputPath;

@end // @interface CDYAMLClassDumpVisistor

NS_ASSUME_NONNULL_END
