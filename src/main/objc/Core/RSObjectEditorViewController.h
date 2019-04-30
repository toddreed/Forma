//
// RSObjectEditorViewController.h
//
// © Reaction Software Inc., 2013
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "../PropertyEditors/RSPropertyEditor.h"
#import "RSPropertyGroup.h"
#import "NSObject+RSEditor.h"

@class RSObjectEditorViewController;
@class RSTextInputPropertyEditor;

@protocol RSObjectEditorViewControllerDelegate

- (void)objectEditorViewControllerDidEnd:(nonnull RSObjectEditorViewController *)viewController cancelled:(BOOL)cancelled;

@end


typedef enum RSObjectEditorViewStyle
{
    RSObjectEditorViewStyleSettings,
    RSObjectEditorViewStyleForm
} RSObjectEditorViewStyle;

@interface RSObjectEditorViewController : UITableViewController <UITextFieldDelegate>

@property(nonatomic, weak, nullable) id<RSObjectEditorViewControllerDelegate> delegate;

/// A block that is invoked when the editor should be closed because the user pressed the Done or
/// Cancel button. This provides the same functionality as the `delegate` property.
@property (nonatomic, copy, nullable) void (^completionBlock)(BOOL cancelled);

@property(nonatomic) RSObjectEditorViewStyle style;

/// The object instance being edited.
@property(nonatomic, strong, readonly, nonnull) NSObject *editedObject;

/// If autoTextFieldNavigation is YES, then the return key for all the text fields, except the last,
/// is set to UIReturnKeyNext; the last text field's return key is set to the value of the
/// lastTextFieldReturnKeyType property. When the user presses the "Next" button on the keyboard,
/// the next text field becomes the first responder. If this property is NO, the return key style is
/// determined by the RSTextInputPropertyEditor returnKeyType property. The default value is YES;
@property(nonatomic) BOOL autoTextFieldNavigation;

/// The lastTextFieldReturnKeyType indicates the return key to use when the autoTextFieldNavigation
/// property is YES. If autoTextFieldNavigation is NO, this property is ignored. The default value
/// is UIReturnKeyDone.
@property(nonatomic) UIReturnKeyType lastTextFieldReturnKeyType;

@property (nonatomic) BOOL showCancelButton;
@property (nonatomic) BOOL showDoneButton;

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil UNAVAILABLE_ATTRIBUTE;

- (nonnull instancetype)initWithObject:(nonnull NSObject *)object title:(nonnull NSString *)title propertyGroups:(nonnull NSArray<RSPropertyGroup *> *)propertyGroups NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithObject:(nonnull NSObject *)object;

- (void)setEditedObject:(nonnull NSObject *)object title:(nonnull NSString *)title propertyGroups:(nonnull NSArray<RSPropertyGroup *> *)propertyGroups;

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

/// Replaces a RSPropertyGroup. This is useful when the property group for an object is dynamic and
/// dependent on some state variable.
- (void)replacePropertyGroupAtIndex:(NSUInteger)index withPropertyGroup:(nonnull RSPropertyGroup *)propertyGroup;

@end
