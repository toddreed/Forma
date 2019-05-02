//
//  RSFormContainer.h
//  Object Editor
//
//  Created by Todd Reed on 2015-04-02.
//  Copyright (c) 2015 Reaction Software Inc. All rights reserved.
//

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


@class RSTextInputPropertyEditor;


@protocol RSFormContainer <NSObject>

@property (nonatomic, strong, readonly, nonnull) UITableView *tableView;

/// This is either nil, or a text field that is currently the first responder (and hence the
/// keyboard is displayed). If a table cell is touched, we'll resign the first responder and
/// hide the keyboard.
@property (nonatomic, weak, nullable) UITextField *activeTextField;

/// The last RSTextInputPropertyEditor found in formSections. We keep this so we can automatically
/// set the return key type to UIReturnKeyDone if autoTextFieldNavigation is YES.
@property(nonatomic, readonly, nullable) RSTextInputPropertyEditor *lastTextInputPropertyEditor;

@property (nonatomic) RSTextEditingMode textEditingMode;

- (nonnull RSFormItem *)formItemForIndexPath:(nonnull NSIndexPath *)indexPath;
- (nullable RSTextInputPropertyEditor *)findLastTextInputPropertyEditor;
- (nullable NSIndexPath *)findNextTextInputAfterFormItem:(nonnull RSFormItem *)item;

@end
