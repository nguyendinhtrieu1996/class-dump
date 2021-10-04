//
//  GCObfuscatedVerifyCommonMacros.h
//  class-dump
//
//  Created by Trieu Nguyen on 04/10/2021.
//

#ifndef GCObfuscatedVerifyCommonMacros_h
#define GCObfuscatedVerifyCommonMacros_h


#define GC_IsValidClass(obj, class) (obj && [obj isKindOfClass:class])
#define GC_IsNonEmptyStr(str) (str && [str isKindOfClass:NSString.self] && str.length > 0)
#define GC_IsEmptyStr(str) (!GC_IsNonEmptyStr(str))

#define GC_NULLObjToEmptyStr(obj) (obj != NULL ? obj : @"")

#endif /* GCObfuscatedVerifyCommonMacros_h */
