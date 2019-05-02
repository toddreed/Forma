//
// NSManagedObject+RSForm.h
//
// © Reaction Software Inc., 2013
//


#import <CoreData/CoreData.h>
#import "../FormItems/RSFormItem.h"
#import "../Core/RSFormSection.h"

@interface NSManagedObject (RSForm)

- (nullable RSFormItem *)formItemForKey:(nonnull NSString *)key;
- (nonnull NSArray<RSFormSection *> *)formSections;

@end
