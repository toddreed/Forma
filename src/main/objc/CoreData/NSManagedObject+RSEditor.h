//
// NSManagedObject+RSEditor.h
//
// © Reaction Software Inc., 2013
//


#import <CoreData/CoreData.h>
#import "../FormItems/RSFormItem.h"
#import "../Core/RSFormSection.h"

@interface NSManagedObject (RSEditor)

- (nullable RSFormItem *)formItemForKey:(nonnull NSString *)key;
- (nonnull NSArray<RSFormSection *> *)formSections;

@end
