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
    
    fprintf(stderr, "\nStart load BLACKLIST file at path: %s", blacklistFile.UTF8String);
    
    NSError *error = nil;
    NSArray<GCYAMLDataStructure *> *blackListYAMLDataStructures = [_yamlFileParser parseYAMLFileFromPath:blacklistFile
                                                                                                   error:&error];
    if (error) {
        fprintf(stderr, "\nLoad BLACKLIST file FAILED at path: %s - with error: %s",
                blacklistFile.UTF8String, error.localizedDescription.UTF8String);
        
        return [self _createVerificationResponseWithError:error];
    }
    
    fprintf(stderr, "\nLoad BLACKLIST file Success");
    fprintf(stderr, "\nStart verify BLACKLIST with DUMPs file at path: %s", dumpedPath.UTF8String);
    
    for (GCYAMLDataStructure *blacklistYAMLDataStructure in blackListYAMLDataStructures) {
        NSString *interfaceName = blacklistYAMLDataStructure.interfaceName;
        
        fprintf(stderr, "\n\n------------------------------------------");
        fprintf(stderr, "\nStart Verify Interface: %s", interfaceName.UTF8String);
        
        GCYAMLDataStructure *dumpYAMLDataStructure = [self _loadDumpYAMLFileWithInterfaceName:interfaceName
                                                                                   dumpedPath:dumpedPath
                                                                                        error:&error];
        
        if (error) {
            return [self _createVerificationResponseWithError:error];
        }
        
        fprintf(stderr, "\nStart Verify BLACKLIST Interface and DUMP");
        
        NSString *verifyMessage = nil;
        GCObfuscatedVerificationResult result = [self _verifyBlacklistYAMLDataStructure:blacklistYAMLDataStructure
                                                                  dumpYAMLDataStructure:dumpYAMLDataStructure
                                                                                message:&verifyMessage];
        
        if (result == GCObfuscatedVerificationResult_Different) {
            return [[GCObfuscatedVerificationResponse alloc]
                    initWithResult:GCObfuscatedVerificationResult_Different
                    messages:@[GC_NULLObjToEmptyStr(verifyMessage)]];
        }
        
        fprintf(stderr, "\nVerify Interface: %s SUCCESS", interfaceName.UTF8String);
        fprintf(stderr, "\n------------------------------------------");
    }
    
    return [self _createVerificationResponseWithError:nil];;
}

- (GCObfuscatedVerificationResult)_verifyBlacklistYAMLDataStructure:(GCYAMLDataStructure *)blacklistYAMLDataStructure
                                              dumpYAMLDataStructure:(GCYAMLDataStructure *)dumpYAMLDataStructure
                                                            message:(NSString **)message {
    
    NSString *blackListInterfaceName = blacklistYAMLDataStructure.interfaceName;
    if (NO == [blackListInterfaceName isEqual:dumpYAMLDataStructure.interfaceName]) {
        *message = [NSString stringWithFormat:@"Black list interface: '%@' - and dump interface: '%@' --> NOT EQUAL",
                    blacklistYAMLDataStructure.interfaceName, dumpYAMLDataStructure.interfaceName];
        
        return GCObfuscatedVerificationResult_Different;
    }
    
    for (NSString *instanceMethod in blacklistYAMLDataStructure.instanceMethodsDict.allKeys) {
        if (NULL == [dumpYAMLDataStructure.instanceMethodsDict objectForKey:instanceMethod]) {
            *message = [NSString stringWithFormat:@"Black list: Interface: '%@' instanceMethod: '%@' - NOT EXIST",
                        blackListInterfaceName, instanceMethod];
            
            return GCObfuscatedVerificationResult_Different;
        }
    }
    
    for (NSString *classMethod in blacklistYAMLDataStructure.classMethodsDict.allKeys) {
        if (NULL == [dumpYAMLDataStructure.classMethodsDict objectForKey:classMethod]) {
            *message = [NSString stringWithFormat:@"Black list: Interface: '%@' classMethod: '%@' - NOT EXIST",
                        blackListInterfaceName, classMethod];
            
            return GCObfuscatedVerificationResult_Different;
        }
    }
    
    for (NSString *property in blacklistYAMLDataStructure.propertiesDict.allKeys) {
        if (NULL == [dumpYAMLDataStructure.propertiesDict objectForKey:property]) {
            *message = [NSString stringWithFormat:@"Black list: Interface: '%@' property: '%@' - NOT EXIST",
                        blackListInterfaceName, property];
            
            return GCObfuscatedVerificationResult_Different;
        }
    }
    
    for (NSString *ivar in blacklistYAMLDataStructure.ivarsDict.allKeys) {
        if (NULL == [dumpYAMLDataStructure.ivarsDict objectForKey:ivar]) {
            *message = [NSString stringWithFormat:@"Black list: Interface: '%@' ivar: '%@' - NOT EXIST",
                        blackListInterfaceName, ivar];
            
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
    
    fprintf(stderr, "\nLoad LOAD DUMP Interface at path: %s", dumpFilePath.UTF8String);
    
    NSArray<GCYAMLDataStructure *> *dumpYAMLDataStructures = [_yamlFileParser parseYAMLFileFromPath:dumpFilePath
                                                                                              error:error];
    if (*error) {
        fprintf(stderr, "\nLoad DUMP Interface file FAILED at path: %s - error: %s",
                dumpFilePath.UTF8String, (*error).localizedDescription.UTF8String);
        return nil;
    }
    
    fprintf(stderr, "\nLoad DUMP Interface file SUCCESS at path: %s", dumpFilePath.UTF8String);
    
    if (dumpYAMLDataStructures.count == 0) {
        fprintf(stderr, "\nDump YAML file empty");
        *error = [self _invalidFormatError];
        return nil;
    }
    
    fprintf(stderr, "\nDump YAML file valid");
    
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
