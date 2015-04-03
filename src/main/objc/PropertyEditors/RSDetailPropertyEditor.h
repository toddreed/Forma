//
// RSDetailPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyEditor.h"

/// A RSDetailPropertyEditor is a pseudo property editor that edits some ancillary object that is not
/// directly part of the object graph of the primary object being edited. This must only be used
/// with a RSObjectEditorViewController that is on the stack of a UINavigationController. The UI for
/// a RSDetailPropertyEditor displays the object's editor title and a summary of the object's value
/// obtained with -descriptionWithLocale:, or if this method is not defined, -description.
@interface RSDetailPropertyEditor : RSPropertyEditor

/// Designated initializer.
- (id)initWithTitle:(NSString *)aTitle object:(NSObject *)aObject;

@end
