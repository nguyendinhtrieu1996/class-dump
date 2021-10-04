//
//  GCObfuscatedVerification.m
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import "GCObfuscatedVerification.h"

#import "GCYAMLFileReader.h"
#import "GCYAMLFileParser.h"
#import "GCYAMLDataStructure.h"
#import "GCObfuscatedVerificationError.h"
#import "GCObfuscatedVerificationResponse.h"
#import "GCObfuscatedVerificationMacros.h"


@interface GCObfuscatedVerification ()
{
    GCYAMLFileReader *_yamlFileReader;
    GCYAMLFileParser *_yamlFileParser;
}
@end // @interface GCObfuscatedVerification ()


@implementation GCObfuscatedVerification

- (instancetype)init
{
    self = [super init];
    if (self) {
        _yamlFileReader = [GCYAMLFileReader new];
        _yamlFileParser = [[GCYAMLFileParser alloc] initWithYAMLFileReader:_yamlFileReader];
    }
    return self;
}

- (GCObfuscatedVerificationResponse *)verifyWithBlackListFile:(NSString *)blacklistFile
                                                   dumpedPath:(NSString *)dumpedPath {
    
    NSError *error = nil;
    NSArray<GCYAMLDataStructure *> *blackListYAMLDataStructures = [_yamlFileParser parseYAMLFileFromPath:blacklistFile
                                                                                                   error:&error];
    if (error) {
        return [self _createVerificationResponseWithError:error];
    }
    
    for (GCYAMLDataStructure *blacklistYAMLDataStructure in blackListYAMLDataStructures) {
        NSString *interfaceName = blacklistYAMLDataStructure.interfaceName;
        
        GCYAMLDataStructure *dumpYAMLDataStructure = [self _loadDumpYAMLFileWithInterfaceName:interfaceName
                                                                                   dumpedPath:dumpedPath
                                                                                        error:&error];
        
        if (error) {
            return [self _createVerificationResponseWithError:error];
        }
        
        NSString *verifyMessage = nil;
        GCObfuscatedVerificationResult result = [self _verifyBlacklistYAMLDataStructure:blacklistYAMLDataStructure
                                                                  dumpYAMLDataStructure:dumpYAMLDataStructure
                                                                                message:&verifyMessage];
        
        if (result == GCObfuscatedVerificationResult_Different) {
            return [[GCObfuscatedVerificationResponse alloc]
                    initWithResult:GCObfuscatedVerificationResult_Different
                    messages:@[GC_NULLObjToEmptyStr(verifyMessage)]];
        }
    }
    
    return [self _createVerificationResponseWithError:nil];;
}

- (GCObfuscatedVerificationResult)_verifyBlacklistYAMLDataStructure:(GCYAMLDataStructure *)blacklistYAMLDataStructure
                                              dumpYAMLDataStructure:(GCYAMLDataStructure *)dumpYAMLDataStructure
                                                            message:(NSString **)message {
    
    if (NO == [blacklistYAMLDataStructure.interfaceName isEqual:dumpYAMLDataStructure.interfaceName]) {
        *message = [NSString stringWithFormat:@"Black list interface: %@ - and dump interface: %@ --> NOT EQUAL",
                    blacklistYAMLDataStructure.interfaceName, dumpYAMLDataStructure.interfaceName];
        
        return GCObfuscatedVerificationResult_Different;
    }
    
    for (NSString *instanceMethod in blacklistYAMLDataStructure.instanceMethodsDict.allKeys) {
        if (NULL == [dumpYAMLDataStructure.instanceMethodsDict objectForKey:instanceMethod]) {
            *message = [NSString stringWithFormat:@"Black list instanceMethod: %@ - NOT EXIST", instanceMethod];
            return GCObfuscatedVerificationResult_Different;
        }
    }
    
    for (NSString *classMethod in blacklistYAMLDataStructure.classMethodsDict.allKeys) {
        if (NULL == [dumpYAMLDataStructure.classMethodsDict objectForKey:classMethod]) {
            *message = [NSString stringWithFormat:@"Black list classMethod: %@ - NOT EXIST", classMethod];
            return GCObfuscatedVerificationResult_Different;
        }
    }
    
    for (NSString *property in blacklistYAMLDataStructure.propertiesDict.allKeys) {
        if (NULL == [dumpYAMLDataStructure.propertiesDict objectForKey:property]) {
            *message = [NSString stringWithFormat:@"Black list property: %@ - NOT EXIST", property];
            return GCObfuscatedVerificationResult_Different;
        }
    }
    
    for (NSString *ivar in blacklistYAMLDataStructure.ivarsDict.allKeys) {
        if (NULL == [dumpYAMLDataStructure.ivarsDict objectForKey:ivar]) {
            *message = [NSString stringWithFormat:@"Black list ivar: %@ - NOT EXIST", ivar];
            return GCObfuscatedVerificationResult_Different;
        }
    }
    
    return GCObfuscatedVerificationResult_Same;
}

- (GCYAMLDataStructure *)_loadDumpYAMLFileWithInterfaceName:(NSString *)interfaceName
                                                 dumpedPath:(NSString *)dumpedPath
                                                      error:(NSError **)error {
    
    NSString *dumpFileName = [NSString stringWithFormat:@"%@.yml", interfaceName];
    NSString *dumpFilePath = [dumpedPath stringByAppendingPathComponent:dumpFileName];
    
    NSArray<GCYAMLDataStructure *> *dumpYAMLDataStructures = [_yamlFileParser parseYAMLFileFromPath:dumpFilePath
                                                                                              error:error];
    if (*error) {
        return nil;
    }
    
    if (dumpYAMLDataStructures.count == 0) {
        *error = [self _invalidFormatError];
        return nil;
    }
    
    return dumpYAMLDataStructures.firstObject;
}

- (NSError *)_invalidFormatError {
    return GC_MAKE_ERROR(GCObfuscatedVerificationError_InvalidFormat,
                         GCObfuscatedVerificationErrDes_InvalidFormat);
}

- (GCObfuscatedVerificationResponse *)_createVerificationResponseWithError:(NSError *)error {
    if (error) {
        NSString *message = [NSString stringWithFormat:@"Error code: \(%ld), localizedDes: %@",
                             (long)error.code, error.localizedDescription];
        
        return [[GCObfuscatedVerificationResponse alloc]
                initWithResult:GCObfuscatedVerificationResult_Different
                messages:@[message]];
    }
    
    return [[GCObfuscatedVerificationResponse alloc]
            initWithResult:GCObfuscatedVerificationResult_Same
            messages:@[@"Verify Success!"]];
}

@end // @implementation GCObfuscatedVerification
