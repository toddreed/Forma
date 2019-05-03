//
// Forma
// RSObjectPropertyEditor.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSPropertyFormItem.h"

/// RSObjectPropertyEditor is a property editor for editing object properties. This must only be
/// used with a form container that is on the stack of a UINavigationController. When selected,
/// a RSObjectPropertyEditor will push a new RSFormViewController on the navigation
/// stack that edits the object. -descriptionWithLocale: is invoked on the property object to
/// obtain a summary of the object’s value that is rendered as the detailed text of the table
/// cell for this editor. If the object does not respond to -descriptionWithLocale:,
/// -description is used.
@interface RSObjectPropertyEditor : RSPropertyFormItem
@end

