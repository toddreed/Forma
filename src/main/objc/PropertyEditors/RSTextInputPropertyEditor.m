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

@interface RSObjectEditorViewController (RSTextInputPropertyEditor)

- (void)textChanged:(nonnull id)sender;

@end


@implementation RSObjectEditorViewController (RSTextInputPropertyEditor)

- (void)textChanged:(nonnull id)sender
{
    if (self.textEditingMode != RSTextEditingModeCancelling)
    {
        UITextField *textField = (UITextField *)sender;
        RSTextInputPropertyEditor *editor = (RSTextInputPropertyEditor *)[self p_propertyEditorForTag:textField.tag];

        NSError *error;
        id value = [editor validateTextInput:textField.text error:&error];

        if (value)
        {
            [self.editedObject setValue:value forKey:editor.key];
        }
        else
        {
            if (self.textEditingMode != RSTextEditingModeFinishingForced)
            {
                editor.message = error.localizedDescription;
                [self adjustTableViewCellSize:editor.tableViewCell showMessage:YES];
            }
        }
    }
}

- (void)adjustTableViewCellSize:(nonnull UITableViewCell *)cell showMessage:(BOOL)showMessage
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

    [CATransaction begin];
    if (showMessage)
    {
        // We don't to display the message until the table cell animation is complete,
        // otherwise the message overlaps the cell below.
        [CATransaction setCompletionBlock: ^{
            textFieldCell.descriptionLabel.hidden = NO;
            textFieldCell.iconView.hidden = NO;
        }];
    }
    else
    {
        textFieldCell.descriptionLabel.hidden = YES;
        textFieldCell.iconView.hidden = YES;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [CATransaction commit];

}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(nonnull UITextField *)textField
{
    self.textEditingMode = RSTextEditingModeEditing;
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(nonnull UITextField *)textField
{
    self.textEditingMode = RSTextEditingModeNotEditing;
    self.activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField
{
    // Note that resigning first responder will cause -textShouldEndEditing: to be invoked, which
    // validates the text input. If validation fails, -resignFirstResponder will return NO.
    if ([textField resignFirstResponder])
    {
        if (textField.returnKeyType == UIReturnKeyNext)
        {
            RSTextInputPropertyEditor *editor = (RSTextInputPropertyEditor *)[self p_propertyEditorForTag:textField.tag];
            NSIndexPath *nextTextInputIndexPath = [self p_findNextTextInputAfterEditor:editor];

            if (nextTextInputIndexPath != nil)
            {
                [self.tableView scrollToRowAtIndexPath:nextTextInputIndexPath
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:YES];

                RSTextFieldTableViewCell *cell = (RSTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:nextTextInputIndexPath];
                [cell.textField becomeFirstResponder];
                return NO;
            }
        }
        else if (textField.returnKeyType == UIReturnKeyDone ||
                 textField.returnKeyType == UIReturnKeyGo ||
                 textField.returnKeyType == UIReturnKeySearch)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate objectEditorViewControllerDidEnd:self cancelled:NO];
            });
        }

        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(nonnull UITextField *)textField
{
    NSAssert(self.textEditingMode != RSTextEditingModeNotEditing, @"Unexpected textEditingMode.");

    if (self.textEditingMode != RSTextEditingModeCancelling && self.textEditingMode != RSTextEditingModeFinishingForced)
    {
        RSTextInputPropertyEditor *editor = (RSTextInputPropertyEditor *)[self p_propertyEditorForTag:textField.tag];
        NSError *error;
        
        id value = [editor validateTextInput:textField.text error:&error];

        RSTextFieldTableViewCell *cell = (RSTextFieldTableViewCell *)editor.tableViewCell;

        if (value == nil)
        {
            editor.message = error.localizedDescription;
            [self adjustTableViewCellSize:editor.tableViewCell showMessage:YES];

            // If -finishEditingForce: was called, textEditMode will be
            // RSTextEditingModeFinishing. We set textEditingMode back to
            // RSTextEditingModeEditing to indicate that -finishEditingForce: should
            // return NO.
            if (self.textEditingMode == RSTextEditingModeFinishing)
                self.textEditingMode = RSTextEditingModeEditing;
            return NO;
        }
        else if (!cell.descriptionLabel.hidden)
        {
            // If validation succeeds but we previously had shown the validation error message, hide it now.
            editor.message = nil;
            [self adjustTableViewCellSize:editor.tableViewCell showMessage:NO];
        }
    }
    return YES;
}

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
}

#pragma mark RSPropertyEditor

- (nonnull instancetype)initWithKey:(nullable NSString *)aKey title:(nonnull NSString *)aTitle
{
    return [self initWithKey:aKey title:aTitle style:RSTextInputPropertyEditorStyleSettings formatter:nil];
}

- (void)propertyChangedToValue:(nullable id)newValue
{
    RSTextFieldTableViewCell *textFieldTableViewCell = (RSTextFieldTableViewCell *)self.tableViewCell;
    UITextField *textField = textFieldTableViewCell.textField;

    // Only update the UI if the text field isn't being edited right now.
    if (!textField.editing)
    {
        NSString *text;

        if (newValue == [NSNull null])
            text = @"";
        else if (_formatter)
            text = [_formatter stringForObjectValue:newValue];
        else
            text = (NSString *)newValue;

        textField.text = text;
    }
}

- (nonnull UITableViewCell *)newTableViewCell
{
    RSTextFieldTableViewCell *cell = [[RSTextFieldTableViewCell alloc] initWithReuseIdentifier:nil];
    if (_message && _message.length > 0)
        cell.descriptionLabel.text = _message;

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

- (void)configureTableCellForValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];

    if (_style == RSTextInputPropertyEditorStyleForm)
    {
        // The super -configureTableCellForValue:controller: sets the label.
        UILabel *label = self.tableViewCell.textLabel;
        label.text = @"";
    }

    UITextField *textField = ((RSTextFieldTableViewCell *)self.tableViewCell).textField;
    NSString *textValue = _formatter ? [_formatter stringForObjectValue:value] : (NSString *)value;

    textField.delegate = controller;
    [textField addTarget:controller action:@selector(textChanged:) forControlEvents:UIControlEventEditingDidEnd|UIControlEventEditingDidEndOnExit];

    textField.placeholder = _placeholder;
    textField.text = textValue;
    textField.tag = self.tag;

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

- (void)tableCellSelected:(nonnull UITableViewCell *)cell forValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
{
    UITextField *textField = ((RSTextFieldTableViewCell *)cell).textField;
    [textField becomeFirstResponder];
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

- (nonnull instancetype)initWithKey:(nonnull NSString *)aKey title:(nonnull NSString *)aTitle style:(RSTextInputPropertyEditorStyle)aStyle
{
    return [self initWithKey:aKey title:aTitle style:aStyle formatter:nil];
}

- (nonnull instancetype)initWithKey:(nonnull NSString *)aKey title:(nonnull NSString *)aTitle style:(RSTextInputPropertyEditorStyle)aStyle formatter:(nullable NSFormatter *)formatter
{
    self = [super initWithKey:aKey title:aTitle];

    _formatter = formatter;
    _style = aStyle;
    _autocapitalizationType = UITextAutocapitalizationTypeNone;
    _autocorrectionType = UITextAutocorrectionTypeNo;
    _spellCheckingType = UITextSpellCheckingTypeDefault;
    _enablesReturnKeyAutomatically = NO;
    _keyboardAppearance = UIKeyboardAppearanceDefault;
    _keyboardType = UIKeyboardTypeDefault;
    _returnKeyType = UIReturnKeyNext;
    _secureTextEntry = NO;
    _clearButtonMode = UITextFieldViewModeWhileEditing;
    _textAlignment = aStyle == RSTextInputPropertyEditorStyleSettings ? NSTextAlignmentRight : NSTextAlignmentLeft;
    _clearsOnBeginEditing = NO;
    _placeholder = aStyle == RSTextInputPropertyEditorStyleSettings ? nil : aTitle;

    return self;
}

- (void)setStyle:(RSTextInputPropertyEditorStyle)aStyle
{
    switch (aStyle)
    {
        case RSTextInputPropertyEditorStyleSettings:
            _style = aStyle;
            _textAlignment = NSTextAlignmentRight;
            _placeholder = nil;
            break;
            
        case RSTextInputPropertyEditorStyleForm:
        default:
            _style = aStyle;
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
        cell.descriptionLabel.text = _message;
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

    if ([self.target validateValue:&value forKey:self.key error:error])
        return value;
    else
        return nil;
}

@end

