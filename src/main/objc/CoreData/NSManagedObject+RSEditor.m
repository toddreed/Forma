//
// NSManagedObject+RSEditor.m
//
// © Reaction Software Inc., 2013
//


#import "NSManagedObject+RSEditor.h"
#import "../PropertyEditors/RSFloatPropertyEditor.h"
#import "../PropertyEditors/RSTextInputPropertyEditor.h"
#import "../PropertyEditors/RSBooleanPropertyEditor.h"
#import "../Core/NSString+RSCamelCase.h"


@implementation NSManagedObject (RSEditor)

- (nullable RSPropertyEditor *)propertyEditorForKey:(nonnull NSString *)key
{
    NSEntityDescription *entityDescription = self.entity;
    NSDictionary *attributesByName = entityDescription.attributesByName;
    NSAttributeDescription *attributeDescription = attributesByName[key];
    NSAttributeType type = attributeDescription.attributeType;

    Class propertyEditorClass = nil;

    switch (type)
    {
            
        case NSInteger16AttributeType:
        case NSInteger32AttributeType:
        case NSInteger64AttributeType:
            
        case NSDecimalAttributeType:
        case NSDoubleAttributeType:
        case NSFloatAttributeType:
            propertyEditorClass = [RSFloatPropertyEditor class];
            break;
            
        case NSStringAttributeType:
            propertyEditorClass = [RSTextInputPropertyEditor class];
            break;
            
        case NSBooleanAttributeType:
            propertyEditorClass = [RSBooleanPropertyEditor class];
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
    
    if (propertyEditorClass != nil)
    {
        NSString *propertyTitle = [key rs_stringByConvertingCamelCaseToTitleCase];
        return [[propertyEditorClass alloc] initWithKey:key ofObject:self title:propertyTitle];
    }
    else
        return nil;
}

- (nonnull NSArray<RSPropertyGroup *> *)propertyGroups
{
    NSEntityDescription *entityDescription = self.entity;
    NSDictionary *attributesByName = entityDescription.attributesByName;

    NSMutableArray *editors = [NSMutableArray array];
    
    for (NSString *propertyKey in attributesByName)
    {
        RSPropertyEditor *editor = [self propertyEditorForKey:propertyKey];
        if (editor != nil)
            [editors addObject:editor];
    }
    
    RSPropertyGroup *group = [[RSPropertyGroup alloc] initWithTitle:nil propertyEditorArray:editors];
    return @[group];
}

@end
