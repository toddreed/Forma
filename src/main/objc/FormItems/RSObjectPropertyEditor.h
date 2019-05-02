//
// RSObjectPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyFormItem.h"

/// RSObjectPropertyEditor is a property editor for editing object properties. This must only be used
/// with a RSObjectEditorViewController that is on the stack of a UINavigationController. When
/// selected, a RSObjectPropertyEditor will push a new RSObjectEditorViewController on the navigation
/// stack that edits the object. -descriptionWithLocale: is invoked on the property object to obtain
/// a summary of the object's value that is rendered as the detailed text of the table cell for this
/// editor. If the object does not respond to -descriptionWithLocale:, -description is used.
@interface RSObjectPropertyEditor : RSPropertyFormItem
@end

