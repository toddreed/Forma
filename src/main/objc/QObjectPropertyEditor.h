//
//  QObjectPropertyEditor.h
//  WordHunt
//
//  Created by Todd Reed on 11-01-20.
//  Copyright 2011 Reaction Software Inc. All rights reserved.
//

#import "QPropertyEditor.h"

/// QObjectPropertyEditor is a property editor for editing object properties. This must only be used
/// with a QObjectEditorViewController that is on the stack of a UINavigationController. When
/// selected, a QObjectPropertyEditor will push a new QObjectEditorViewController on the navigation
/// stack that edits the object. -descriptionWithLocale: is invoked on the property object to obtain
/// a summary of the object's value that is rendered as the detailed text of the table cell for this
/// editor. If the object does not respond to -descriptionWithLocale:, -description is used.
@interface QObjectPropertyEditor : QPropertyEditor
@end

