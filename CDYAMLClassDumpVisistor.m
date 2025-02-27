//
//  CDYAMLClassDumpVisistor.m
//  class-dump
//
//  Created by Trieu Nguyen on 29/09/2021.
//

#import "CDYAMLClassDumpVisistor.h"

#import "CDClassDump.h"
#import "CDOCClass.h"
#import "CDOCCategory.h"
#import "CDOCMethod.h"
#import "CDOCProperty.h"
#import "CDTypeController.h"
#import "CDTypeFormatter.h"
#import "CDVisitorPropertyState.h"
#import "CDOCInstanceVariable.h"

#import "CDInternalMacros.h"
#import "YAMLSerialization.h"
#import "CDYAMLDataStructure.h"


@interface CDYAMLClassDumpVisistor ()
{
    NSOutputStream *_outputStream;
    
    CDYAMLDataStructure *_dataStructure;
}

@end // @interface CDYAMLClassDumpVisistor


@implementation CDYAMLClassDumpVisistor

#pragma mark Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _reset];
    }
    return self;
}

- (instancetype)initWithOutputPath:(NSString *)outputPath {
    self = [self init];
    if (self) {
        _outputPath = outputPath.copy;
        [self _tryToRemoveDirectory];
    }
    return self;
}

#pragma mark Class

- (void)willVisitClass:(CDOCClass *)aClass {
    [self _reset];
    _dataStructure.interfaceName = aClass.name;
}

- (void)didVisitClass:(CDOCClass *)aClass {
    [self _writeToFile];
}

#pragma mark Protocol

- (void)willVisitProtocol:(CDOCProtocol *)protocol {
    [self _reset];
    _dataStructure.interfaceName = protocol.name;
}

- (void)didVisitProtocol:(CDOCProtocol *)protocol {
    [self _writeToFile];
}

#pragma mark Category

- (void)willVisitCategory:(CDOCCategory *)category {
    [self _reset];
    _dataStructure.interfaceName = [NSString stringWithFormat:@"%@(%@)", category.className, category.name];
}

- (void)didVisitCategory:(CDOCCategory *)category {
    [self _writeToFile];
}

#pragma mark Methods

- (void)visitClassMethod:(CDOCMethod *)method {
    [_dataStructure.classMethods addObject:method.name];
}

- (void)visitInstanceMethod:(CDOCMethod *)method propertyState:(CDVisitorPropertyState *)propertyState {
    [_dataStructure.instanceMethods addObject:method.name];
}

#pragma mark Properties

- (void)visitIvar:(CDOCInstanceVariable *)ivar {
    [_dataStructure.ivars addObject:ivar.name];
}

- (void)visitProperty:(CDOCProperty *)property {
    CDType *parsedType = property.type;
    
    if (parsedType == nil) {
        if ([property.attributeString hasPrefix:@"T"]) {
            NSString *errLog1 = [NSString stringWithFormat:@"Error parsing type for property %@:", property.name];
            [_dataStructure.logs addObject:errLog1];
            
            NSString *errLog2 = [NSString stringWithFormat:@"Property attributes: %@", property.name];
            [_dataStructure.logs addObject:errLog2];
        } else {
            NSString *errLog1 = [NSString stringWithFormat:@"Property attributes: %@", property.name];
            [_dataStructure.logs addObject:errLog1];
            
            NSString *errLog2 = [NSString stringWithFormat:@"Property attributes: %@", property.name];
            [_dataStructure.logs addObject:errLog2];
        }
        
        return;
    }
    
    [_dataStructure.properties addObject:property.name];
}

- (void)visitRemainingProperties:(CDVisitorPropertyState *)propertyState; {
    NSArray *remaining = propertyState.remainingProperties;
    
    if (CDIsNonEmptyArr(remaining)) {
        for (CDOCProperty *property in remaining)
            [self visitProperty:property];
    }
}

#pragma mark Common Helper

- (void)_writeToFile {
    if (CDIsEmptyStr(_outputPath)) {
        NSLog(@"Write YAML file> Invalid output path");
        return;
    }
    
    id interfaceDatas = [self _buildInterfacesDictionary];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.yml", _dataStructure.interfaceName];
    fileName = [_outputPath stringByAppendingPathComponent:fileName];
    
    _outputStream = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
    
    NSError *error = nil;
    [YAMLSerialization writeObject:interfaceDatas
                      toYAMLStream:_outputStream
                           options:kYAMLWriteOptionSingleDocument
                             error:&error];
    
    if (error) {
        NSLog(@"Write YAML file> with error: %@", error.localizedDescription);
    }
}

- (NSDictionary *)_buildInterfacesDictionary {
    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    
    if (CDIsEmptyStr(_dataStructure.interfaceName)) {
        [_dataStructure.logs addObject:@"Invalid interface name"];
    }
    
    dataDict[@"name"] = CDNullObjToEmptyStr(_dataStructure.interfaceName);
    dataDict[@"ivars"] = [self _buildInterfaceContentDictWithNames:_dataStructure.ivars];
    dataDict[@"properties"] = [self _buildInterfaceContentDictWithNames:_dataStructure.properties];
    dataDict[@"instancemethods"] = [self _buildInterfaceContentDictWithNames:_dataStructure.instanceMethods];
    dataDict[@"classmethods"] = [self _buildInterfaceContentDictWithNames:_dataStructure.classMethods];
    dataDict[@"logs"] = _dataStructure.logs;
    
    return @{ @"interfaces" : @[dataDict] };
}

- (NSArray *)_buildInterfaceContentDictWithNames:(NSArray<NSString *> *)names {
    if (CDIsEmptyArr(names)) {
        return @[];
    }
    
    NSMutableArray<NSDictionary<NSString *, NSString *> *> *interfaceContents = [NSMutableArray new];
    
    for (NSString *name in names) {
        if (CDIsNonEmptyStr(name)) {
            [interfaceContents addObject:@{ @"name" : name }];
        }
    }

    return interfaceContents;
}

- (void)_tryToRemoveDirectory {
    NSError *error = nil;
    NSFileManager *fileMgr = NSFileManager.defaultManager;
    BOOL isExistDir = [fileMgr fileExistsAtPath:_outputPath isDirectory:nil];
    
    if (isExistDir) {
        [fileMgr removeItemAtPath:_outputPath error:&error];
    }
    
    [fileMgr createDirectoryAtPath:_outputPath
       withIntermediateDirectories:YES
                        attributes:nil
                             error:&error];
    
    if (error) {
        NSLog(@"Remove Directory before write file failed: %@", error.localizedDescription);
    }
}

- (void)_reset {
    _dataStructure = [CDYAMLDataStructure new];
}

#pragma mark - <CDTypeControllerDelegate>

- (void)typeController:(CDTypeController *)typeController didReferenceClassName:(NSString *)name {}

- (void)typeController:(CDTypeController *)typeController didReferenceProtocolNames:(NSArray *)names {}

@end // @implementation CDYAMLClassDumpVisistor
