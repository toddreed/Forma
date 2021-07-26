//
// Forma
// RSFormContainer.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

/// RSTextEditingMode is used to describe that status of any text editing from a UITextField in
/// a form.
typedef NS_ENUM(NSInteger, RSTextEditingMode)
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
};


@class RSTextInputPropertyEditor;
@class UIViewController;
@protocol RSFormContainer;
@class RSForm;


typedef NS_ENUM(NSInteger, RSFormAction)
{
    RSFormActionCommit,
    RSFormActionCancel
};


@protocol RSFormContainerDelegate <NSObject>

- (void)formContainer:(nonnull id<RSFormContainer>)formContainer didEndEditingSessionWithAction:(RSFormAction)action;

@end

@protocol RSFormContainer <NSObject>

@property (nonatomic, strong, readonly, nonnull) RSForm *form;

@property (nonatomic, weak, nullable) id<RSFormContainerDelegate> formDelegate;

@property (nonatomic, strong, readonly, nonnull) UITableView *tableView;

/// This is either nil, or a text field that is currently the first responder (and hence the
/// keyboard is displayed). If a table cell is touched, we'll resign the first responder and
/// hide the keyboard.
@property (nonatomic, weak, nullable) UITextField *activeTextField;

@property (nonatomic) RSTextEditingMode textEditingMode;

@end
