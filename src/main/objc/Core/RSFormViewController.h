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
@interface RSFormViewController : UITableViewController <RSFormContainer>

/// A block that is invoked when the editor should be closed because the user pressed the Done or
/// Cancel button.
@property (nonatomic, copy, nullable) void (^completionBlock)(RSFormViewController *_Nonnull viewController, BOOL cancelled);

@property (nonatomic) BOOL showCancelButton;
@property (nonatomic) BOOL showDoneButton;

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil UNAVAILABLE_ATTRIBUTE;

- (nonnull instancetype)initWithForm:(nonnull RSForm *)form NS_DESIGNATED_INITIALIZER;

/// Forces any in-progress editing to complete. Notably, if the text field is the first responder,
/// it will resign first responder status, causing the text field's value to be committed to the
/// edited object. If the model object implements validation and validation fails, then the
/// UITextField will remain the first responder, the model object will not be updated, and
/// -finishEditingForce: will return NO.
- (BOOL)finishEditingForce:(BOOL)force;

/// Cancels the current editing session, discarding any in-progress editing of a UITextField.
- (void)cancelEditing;

// Invoked when the done button is pressed. Can be called to simulate the done button being pressed
// programmatically. If you override this method, you must call super.
- (void)donePressed;

// Invoked when the cancel button is pressed.
- (void)cancelPressed;

@end
