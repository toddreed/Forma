//
// NSObject+RSForm.m
//
// © Reaction Software Inc., 2013
//


#import "NSObject+RSForm.h"
#import "NSObject+RSProperties.h"
#import "NSString+RSCamelCase.h"
#import "../FormItems/RSObjectPropertyEditor.h"
#import "../FormItems/RSBooleanPropertyEditor.h"
#import "../FormItems/RSFloatPropertyEditor.h"
#import "../FormItems/RSTextInputPropertyEditor.h"


@implementation NSObject (RSForm)

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

- (nonnull RSForm *)form
{
    RSForm *form = [[RSForm alloc] initWithTitle:self.formTitle];
    form.sections = self.formSections;
    return form;
}

- (nonnull NSString *)formTitle
{
    return [NSStringFromClass([self class]) rs_stringByConvertingCamelCaseToTitleCase];
}

- (nonnull NSArray<RSFormSection *> *)formSections
{
    NSMutableArray *formItems = [NSMutableArray array];
    for (NSString *propertyKey in [[self class] rs_declaredPropertyNamesMatchingFilter:RSMutablePropertyFilter])
    {
        RSFormItem *formItem = [[self class] formItemForKey:propertyKey];
        if (formItem != nil)
            [formItems addObject:formItem];
    }
    
    RSFormSection *formSection = [[RSFormSection alloc] initWithTitle:nil formItemArray:formItems];
    return @[formSection];
}

- (nonnull UIViewController<RSFormContainer> *)formViewController
{
    return [[RSFormViewController alloc] initWithForm:self.form];
}

@end

@implementation NSString (RSForm)

+ (nullable Class)formItemClass
{
    return [RSTextInputPropertyEditor class];
}

@end

