//
// Forma
// NSObject+RSProperties.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef BOOL (*_Nonnull RSPropertyFilter)(objc_property_t _Nonnull);

BOOL RSMutablePropertyFilter(objc_property_t _Nonnull);
BOOL RSReadOnlyPropertyFilter(objc_property_t _Nonnull);

@interface NSObject (RSProperties)

// Returns an array of NSStrings naming the declared properties of this class only (i.e. properties
// in the super class are not listed).
+ (nonnull NSArray<NSString *> *)rs_declaredPropertyNamesMatchingFilter:(RSPropertyFilter)filter;
+ (nonnull NSArray<NSString *> *)rs_declaredPropertyNames;

// Returns an array of NSStrings naming all the declared properties of this class and its
// superclasses.
+ (nonnull NSArray<NSString *> *)rs_allDeclaredPropertyNames;

+ (nullable const char *)rs_objCTypeOfProperty:(nonnull NSString *)propertyName;
+ (nullable Class)rs_classOfProperty:(nonnull NSString *)propertyName;

@end
