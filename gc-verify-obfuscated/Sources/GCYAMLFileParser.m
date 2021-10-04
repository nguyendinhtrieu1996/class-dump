//
//  GCYAMLFileParser.m
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 04/10/2021.
//

#import "GCYAMLFileParser.h"

#import "GCYAMLFileReader.h"
#import "GCYAMLDataStructure.h"
#import "GCObfuscatedVerificationResponse.h"
#import "GCObfuscatedVerificationMacros.h"
#import "GCObfuscatedVerificationError.h"

#define GC_SET_INVALID_FORMAT_ERR_RETURN \
    *error = [self _invalidFormatError]; \
    return nil;


@interface GCYAMLFileParser ()
{
    GCYAMLFileReader *_yamlFileReader;
}
@end // @interface GCYAMLFileParser ()


@implementation GCYAMLFileParser

- (instancetype)initWithYAMLFileReader:(GCYAMLFileReader *)yamlFileReader {
    self = [super init];
    if (self) {
        _yamlFileReader = yamlFileReader;
    }
    return self;
}

- (NSArray<GCYAMLDataStructure *> *)parseYAMLFileFromPath:(NSString *)path
                                                    error:(NSError **)error {
    
    id yamlDict = [_yamlFileReader readFileAtPath:path error:error];
    if (*error) {
        return nil;
    }

    if (NO == GC_IsValidClass(yamlDict, NSDictionary.class)) {
        GC_SET_INVALID_FORMAT_ERR_RETURN
    }

    return [self _yamlDataStucturesFromYAMLDict:yamlDict errr:error];
}

- (NSArray<GCYAMLDataStructure *> *)_yamlDataStucturesFromYAMLDict:(NSDictionary *)yamlDict
                                                              errr:(NSError **)error {
    
    NSArray *interfaces = yamlDict[@"interfaces"];
    
    if (NO == GC_IsValidClass(interfaces, NSArray.class)) {
        GC_SET_INVALID_FORMAT_ERR_RETURN
    }
    
    NSMutableArray<GCYAMLDataStructure *> *result = [NSMutableArray new];
    
    for (NSDictionary *interfaceDict in interfaces) {
        if (NO == GC_IsValidClass(interfaceDict, NSDictionary.class)) {
            GC_SET_INVALID_FORMAT_ERR_RETURN
        }

        GCYAMLDataStructure *ymlDataStructure = [self _createYAMLDataStructureFromInterfaceDict:interfaceDict
                                                                                          error:error];
        if (NULL == ymlDataStructure) {
            GC_SET_INVALID_FORMAT_ERR_RETURN
        }
        
        [result addObject:ymlDataStructure];
    }
    
    return result;
}

- (GCYAMLDataStructure *)_createYAMLDataStructureFromInterfaceDict:(NSDictionary *)interfaceDict
                                                             error:(NSError **)error {
    
    NSString *interfaceName = interfaceDict[@"name"];
    if (GC_IsEmptyStr(interfaceName)) {
        GC_SET_INVALID_FORMAT_ERR_RETURN
    }
    
    GCYAMLDataStructure *ymlDataStructure = [[GCYAMLDataStructure alloc] initWithInterfaceName:interfaceName];
    
    NSDictionary *instanceMethodsDict = [self _getNameDictFromDatas:interfaceDict[@"instancemethods"] error:error];
    [ymlDataStructure.instanceMethodsDict addEntriesFromDictionary:instanceMethodsDict];
    
    NSDictionary *classMethodsDict = [self _getNameDictFromDatas:interfaceDict[@"classmethods"] error:error];
    [ymlDataStructure.classMethodsDict addEntriesFromDictionary:classMethodsDict];
    
    NSDictionary *propertiesDict = [self _getNameDictFromDatas:interfaceDict[@"properties"] error:error];
    [ymlDataStructure.instanceMethodsDict addEntriesFromDictionary:propertiesDict];
    
    NSDictionary *ivarsDict = [self _getNameDictFromDatas:interfaceDict[@"ivars"] error:error];
    [ymlDataStructure.ivarsDict addEntriesFromDictionary:ivarsDict];
    
    return ymlDataStructure;
}

- (NSDictionary *)_getNameDictFromDatas:(NSArray *)datas error:(NSError **)error {
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    
    for (NSDictionary *nameDict in datas) {
        if (NO == GC_IsValidClass(nameDict, NSDictionary.class)) {
            GC_SET_INVALID_FORMAT_ERR_RETURN
        }
        
        NSString *name = nameDict[@"name"];
        if (GC_IsEmptyStr(name)) {
            GC_SET_INVALID_FORMAT_ERR_RETURN
        }
        
        resultDict[name] = @"1";
    }
    
    return resultDict;
}

- (NSError *)_invalidFormatError {
    return GC_MAKE_ERROR(GCObfuscatedVerificationError_InvalidFormat,
                         GCObfuscatedVerificationErrDes_InvalidFormat);
}

@end // @implementation GCYAMLFileParser
