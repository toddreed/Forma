//
// NSManagedObject+QEditor.m
//
// © Reaction Software Inc., 2013
//


#import "NSManagedObject+QEditor.h"
#import "../PropertyEditors/QFloatPropertyEditor.h"
#import "../PropertyEditors/QTextInputPropertyEditor.h"
#import "../PropertyEditors/QBooleanPropertyEditor.h"
#import "../Core/NSString+QCamelCase.h"
#import "../Core/QPropertyGroup.h"

@implementation NSManagedObject (QEditor)

- (QPropertyEditor *)propertyEditorForKey:(NSString *)key
{
    NSEntityDescription *entityDescription = [self entity];
    NSDictionary *attributesByName = [entityDescription attributesByName];
    NSAttributeDescription *attributeDescription = [attributesByName objectForKey:key];
    NSAttributeType type = [attributeDescription attributeType];

    Class propertyEditorClass = nil;

    switch (type)
    {
            
        case NSInteger16AttributeType:
        case NSInteger32AttributeType:
        case NSInteger64AttributeType:
            
        case NSDecimalAttributeType:
        case NSDoubleAttributeType:
        case NSFloatAttributeType:
            propertyEditorClass = [QFloatPropertyEditor class];
            break;
            
        case NSStringAttributeType:
            propertyEditorClass = [QTextInputPropertyEditor class];
            break;
            
        case NSBooleanAttributeType:
            propertyEditorClass = [QBooleanPropertyEditor class];
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
        NSString *propertyTitle = [key Q_stringByConvertingCamelCaseToTitleCase];
        return [[propertyEditorClass alloc] initWithKey:key title:propertyTitle];
    }
    else
        return nil;

}

- (NSArray *)propertyGroups
{
    NSEntityDescription *entityDescription = [self entity];
    NSDictionary *attributesByName = [entityDescription attributesByName];

    NSMutableArray *editors = [NSMutableArray array];
    
    for (NSString *propertyKey in attributesByName)
    {
        QPropertyEditor *editor = [self propertyEditorForKey:propertyKey];
        if (editor != nil)
            [editors addObject:editor];
    }
    
    QPropertyGroup *group = [[QPropertyGroup alloc] initWithTitle:nil propertyEditorArray:editors];
    return @[group];
}

@end
