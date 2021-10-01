//
//  CDInternalMacros.h
//  class-dump
//
//  Created by Trieu Nguyen on 30/09/2021.
//

#ifndef CDInternalMacros_h
#define CDInternalMacros_h

#define CDIsNonEmptyStr(str) (str.length > 0)
#define CDIsEmptyStr(str) (!CDIsNonEmptyStr(str))
#define CDIsNonEmptyArr(arr) (arr.count > 0)
#define CDIsEmptyArr(arr) (!CDIsNonEmptyArr(arr))
#define CDNullObjToEmptyStr(obj) ((obj == nil) ? @"" : obj)

#endif /* CDInternalMacros_h */
