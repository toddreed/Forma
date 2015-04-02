//
// NSManagedObject+QEditor.h
//
// © Reaction Software Inc., 2013
//


#import <CoreData/CoreData.h>
#import "../PropertyEditors/QPropertyEditor.h"

@interface NSManagedObject (QEditor)

- (QPropertyEditor *)propertyEditorForKey:(NSString *)key;
- (NSArray *)propertyGroups;

@end
