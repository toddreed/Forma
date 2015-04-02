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

+ (Class)propertyEditorClass
{
    return [RSObjectPropertyEditor class];
}

+ (Class)propertyEditorClassForObjcType:(const char *)typeEncoding
{
    Class cls = nil;
    
    if (strcmp(typeEncoding, @encode(BOOL)) == 0)
        cls = [RSBooleanPropertyEditor class];
    else if (strcmp(typeEncoding, @encode(float)) == 0)
        cls = [RSFloatPropertyEditor class];

    return cls;
}

- (RSPropertyEditor *)propertyEditorForKey:(NSString *)aKey
{
    const char *typeEncoding = [[self class] rs_objCTypeOfProperty:aKey];

    Class propertyEditorClass = nil;
    
    if (typeEncoding[0] == '@')
        propertyEditorClass = [[[self class] rs_classOfProperty:aKey] propertyEditorClass];
    else
        propertyEditorClass = [[self class] propertyEditorClassForObjcType:typeEncoding];
    
    if (propertyEditorClass != nil)
    {
        NSString *propertyTitle = [aKey rs_stringByConvertingCamelCaseToTitleCase];
        return [[propertyEditorClass alloc] initWithKey:aKey title:propertyTitle];
    }
    else
        return nil;
}

- (NSString *)editorTitle
{
    return [NSStringFromClass([self class]) rs_stringByConvertingCamelCaseToTitleCase];
}

/// Feature #118: Add object editor configuration via XML
- (NSArray *)propertyGroups
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

- (RSObjectEditorViewController *)objectEditorViewController
{
    return [[RSObjectEditorViewController alloc] initWithObject:self];
}

@end

@implementation NSString (RSEditor)

+ (Class)propertyEditorClass
{
    return [RSTextInputPropertyEditor class];
}

@end

