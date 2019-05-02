//
// NSManagedObject+RSEditor.m
//
// © Reaction Software Inc., 2013
//


#import "NSManagedObject+RSEditor.h"
#import "../FormItems/RSFloatPropertyEditor.h"
#import "../FormItems/RSTextInputPropertyEditor.h"
#import "../FormItems/RSBooleanPropertyEditor.h"
#import "../Core/NSString+RSCamelCase.h"


@implementation NSManagedObject (RSEditor)

- (nullable RSFormItem *)formItemForKey:(nonnull NSString *)key
{
    NSEntityDescription *entityDescription = self.entity;
    NSDictionary *attributesByName = entityDescription.attributesByName;
    NSAttributeDescription *attributeDescription = attributesByName[key];
    NSAttributeType type = attributeDescription.attributeType;

    Class formItemClass = nil;

    switch (type)
    {
            
        case NSInteger16AttributeType:
        case NSInteger32AttributeType:
        case NSInteger64AttributeType:
            
        case NSDecimalAttributeType:
        case NSDoubleAttributeType:
        case NSFloatAttributeType:
            formItemClass = [RSFloatPropertyEditor class];
            break;
            
        case NSStringAttributeType:
            formItemClass = [RSTextInputPropertyEditor class];
            break;
            
        case NSBooleanAttributeType:
            formItemClass = [RSBooleanPropertyEditor class];
            break;
            
        case NSDateAttributeType:

        case NSUndefinedAttributeType:
        case NSBinaryDataAttributeType:
        case NSTransformableAttributeType:
        case NSObjectIDAttributeType:
            // pass through to default
        default:
            break;
    }
    
    if (formItemClass != nil)
    {
        NSString *propertyTitle = [key rs_stringByConvertingCamelCaseToTitleCase];
        return [[formItemClass alloc] initWithKey:key ofObject:self title:propertyTitle];
    }
    else
        return nil;
}

- (nonnull NSArray<RSFormSection *> *)formSections
{
    NSEntityDescription *entityDescription = self.entity;
    NSDictionary *attributesByName = entityDescription.attributesByName;

    NSMutableArray *editors = [NSMutableArray array];
    
    for (NSString *propertyKey in attributesByName)
    {
        RSFormItem *editor = [self formItemForKey:propertyKey];
        if (editor != nil)
            [editors addObject:editor];
    }
    
    RSFormSection *group = [[RSFormSection alloc] initWithTitle:nil formItemArray:editors];
    return @[group];
}

@end
