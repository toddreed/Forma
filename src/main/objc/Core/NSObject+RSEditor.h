//
// NSObject+RSEditor.h
//
// © Reaction Software Inc., 2013
//


#import <Foundation/Foundation.h>

#import "RSObjectEditorViewController.h"

/// The RSEditor category on NSObject provides default support for editing objects with
/// RSObjectEditorViewController. Override these methods to customize the editing UI for a model
/// object.
@interface NSObject (RSEditor)

+ (nullable Class)formItemClass;
+ (nullable Class)formItemClassForObjcType:(nonnull const char *)typeEncoding;

- (nullable RSFormItem *)formItemForKey:(nonnull NSString *)key;

@property (nonatomic, readonly, copy, nonnull) NSString *editorTitle;
@property (nonatomic, readonly, copy, nonnull) NSArray<RSFormSection *> *formSections;
@property (nonatomic, readonly, strong, nonnull) RSObjectEditorViewController *objectEditorViewController;

@end
