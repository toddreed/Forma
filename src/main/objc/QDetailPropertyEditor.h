//
//  QDetailPropertyEditor.h
//  WordHunt
//
//  Created by Todd Reed on 11-01-20.
//  Copyright 2011 Reaction Software Inc. All rights reserved.
//

#import "QPropertyEditor.h"

/// A QDetailPropertyEditor is a psuedo property editor that edits some ancillary object that is not
/// directly part of the object graph of the primary object being edited. This must only be used
/// with a QObjectEditorViewController that is on the stack of a UINavigationController. The UI for
/// a QDetailPropertyEditor displays the object's editor title and a summary of the object's value
/// obtained with -descriptionWithLocale:, or if this method is not defined, -description.
@interface QDetailPropertyEditor : QPropertyEditor
{
    NSObject *editedObject;
}

/// Designated initializer.
- (id)initWithTitle:(NSString *)aTitle object:(NSObject *)aObject;

@end
