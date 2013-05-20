// 
//  NSObject+QProperties.h
//  WordHunt
// 
//  Created by Todd Reed on 10-05-05.
//  Copyright 2010 Reaction Software Inc. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef BOOL (*QPropertyFilter)(objc_property_t);

BOOL QMutablePropertyFilter(objc_property_t);
BOOL QReadOnlyPropertyFilter(objc_property_t);

@interface NSObject (QProperties)

// Returns an array of NSStrings naming the declared properties of this class only (i.e. properties
// in the super class are not listed).
+ (NSArray *)Q_declaredPropertyNamesMatchingFilter:(QPropertyFilter)filter;
+ (NSArray *)Q_declaredPropertyNames;

// Returns an array of NSStrings naming all the declared properties of this class and its
// superclasses.
+ (NSArray *)Q_allDeclaredPropertyNames;

+ (const char *)Q_objCTypeOfProperty:(NSString *)propertyName;
+ (Class)Q_classOfProperty:(NSString *)propertyName;

@end
