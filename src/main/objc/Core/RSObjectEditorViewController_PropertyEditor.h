//
//  RSObjectEditorViewController_PropertyEditor.h
//  Object Editor
//
//  Created by Todd Reed on 2015-04-02.
//  Copyright (c) 2015 Reaction Software Inc. All rights reserved.
//

#import "RSObjectEditorViewController.h"

/// RSTextEditingMode is used to describe that status of any text editing from a UITextField by
/// RSObjectEditorViewController.
typedef enum RSTextEditingMode
{
    /// Not currently editing any text.
    RSTextEditingModeNotEditing,

    /// Currently editing text.
    RSTextEditingModeEditing,

    /// Currently editing text and -cancelEditing was invoked.
    RSTextEditingModeCancelling,

    /// Currently editing text and -finishEditingForce: was invoked with NO.
    RSTextEditingModeFinishing,

    /// Currently editing text and -finishEditingForce: was invoked with YES. Indicates that edit
    /// MUST finish.
    RSTextEditingModeFinishingForced
} RSTextEditingMode;


/// Defines additional methods available to property editors.
@interface RSObjectEditorViewController ()

/// This is either nil, or a text field that is currently the first responder (and hence the
/// keyboard is displayed). If a table cell is touched, we'll resign the first responder and
/// hide the keyboard.
@property (nonatomic, weak) UITextField *activeTextField;

/// The last RSTextInputPropertyEditor found in propertyGroups. We keep this so we can automatically
/// set the return key type to UIReturnKeyDone if autoTextFieldNavigation is YES.
@property(nonatomic, readonly) RSTextInputPropertyEditor *lastTextInputPropertyEditor;

@property (nonatomic) RSTextEditingMode textEditingMode;

- (RSPropertyEditor *)p_propertyEditorForTag:(NSInteger)tag;
- (RSPropertyEditor *)p_propertyEditorForIndexPath:(NSIndexPath *)indexPath;
- (RSTextInputPropertyEditor *)p_findLastTextInputPropertyEditor;
- (NSIndexPath *)p_findNextTextInputAfterEditor:(RSPropertyEditor *)editor;

@end
