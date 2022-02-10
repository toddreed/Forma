//
// Forma
// RSFormViewController.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "RSForm.h"
#import "RSFormContainer.h"


@class RSFormViewController;
@class RSTextInputPropertyEditor;


/// RSFormViewController is a view controller for provides an interface for modifying
/// the values of object properties. It’s appropriate for implementing the UI for settings,
/// inspectors, and forms.
///
/// RSFormViewController supports setting a table header and/or footer view. The header/footer
/// view must implement -sizeThatFits: to correctly size itself. A size of {`width`, 0} will be
/// passed to -sizeThatFits: during layout, where `width` is the table width. -sizeThatFits:
/// must calculate the height.
@interface RSFormViewController : UITableViewController <RSFormContainer, UIAdaptivePresentationControllerDelegate>

/// A block that is invoked when the editor should be closed because the user pressed the Done
/// or Cancel button.
@property (nonatomic, copy, nullable) void (^completionBlock)(RSFormViewController *_Nonnull viewController, BOOL cancelled);

/// Indicates whether to show a Cancel button. The Cancel button is shown in the navigation bar
/// (and thus requires that the form view controller is contained in a navigation controller).
@property (nonatomic) BOOL showCancelButton;

/// Indicates whether to show a Done button. The Cancel button is shown in the navigation bar
/// (and thus requires that the form view controller is contained in a navigation controller).
@property (nonatomic) BOOL showDoneButton;

/// If `submitButton` is set and `footerView` is *not* set, then `submitButton` will be added to
/// the bottom of the form in a custom table footer view. If `submitButton` is set and
/// `footerView` is set, then in most cases `submitButton` should be a subview of the footer
/// view. (Alternatively, `submitButton` could be a subview of the header view.)
@property (nonatomic, nullable) UIButton *submitButton;

/// If `headerImage` is set, then it will be added to the top of the form in a custom table
/// header view. If `headerView` is set, then this property is ignored.
@property (nonatomic, nullable) UIImage *headerImage;

/// A custom header view displayed before the form items. If the header view only displays an
/// image, set `headerImage` instead. The header view MUST implement -sizeThatFits:, preserving
/// the provided width and determining the height needed for the header.
@property (nonatomic, nullable) UIView *headerView;

/// A custom footer view displayed after the form items. If the footer view only displays a
/// submit button, setting `submitButton` but not `footerView` will automatically add the submit
/// button to a footer view. The footer view MUST implement -sizeThatFits:, preserving the
/// provided width and determining the height needed for the footer.
@property (nonatomic, nullable) UIView *footerView;

/// Indicates whether the form is enabled. When a form enabled it can be edited.
@property (nonatomic) BOOL enabled;

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil UNAVAILABLE_ATTRIBUTE;

/// Initializes the receiver with the provided form and the UITableViewStyleGrouped table view
/// style.
- (nonnull instancetype)initWithForm:(nonnull RSForm *)form;

/// Initializes the receiver with the provided form and table view style.
- (nonnull instancetype)initWithForm:(nonnull RSForm *)form style:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;

/// Forces any in-progress editing to complete. Notably, if the text field is the first
/// responder, it will resign first responder status, causing the text field’s value to be
/// committed to the edited object. If the model object implements validation and validation
/// fails, then the UITextField will remain the first responder, the model object will not be
/// updated, and -finishEditingForce: will return NO.
- (BOOL)finishEditingForce:(BOOL)force;

/// Cancels the current editing session, discarding any in-progress editing of a UITextField.
- (void)cancelEditing;

@end
