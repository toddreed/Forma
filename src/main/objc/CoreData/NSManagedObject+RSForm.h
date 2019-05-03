//
// Forma
// NSManagedObject+RSForm.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <CoreData/CoreData.h>
#import "../FormItems/RSFormItem.h"
#import "../Core/RSFormSection.h"

@interface NSManagedObject (RSForm)

- (nullable RSFormItem *)formItemForKey:(nonnull NSString *)key;
- (nonnull NSArray<RSFormSection *> *)formSections;

@end
