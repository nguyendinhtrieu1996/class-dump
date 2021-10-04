//
//  main.m
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import <Foundation/Foundation.h>

#import "GCObfuscatedVerification.h"
#import "GCObfuscatedVerificationResponse.h"


int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        GCObfuscatedVerification *obfuscatedVerifycation = [GCObfuscatedVerification new];
        GCObfuscatedVerificationResponse *response
        = [obfuscatedVerifycation verifyWithBlackListFile:@"/Users/geotech/Downloads/blacklist.yml"
                                               dumpedPath:@"/Users/geotech/Downloads/dump"];
        
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
