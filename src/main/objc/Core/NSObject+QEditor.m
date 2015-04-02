//
// NSObject+QEditor.m
//
// © Reaction Software Inc., 2013
//


#import "NSObject+QEditor.h"
#import "NSObject+QProperties.h"
#import "NSString+QCamelCase.h"
#import "../PropertyEditors/QObjectPropertyEditor.h"
#import "../PropertyEditors/QBooleanPropertyEditor.h"
#import "../PropertyEditors/QFloatPropertyEditor.h"
#import "../PropertyEditors/QTextInputPropertyEditor.h"


@implementation NSObject (QEditor)

+ (Class)propertyEditorClass
{
    return [QObjectPropertyEditor class];
}

+ (Class)propertyEditorClassForObjcType:(const char *)typeEncoding
{
    Class cls = nil;
    
    if (strcmp(typeEncoding, @encode(BOOL)) == 0)
        cls = [QBooleanPropertyEditor class];
    else if (strcmp(typeEncoding, @encode(float)) == 0)
        cls = [QFloatPropertyEditor class];

    return cls;
}

- (QPropertyEditor *)propertyEditorForKey:(NSString *)aKey
{
    const char *typeEncoding = [[self class] Q_objCTypeOfProperty:aKey];

    Class propertyEditorClass = nil;
    
    if (typeEncoding[0] == '@')
        propertyEditorClass = [[[self class] Q_classOfProperty:aKey] propertyEditorClass];
    else
        propertyEditorClass = [[self class] propertyEditorClassForObjcType:typeEncoding];
    
    if (propertyEditorClass != nil)
    {
        NSString *propertyTitle = [aKey Q_stringByConvertingCamelCaseToTitleCase];
        return [[propertyEditorClass alloc] initWithKey:aKey title:propertyTitle];
    }
    else
        return nil;
}

- (NSString *)editorTitle
{
    return [NSStringFromClass([self class]) Q_stringByConvertingCamelCaseToTitleCase];
}

/// Feature #118: Add object editor configuration via XML
- (NSArray *)propertyGroups
{
    NSMutableArray *editors = [NSMutableArray array];
    for (NSString *propertyKey in [[self class] Q_declaredPropertyNamesMatchingFilter:QMutablePropertyFilter])
    {
        QPropertyEditor *editor = [[self class] propertyEditorForKey:propertyKey];
        if (editor != nil)
            [editors addObject:editor];
    }
    
    QPropertyGroup *group = [[QPropertyGroup alloc] initWithTitle:nil propertyEditorArray:editors];
    return @[group];
}

- (QObjectEditorViewController *)objectEditorViewController
{
    return [[QObjectEditorViewController alloc] initWithObject:self];
}

@end

@implementation NSString (QEditor)

+ (Class)propertyEditorClass
{
    return [QTextInputPropertyEditor class];
}

@end
