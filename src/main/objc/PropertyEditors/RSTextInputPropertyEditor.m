//
// RSTextInputPropertyEditor.m
//
// © Reaction Software Inc., 2013
//

#import <UIKit/UIKit.h>

#import "RSTextInputPropertyEditor.h"

#import "../Core/RSTextFieldTableViewCell.h"
#import "../Core/RSObjectEditorViewController.h"
#import "../Core/RSAutocompleteInputAccessoryView.h"
#import "../Core/RSObjectEditorViewController_PropertyEditor.h"

NSString *_Nonnull const RSTextInputPropertyValidationErrorDomain = @"RSTextInputPropertyValidationErrorDomain";


@interface RSTextInputPropertyEditor () <UITextFieldDelegate>

@end


@implementation RSTextInputPropertyEditor
{
    // The formatter used for converting between text strings and the target property. If this is nil,
    // then it is assumed that that no conversion is needed (i.e. the target property is an NSString).
    NSFormatter *_formatter;

    RSTextInputPropertyEditorStyle _style;

    // Properties from UITextFieldView
    UITextFieldViewMode _clearButtonMode;
    NSTextAlignment _textAlignment;
    BOOL _clearsOnBeginEditing;
    NSString *_placeholder;

    // An optional extra string used to display instructions or validation error messages.
    NSString *_message;

    __weak RSObjectEditorViewController *_objectEditorViewController;
}

#pragma mark RSPropertyEditor

- (nonnull instancetype)initWithKey:(nullable NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title
{
    return [self initWithKey:key ofObject:object title:title style:RSTextInputPropertyEditorStyleSettings formatter:nil];
}

- (void)propertyChangedToValue:(nullable id)newValue
{
    RSTextFieldTableViewCell *textFieldTableViewCell = (RSTextFieldTableViewCell *)self.tableViewCell;
    UITextField *textField = textFieldTableViewCell.textField;

    // Only update the UI if the text field isn't being edited right now.
    if (!textField.editing)
    {
        NSString *text;

        if (newValue == nil)
            text = @"";
        else if (_formatter)
            text = [_formatter stringForObjectValue:newValue];
        else
        {
            NSAssert([newValue isKindOfClass:[NSString class]], ([NSString stringWithFormat:@"A string value is expected for the property “%@”.", self.key]));
            text = newValue;
        }

        textField.text = text;
    }
}

- (nonnull UITableViewCell *)newTableViewCell
{
    RSTextFieldTableViewCell *cell = [[RSTextFieldTableViewCell alloc] initWithReuseIdentifier:nil];
    if (_message && _message.length > 0)
        cell.errorMessageLabel.text = _message;

    if (_autocompleteSource)
    {
        RSAutocompleteInputAccessoryView *inputAccessoryView = [[RSAutocompleteInputAccessoryView alloc] init];
        inputAccessoryView.autocompleteSource = _autocompleteSource;
        inputAccessoryView.textField = cell.textField; // Note that cell.textField.inputAccessoryView is set here
    }
    else
    {
        // When navigating from a UITextField with a non-nil inputAccessoryView to a
        // UITextField with a nil inputAccessoryView, the previous view's input accessory
        // view remains rather than hiding. This is a workaround.
        //
        // See http://stackoverflow.com/a/16905990/2116111
        cell.textField.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
    }

    return cell;
}

- (void)configureTableViewCellForController:(nonnull RSObjectEditorViewController *)controller
{
    [super configureTableViewCellForController:controller];

    _objectEditorViewController = controller;

    if (_style == RSTextInputPropertyEditorStyleForm)
    {
        // The super -configureTableCellForValue:controller: sets the label.
        UILabel *label = self.tableViewCell.textLabel;
        label.text = @"";
    }

    UITextField *textField = ((RSTextFieldTableViewCell *)self.tableViewCell).textField;

    textField.delegate = self;
    [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingDidEnd|UIControlEventEditingDidEndOnExit];

    textField.placeholder = _placeholder;

    textField.clearsOnBeginEditing = _clearsOnBeginEditing;
    textField.clearButtonMode = _clearButtonMode;
    textField.textAlignment = _textAlignment;

    // UITextInputTraits settings
    textField.autocapitalizationType = _autocapitalizationType;
    textField.autocorrectionType = _autocorrectionType;
    textField.spellCheckingType = _spellCheckingType;
    textField.enablesReturnKeyAutomatically = _enablesReturnKeyAutomatically;
    textField.keyboardAppearance = _keyboardAppearance;
    textField.keyboardType = _keyboardType;

    if (controller.autoTextFieldNavigation)
    {
        if (self == controller.lastTextInputPropertyEditor)
            textField.returnKeyType = controller.lastTextFieldReturnKeyType;
        else
            textField.returnKeyType = UIReturnKeyNext;
    }
    else
        textField.returnKeyType = _returnKeyType;

    textField.secureTextEntry = _secureTextEntry;
}

- (void)controllerDidSelectEditor:(nonnull RSObjectEditorViewController *)controller
{
    RSTextFieldTableViewCell *cell = self.tableViewCell;
    [cell.textField becomeFirstResponder];
}

- (BOOL)selectable
{
    return YES;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)becomeFirstResponder
{
    UITextField *textField = ((RSTextFieldTableViewCell *)self.tableViewCell).textField;
    [textField becomeFirstResponder];
}

#pragma mark RSTextInputPropertyEditor

@synthesize autocapitalizationType = _autocapitalizationType;
@synthesize autocorrectionType = _autocorrectionType;
@synthesize spellCheckingType = _spellCheckingType;
@synthesize enablesReturnKeyAutomatically = _enablesReturnKeyAutomatically;
@synthesize keyboardAppearance = _keyboardAppearance;
@synthesize keyboardType = _keyboardType;
@synthesize returnKeyType = _returnKeyType;
@synthesize secureTextEntry = _secureTextEntry;

- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title style:(RSTextInputPropertyEditorStyle)style
{
    return [self initWithKey:key ofObject:object title:title style:style formatter:nil];
}

- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title style:(RSTextInputPropertyEditorStyle)style formatter:(nullable NSFormatter *)formatter
{
    self = [super initWithKey:key ofObject:object title:title];

    _formatter = formatter;
    _style = style;
    _autocapitalizationType = UITextAutocapitalizationTypeNone;
    _autocorrectionType = UITextAutocorrectionTypeNo;
    _spellCheckingType = UITextSpellCheckingTypeDefault;
    _enablesReturnKeyAutomatically = NO;
    _keyboardAppearance = UIKeyboardAppearanceDefault;
    _keyboardType = UIKeyboardTypeDefault;
    _returnKeyType = UIReturnKeyNext;
    _secureTextEntry = NO;
    _clearButtonMode = UITextFieldViewModeWhileEditing;
    _textAlignment = style == RSTextInputPropertyEditorStyleSettings ? NSTextAlignmentRight : NSTextAlignmentLeft;
    _clearsOnBeginEditing = NO;
    _placeholder = style == RSTextInputPropertyEditorStyleSettings ? nil : title;

    return self;
}

- (void)setStyle:(RSTextInputPropertyEditorStyle)style
{
    switch (style)
    {
        case RSTextInputPropertyEditorStyleSettings:
            _style = style;
            _textAlignment = NSTextAlignmentRight;
            _placeholder = nil;
            break;

        case RSTextInputPropertyEditorStyleForm:
            _style = style;
            _textAlignment = NSTextAlignmentLeft;
            _placeholder = self.title;
            break;
    }
}

- (void)setMessage:(nullable NSString *)message
{
    if (_message != message)
        _message = [message copy];

    RSTextFieldTableViewCell *cell = (RSTextFieldTableViewCell *)self.tableViewCell;
    if (cell)
        cell.errorMessageLabel.text = _message;
}

- (nullable id)validateTextInput:(nonnull NSString *)textInput error:(NSError **)error
{
    // -validateValue:forKey:error: was already invoked by -textFieldShouldEndEditing.
    // We invoke it again however because -validateValue:forKey:error: can also perform
    // normalization. We don't normally expect the validation to failed here, but it could
    // because even if -textFieldShouldEndEditing returns NO, edit could still end (see
    // the API documentation for -textFieldShouldEndEditing.)

    id value;

    if (_formatter)
    {
        NSString *errorDescription;

        if (![_formatter getObjectValue:&value forString:textInput errorDescription:&errorDescription])
        {
            if (error != NULL)
            {
                *error = [NSError errorWithDomain:RSTextInputPropertyValidationErrorDomain
                                             code:0
                                         userInfo:@{NSLocalizedDescriptionKey: errorDescription}];
            }
            return nil;
        }
    }
    else
        value = textInput;

    if ([self.object validateValue:&value forKey:self.key error:error])
        return value;
    else
        return nil;
}

- (void)textChanged:(nonnull id)sender
{
    if (_objectEditorViewController.textEditingMode != RSTextEditingModeCancelling)
    {
        UITextField *textField = (UITextField *)sender;

        NSError *error;
        id value = [self validateTextInput:textField.text error:&error];

        if (value)
        {
            [self.object setValue:value forKey:self.key];
        }
        else
        {
            if (_objectEditorViewController.textEditingMode != RSTextEditingModeFinishingForced)
            {
                self.message = error.localizedDescription;
                [self adjustTableViewCellSize:self.tableViewCell inTableView:_objectEditorViewController.tableView showMessage:YES];
            }
        }
    }
}

- (void)adjustTableViewCellSize:(nonnull UITableViewCell *)cell inTableView:(nonnull UITableView *)tableView showMessage:(BOOL)showMessage
{
    // Calling -beginUpdates, -endUpdates will cause the table cell to resize.
    //
    // Note that the following doesn't work:
    //
    //   NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //   [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //
    // This requires the text field to resign first responder because the table view will delete
    // and insert the cell.

    RSTextFieldTableViewCell *textFieldCell = (RSTextFieldTableViewCell *)cell;

    textFieldCell.includeErrorInLayout = showMessage;

    [CATransaction begin];

    if (showMessage)
    {
        // We don't to display the message until the table cell animation is complete,
        // otherwise the message overlaps the cell below.
        [CATransaction setCompletionBlock: ^{
            textFieldCell.showError = showMessage;
        }];
    }
    else
    {
        textFieldCell.showError = showMessage;
    }
    [tableView beginUpdates];
    [tableView endUpdates];
    [CATransaction commit];

}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(nonnull UITextField *)textField
{
    _objectEditorViewController.textEditingMode = RSTextEditingModeEditing;
    _objectEditorViewController.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(nonnull UITextField *)textField
{
    _objectEditorViewController.textEditingMode = RSTextEditingModeNotEditing;
    _objectEditorViewController.activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField
{
    // Note that resigning first responder will cause -textShouldEndEditing: to be invoked, which
    // validates the text input. If validation fails, -resignFirstResponder will return NO.
    if ([textField resignFirstResponder])
    {
        if (textField.returnKeyType == UIReturnKeyNext)
        {
            NSIndexPath *nextTextInputIndexPath = [_objectEditorViewController p_findNextTextInputAfterEditor:self];

            if (nextTextInputIndexPath != nil)
            {
                [_objectEditorViewController.tableView scrollToRowAtIndexPath:nextTextInputIndexPath
                                                             atScrollPosition:UITableViewScrollPositionBottom
                                                                     animated:YES];

                RSTextFieldTableViewCell *cell = (RSTextFieldTableViewCell *)[_objectEditorViewController.tableView cellForRowAtIndexPath:nextTextInputIndexPath];
                [cell.textField becomeFirstResponder];
                return NO;
            }
        }
        else if (textField.returnKeyType == UIReturnKeyDone ||
                 textField.returnKeyType == UIReturnKeyGo ||
                 textField.returnKeyType == UIReturnKeySearch)
        {
            id<RSObjectEditorViewControllerDelegate> delegate = _objectEditorViewController.delegate;
            if (delegate != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate objectEditorViewControllerDidEnd:self->_objectEditorViewController cancelled:NO];
                });
            }
        }

        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(nonnull UITextField *)textField
{
    NSAssert(_objectEditorViewController.textEditingMode != RSTextEditingModeNotEditing, @"Unexpected textEditingMode.");

    if (_objectEditorViewController.textEditingMode != RSTextEditingModeCancelling && _objectEditorViewController.textEditingMode != RSTextEditingModeFinishingForced)
    {
        NSError *error;

        id value = [self validateTextInput:textField.text error:&error];

        RSTextFieldTableViewCell *cell = self.tableViewCell;

        if (value == nil)
        {
            self.message = error.localizedDescription;
            [self adjustTableViewCellSize:cell inTableView:_objectEditorViewController.tableView showMessage:YES];

            // If -finishEditingForce: was called, textEditMode will be
            // RSTextEditingModeFinishing. We set textEditingMode back to
            // RSTextEditingModeEditing to indicate that -finishEditingForce: should
            // return NO.
            if (_objectEditorViewController.textEditingMode == RSTextEditingModeFinishing)
                _objectEditorViewController.textEditingMode = RSTextEditingModeEditing;
            return NO;
        }
        else if (!cell.errorMessageLabel.hidden)
        {
            // If validation succeeds but we previously had shown the validation error message, hide it now.
            self.message = nil;
            [self adjustTableViewCellSize:cell inTableView:_objectEditorViewController.tableView showMessage:NO];
        }
    }
    return YES;
}

@end

