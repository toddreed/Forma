//
// NSObject+RSForm.h
//
// © Reaction Software Inc., 2013
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
