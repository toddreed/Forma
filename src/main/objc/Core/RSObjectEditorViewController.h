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

- (void)objectEditorViewControllerDidEnd:(RSObjectEditorViewController *)viewController cancelled:(BOOL)cancelled;

@end

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

typedef enum RSObjectEditorViewStyle
{
    RSObjectEditorViewStyleSettings,
    RSObjectEditorViewStyleForm
} RSObjectEditorViewStyle;

@interface RSObjectEditorViewController : UITableViewController <UITextFieldDelegate>
{
    id<RSObjectEditorViewControllerDelegate> __weak delegate;
    
    // The object instance being edited.
    NSObject *editedObject;
    
    // An array of RSPropertyGroup objects that determine what PropertyEditors are shown.
    NSMutableArray *propertyGroups;
    
    // propertyEditorDictionary stores references to all the property editors, keyed by a unique
    // tag value assigned to each editor. The tag value is an NSInteger (stored as an NSNumber
    // in the dictionary) that may be assigned to the tag property of a UIControl. This is used
    // so the "owning" RSPropertyEditor can be determined from a UIControl instance, which is
    // typically needed when a UIControl delegate method needs access to the RSPropertyEditor
    // key.
    NSMutableDictionary *propertyEditorDictionary;
    
    RSObjectEditorViewStyle style;
    
    // The next available unique tag that can be assigned to a RSPropertyEditor.
    NSInteger nextTag;
    
    // The last RSTextInputPropertyEditor found in propertyGroups. We keep this so we can
    // automatically set the return key type to UIReturnKeyDone if autoTextFieldNavigation is
    // YES.
    RSTextInputPropertyEditor *lastTextInputPropertyEditor;
    
    // This is either nil, or a text field that is currently the first responder (and hence the
    // keyboard is displayed). If a table cell is touched, we'll resign the first responder and
    // hide the keyboard.
    UITextField *__weak activeTextField;
    
    // If this is YES, all the string editors except the last will have their keyboard return
    // key set to UIReturnKeyNext, overriding the return key type specified by the editor.
    BOOL autoTextFieldNavigation;
    
    // The return key type to use for the last string editor. This is only used when
    // autoTextFieldNavigation is YES.
    UIReturnKeyType lastTextFieldReturnKeyType;

    RSTextEditingMode textEditingMode;
    
    BOOL showCancelButton;
    BOOL showDoneButton;

    // State variable for tracking whether this object has been shown before. On the first view,
    // and when the style is RSObjectEditorViewStyleForm, and when the first editor is a
    // RSTextInputPropertyEditor, focus will automatically be given to the text field of the
    // RSTextInputPropertyEditor.
    BOOL previouslyViewed;
}


@property(nonatomic, weak) id<RSObjectEditorViewControllerDelegate> delegate;

/// A block that is invoked when the editor should be closed because the user pressed the Done or
/// Cancel button. This provides the same functionality as the `delegate` property.
@property (nonatomic, copy) void (^completionBlock)(BOOL cancelled);

@property(nonatomic) RSObjectEditorViewStyle style;

@property(nonatomic, strong) NSObject *editedObject;

@property(nonatomic, readonly) RSTextInputPropertyEditor *lastTextInputPropertyEditor;

/// If autoTextFieldNavigation is YES, then the return key for all the text fields, except the last,
/// is set to UIReturnKeyNext; the last text field's return key is set to the value of the
/// lastTextFieldReturnKeyType property. When the user presses the "Next" button on the keyboard,
/// the next text field becomes the first responder. If this property is NO, the return key style is
/// determined by the RSTextInputPropertyEditor returnKeyType property. The default value is YES;
@property(nonatomic, assign) BOOL autoTextFieldNavigation;

/// The lastTextFieldReturnKeyType indicates the return key to use when the autoTextFieldNavigation
/// property is YES. If autoTextFieldNavigation is NO, this property is ignored. The default value
/// is UIReturnKeyDone.
@property(nonatomic, assign) UIReturnKeyType lastTextFieldReturnKeyType;

@property (nonatomic) BOOL showCancelButton;
@property (nonatomic) BOOL showDoneButton;

/// Designate initializer.
- (id)initWithObject:(NSObject *)aObject title:(NSString *)aTitle propertyGroups:(NSArray *)aPropertyGroups;
- (id)initWithObject:(NSObject *)aObject;

- (void)setEditedObject:(NSObject *)object title:(NSString *)title propertyGroups:(NSArray *)propertyGroups;

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
- (void)replacePropertyGroupAtIndex:(NSUInteger)index withPropertyGroup:(RSPropertyGroup *)propertyGroup;

@end


// Private interface for RSObjectEditorViewController and RSPropertyEditor classes.
@interface RSObjectEditorViewController ()

- (RSPropertyEditor *)p_propertyEditorForIndexPath:(NSIndexPath *)indexPath;
- (RSTextInputPropertyEditor *)p_findLastTextInputPropertyEditor;
- (NSIndexPath *)p_findNextTextInputAfterEditor:(RSPropertyEditor *)editor;

@end


