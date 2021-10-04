//
//  main.m
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import <Foundation/Foundation.h>

#import "YAMLSerialization.h"
#import "GCObfuscatedVerification.h"


int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        
        NSString *path1 = @"/Users/geotech/Downloads/spec12-example-2-9-single-document-with-two-comments.yaml";
        NSInputStream *stream1 = [[NSInputStream alloc]
                                  initWithFileAtPath: path1];
        NSError *err = nil;
        NSMutableArray *yaml1 = [YAMLSerialization YAMLWithStream: stream1
                                                         options: kYAMLReadOptionStringScalars
                                                           error: &err];
        printf("Found %i docs in %s error: %s\n", (int)yaml1.count, path1.UTF8String, err.description.UTF8String);
        NSLog(@"file info: %@", yaml1.description);
        
//        GCObfuscatedVerification *obfuscatedVerifycation = [GCObfuscatedVerification new];
//        [obfuscatedVerifycation verifyWithBlackListFile:@"/Users/geotech/Downloads/blacklist.yml"
//                                             dumpedPath:@""];
    }
    return 0;
}
