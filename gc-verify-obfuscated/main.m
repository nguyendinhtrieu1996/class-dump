//
//  main.m
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import <Foundation/Foundation.h>

#import "GCObfuscatedVerification.h"
#import "GCObfuscatedVerificationResponse.h"


void print_usage(void)
{
    fprintf(stderr,
            "\n\n---------------------------------------\n"
            "gc-verify-obfuscated\n"
            "Usage: gc-verify-obfuscated [blacklist file path] [dump filepath]"
            );
}

#define GC_MIN_ARGC 3


int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        if (argc < GC_MIN_ARGC) {
            print_usage();
            exit(1);
        }
        
        const char *blacklistFilePath = argv[argc - 2];
        const char *dumpFilePath = argv[argc - 1];
        if (blacklistFilePath == NULL || dumpFilePath == NULL) {
            fprintf(stderr, "\n Invalid file path");
            print_usage();
            exit(1);
        }
        
        GCObfuscatedVerification *obfuscatedVerifycation = [GCObfuscatedVerification new];
        GCObfuscatedVerificationResponse *response
        = [obfuscatedVerifycation verifyWithBlackListFile:[NSString stringWithUTF8String:blacklistFilePath]
                                               dumpedPath:[NSString stringWithUTF8String:dumpFilePath]];
        
        printf("\n\n=======================VERIFY FINISH=======================\n\n");
        
        if (response.result == GCObfuscatedVerificationResult_Different) {
            printf("\nVerify FAILED");
            printf("\nLog: %s", response.finalizeMessages.UTF8String);
            printf("\n\n=======================END=======================\n\n");
            exit(1);
        }
        
        printf("\nLog: %s", response.finalizeMessages.UTF8String);
        printf("\n\n=======================END=======================\n\n");
    }
    return 0;
}
