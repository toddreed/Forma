//
// QRelationshipPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import "QPropertyEditor.h"

/// A QRelationshipPropertyEditor is a property editor that edits a Core Data relationship. This
/// must only be used with a QObjectEditorViewController that is on the stack of a
/// UINavigationController. Currently, this class only supports to-one relationships. The UI for a
/// QRelationshipPropertyEditor pushes a view controller that displays a list of items in a table
/// view, and has a check mark to indicated the selected item.
@interface QRelationshipPropertyEditor : QPropertyEditor

@end
