//
//  GCYAMLFileReader.m
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import "GCYAMLFileReader.h"

#import "YAMLSerialization.h"


@interface GCYAMLFileReader ()
{
    NSInputStream *_inputStream;
}
@end // GeoComplyMyIpServiceProtocol


@implementation GCYAMLFileReader

- (id)readFileAtPath:(NSString *)path error:(NSError **)error {
    _inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    
    return [YAMLSerialization objectWithYAMLStream:_inputStream
                                           options:kYAMLReadOptionStringScalars
                                             error:error];
}

@end // @implementation GCYAMLFileReader
