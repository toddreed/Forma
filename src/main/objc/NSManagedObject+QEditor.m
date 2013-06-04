//
//  NSManagedObject+QEditor.m
//  Pack
//
//  Created by Todd Reed on 2012-10-27.
//  Copyright (c) 2012 Reaction Software Inc. All rights reserved.
//

#import "NSManagedObject+QEditor.h"
#import "QFloatPropertyEditor.h"
#import "QTextInputPropertyEditor.h"
#import "QBooleanPropertyEditor.h"
#import "NSString+QCamelCase.h"
#import "QPropertyGroup.h"

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
