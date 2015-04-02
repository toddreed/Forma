//
// NSObject+RSProperties.h
//
// © Reaction Software Inc., 2013
//


#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef BOOL (*RSPropertyFilter)(objc_property_t);

BOOL RSMutablePropertyFilter(objc_property_t);
BOOL RSReadOnlyPropertyFilter(objc_property_t);

@interface NSObject (RSProperties)

// Returns an array of NSStrings naming the declared properties of this class only (i.e. properties
// in the super class are not listed).
+ (NSArray *)rs_declaredPropertyNamesMatchingFilter:(RSPropertyFilter)filter;
+ (NSArray *)rs_declaredPropertyNames;

// Returns an array of NSStrings naming all the declared properties of this class and its
// superclasses.
+ (NSArray *)rs_allDeclaredPropertyNames;

+ (const char *)rs_objCTypeOfProperty:(NSString *)propertyName;
+ (Class)rs_classOfProperty:(NSString *)propertyName;

@end
