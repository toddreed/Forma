//
// NSObject+QEditor.h
//
// © Reaction Software Inc., 2013
//


#import <Foundation/Foundation.h>

#import "QObjectEditorViewController.h"

/// The QEditor category on NSObject provides default support for editing objects with
/// QObjectEditorViewController. Override these methods to customize the editing UI for a model
/// object.
@interface NSObject (QEditor)

+ (Class)propertyEditorClass;
+ (Class)propertyEditorClassForObjcType:(const char *)typeEncoding;

- (QPropertyEditor *)propertyEditorForKey:(NSString *)aKey;
- (NSString *)editorTitle;
- (NSArray *)propertyGroups;
- (QObjectEditorViewController *)objectEditorViewController;

@end
