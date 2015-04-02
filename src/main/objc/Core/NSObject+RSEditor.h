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

+ (Class)propertyEditorClass;
+ (Class)propertyEditorClassForObjcType:(const char *)typeEncoding;

- (RSPropertyEditor *)propertyEditorForKey:(NSString *)aKey;
- (NSString *)editorTitle;
- (NSArray *)propertyGroups;
- (RSObjectEditorViewController *)objectEditorViewController;

@end
