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

+ (nullable Class)formItemClass
{
    return [RSObjectPropertyEditor class];
}

+ (nullable Class)formItemClassForObjcType:(const char *)typeEncoding
{
    Class cls = nil;
    
    if (strcmp(typeEncoding, @encode(BOOL)) == 0)
        cls = [RSBooleanPropertyEditor class];
    else if (strcmp(typeEncoding, @encode(float)) == 0)
        cls = [RSFloatPropertyEditor class];

    return cls;
}

- (nullable RSFormItem *)formItemForKey:(NSString *)key
{
    const char *typeEncoding = [[self class] rs_objCTypeOfProperty:key];

    Class formItemClass = nil;
    
    if (typeEncoding[0] == '@')
        formItemClass = [[[self class] rs_classOfProperty:key] formItemClass];
    else
        formItemClass = [[self class] formItemClassForObjcType:typeEncoding];
    
    if (formItemClass != nil)
    {
        NSString *propertyTitle = [key rs_stringByConvertingCamelCaseToTitleCase];
        return [[formItemClass alloc] initWithKey:key ofObject:self title:propertyTitle];
    }
    else
        return nil;
}

- (nonnull NSString *)editorTitle
{
    return [NSStringFromClass([self class]) rs_stringByConvertingCamelCaseToTitleCase];
}

- (nonnull NSArray<RSFormSection *> *)formSections
{
    NSMutableArray *editors = [NSMutableArray array];
    for (NSString *propertyKey in [[self class] rs_declaredPropertyNamesMatchingFilter:RSMutablePropertyFilter])
    {
        RSFormItem *editor = [[self class] formItemForKey:propertyKey];
        if (editor != nil)
            [editors addObject:editor];
    }
    
    RSFormSection *group = [[RSFormSection alloc] initWithTitle:nil formItemArray:editors];
    return @[group];
}

- (nonnull RSObjectEditorViewController *)objectEditorViewController
{
    return [[RSObjectEditorViewController alloc] initWithObject:self];
}

@end

@implementation NSString (RSEditor)

+ (nullable Class)formItemClass
{
    return [RSTextInputPropertyEditor class];
}

@end

