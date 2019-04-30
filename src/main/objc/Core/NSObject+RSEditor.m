//
// NSObject+RSEditor.m
//
// © Reaction Software Inc., 2013
//


#import "NSObject+RSEditor.h"
#import "NSObject+RSProperties.h"
#import "NSString+RSCamelCase.h"
#import "../PropertyEditors/RSObjectPropertyEditor.h"
#import "../PropertyEditors/RSBooleanPropertyEditor.h"
#import "../PropertyEditors/RSFloatPropertyEditor.h"
#import "../PropertyEditors/RSTextInputPropertyEditor.h"


@implementation NSObject (RSEditor)

+ (nullable Class)propertyEditorClass
{
    return [RSObjectPropertyEditor class];
}

+ (nullable Class)propertyEditorClassForObjcType:(const char *)typeEncoding
{
    Class cls = nil;
    
    if (strcmp(typeEncoding, @encode(BOOL)) == 0)
        cls = [RSBooleanPropertyEditor class];
    else if (strcmp(typeEncoding, @encode(float)) == 0)
        cls = [RSFloatPropertyEditor class];

    return cls;
}

- (nullable RSPropertyEditor *)propertyEditorForKey:(NSString *)key
{
    const char *typeEncoding = [[self class] rs_objCTypeOfProperty:key];

    Class propertyEditorClass = nil;
    
    if (typeEncoding[0] == '@')
        propertyEditorClass = [[[self class] rs_classOfProperty:key] propertyEditorClass];
    else
        propertyEditorClass = [[self class] propertyEditorClassForObjcType:typeEncoding];
    
    if (propertyEditorClass != nil)
    {
        NSString *propertyTitle = [key rs_stringByConvertingCamelCaseToTitleCase];
        return [[propertyEditorClass alloc] initWithKey:key ofObject:self title:propertyTitle];
    }
    else
        return nil;
}

- (nonnull NSString *)editorTitle
{
    return [NSStringFromClass([self class]) rs_stringByConvertingCamelCaseToTitleCase];
}

- (nonnull NSArray<RSPropertyGroup *> *)propertyGroups
{
    NSMutableArray *editors = [NSMutableArray array];
    for (NSString *propertyKey in [[self class] rs_declaredPropertyNamesMatchingFilter:RSMutablePropertyFilter])
    {
        RSPropertyEditor *editor = [[self class] propertyEditorForKey:propertyKey];
        if (editor != nil)
            [editors addObject:editor];
    }
    
    RSPropertyGroup *group = [[RSPropertyGroup alloc] initWithTitle:nil propertyEditorArray:editors];
    return @[group];
}

- (nonnull RSObjectEditorViewController *)objectEditorViewController
{
    return [[RSObjectEditorViewController alloc] initWithObject:self];
}

@end

@implementation NSString (RSEditor)

+ (nullable Class)propertyEditorClass
{
    return [RSTextInputPropertyEditor class];
}

@end

