//
// NSManagedObject+RSEditor.h
//
// © Reaction Software Inc., 2013
//


#import <CoreData/CoreData.h>
#import "../PropertyEditors/RSPropertyEditor.h"
#import "../Core/RSPropertyGroup.h"

@interface NSManagedObject (RSEditor)

- (nullable RSPropertyEditor *)propertyEditorForKey:(nonnull NSString *)key;
- (nonnull NSArray<RSPropertyGroup *> *)propertyGroups;

@end
