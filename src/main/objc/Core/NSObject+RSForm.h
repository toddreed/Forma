//
// Forma
// NSObject+RSForm.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>

#import "RSFormViewController.h"

/// The RSForm category on NSObject provides default support for editing objects with
/// RSFormViewController. Override these methods to customize the editing UI for a model
/// object.
@interface NSObject (RSForm)

+ (nullable Class)formItemClass;
+ (nullable Class)formItemClassForObjcType:(nonnull const char *)typeEncoding;

- (nullable RSFormItem *)formItemForKey:(nonnull NSString *)key;

@property (nonatomic, copy, readonly, nonnull) RSForm *form;
@property (nonatomic, copy, readonly, nonnull) NSString *formTitle;
@property (nonatomic, copy, readonly, nonnull) NSArray<RSFormSection *> *formSections;
@property (nonatomic, readonly, strong, nonnull) UIViewController<RSFormContainer> *formViewController;

@end
