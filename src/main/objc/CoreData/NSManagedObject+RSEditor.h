//
// NSManagedObject+RSEditor.h
//
// © Reaction Software Inc., 2013
//


#import <CoreData/CoreData.h>
#import "../PropertyEditors/RSPropertyEditor.h"

@interface NSManagedObject (RSEditor)

- (RSPropertyEditor *)propertyEditorForKey:(NSString *)key;
- (NSArray *)propertyGroups;

@end
