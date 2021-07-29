//
// Forma
// RSTextInputPropertyEditor.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>

#import "RSTextInputPropertyEditor.h"
#import "../Core/RSFormSection.h"
#import "../Core/RSForm.h"
#import "../Core/RSAutocompleteInputAccessoryView.h"
#import "../TableViewCells/RSTextFieldTableViewCell.h"

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
}

#pragma mark RSFormItem

- (nonnull instancetype)initWithKey:(nullable NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title
{
    return [self initWithKey:key ofObject:object title:title style:RSTextInputPropertyEditorStyleSettings formatter:nil];
}

- (nonnull __kindof UITableViewCell<RSFormItemView> *)newTableViewCell
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

- (void)configureTableViewCell
{
    [super configureTableViewCell];

    if (_style == RSTextInputPropertyEditorStyleForm)
    {
        // The super -configureTableCellForValue:controller: sets the label.
        UILabel *label = self.tableViewCell.titleLabel;
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
    textField.smartQuotesType = _smartQuotesType;
    textField.smartDashesType = _smartDashesType;
    textField.smartInsertDeleteType = _smartInsertDeleteType;
    textField.enablesReturnKeyAutomatically = _enablesReturnKeyAutomatically;
    textField.keyboardAppearance = _keyboardAppearance;
    textField.keyboardType = _keyboardType;
    textField.textContentType = _textContentType;

    RSForm *form = self.formSection.form;

    if (form.autoTextFieldNavigation)
    {
        if (self == form.lastTextInputPropertyEditor)
            textField.returnKeyType = form.lastTextFieldReturnKeyType;
        else
            textField.returnKeyType = UIReturnKeyNext;
    }
    else
        textField.returnKeyType = _returnKeyType;

    textField.secureTextEntry = _secureTextEntry;
}

- (void)controllerDidSelectFormItem:(nonnull UIViewController<RSFormContainer> *)controller
{
    RSTextFieldTableViewCell *cell = self.tableViewCell;
    [cell.textField becomeFirstResponder];
}

- (BOOL)selectable
{
    return YES;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    UITextField *textField = ((RSTextFieldTableViewCell *)self.tableViewCell).textField;
    textField.enabled = enabled;
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

#pragma mark - RSPropertyFormItem

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
            NSAssert([newValue isKindOfClass:[NSString class]], @"A string value is expected for the property “%@”.", self.key);
            text = newValue;
        }

        textField.text = text;
    }
}

#pragma mark RSTextInputPropertyEditor

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
    _smartQuotesType = UITextSmartQuotesTypeDefault;
    _smartDashesType = UITextSmartDashesTypeDefault;
    _smartInsertDeleteType = UITextSmartInsertDeleteTypeDefault;
    _enablesReturnKeyAutomatically = NO;
    _keyboardAppearance = UIKeyboardAppearanceDefault;
    _keyboardType = UIKeyboardTypeDefault;
    _returnKeyType = UIReturnKeyNext;
    _secureTextEntry = NO;
    _textContentType = nil;
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

- (BOOL)validateTextInput:(nonnull NSString *)textInput output:(out id _Nullable *_Nonnull)output error:(NSError *_Nonnull *_Nonnull)error
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
            return NO;
        }
    }
    else
        value = textInput;

    if ([self.object validateValue:&value forKey:self.key error:error])
    {
        *output = value;
        return YES;
    }
    else
        return NO;
}

- (void)textChanged:(nonnull id)sender
{
    id<RSFormContainer> container = self.formSection.form.formContainer;
    NSParameterAssert(container != nil);

    if (container.textEditingMode != RSTextEditingModeCancelling)
    {
        UITextField *textField = (UITextField *)sender;

        NSError *error;
        id value;
        if ([self validateTextInput:textField.text output:&value error:&error])
        {
            [self.object setValue:value forKey:self.key];
            self.formSection.form.modified = YES;
        }
        else
        {
            if (container.textEditingMode != RSTextEditingModeFinishingForced)
            {
                self.message = error.localizedDescription;
                [self adjustTableViewCellSize:self.tableViewCell inTableView:container.tableView showMessage:YES];
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
    id<RSFormContainer> container = self.formSection.form.formContainer;
    NSParameterAssert(container != nil);

    container.textEditingMode = RSTextEditingModeEditing;
    container.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(nonnull UITextField *)textField
{
    id<RSFormContainer> container = self.formSection.form.formContainer;
    NSParameterAssert(container != nil);

    container.textEditingMode = RSTextEditingModeNotEditing;
    container.activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField
{
    // Note that resigning first responder will cause -textShouldEndEditing: to be invoked, which
    // validates the text input. If validation fails, -resignFirstResponder will return NO.
    if ([textField resignFirstResponder])
    {
        RSForm *form = self.formSection.form;
        id<RSFormContainer> container = form.formContainer;
        NSParameterAssert(container != nil);

        if (textField.returnKeyType == UIReturnKeyNext)
        {
            NSIndexPath *nextTextInputIndexPath = [form findNextTextInputAfterFormItem:self];

            if (nextTextInputIndexPath != nil)
            {
                [container.tableView scrollToRowAtIndexPath:nextTextInputIndexPath
                                           atScrollPosition:UITableViewScrollPositionBottom
                                                   animated:YES];

                RSTextFieldTableViewCell *cell = (RSTextFieldTableViewCell *)[container.tableView cellForRowAtIndexPath:nextTextInputIndexPath];
                [cell.textField becomeFirstResponder];
                return NO;
            }
        }
        else if (textField.returnKeyType == UIReturnKeyDone ||
                 textField.returnKeyType == UIReturnKeyGo ||
                 textField.returnKeyType == UIReturnKeySearch)
        {
            id<RSFormContainerDelegate> delegate = container.formDelegate;
            if (delegate != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate formContainer:container didEndEditingSessionWithAction:RSFormActionCommit];
                });
            }
        }

        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(nonnull UITextField *)textField
{
    id<RSFormContainer> container = self.formSection.form.formContainer;
    NSParameterAssert(container != nil);

    NSAssert(container.textEditingMode != RSTextEditingModeNotEditing, @"Unexpected textEditingMode.");

    if (container.textEditingMode != RSTextEditingModeCancelling && container.textEditingMode != RSTextEditingModeFinishingForced)
    {
        RSTextFieldTableViewCell *cell = self.tableViewCell;

        NSError *error;
        id value;
        if (![self validateTextInput:textField.text output:&value error:&error])
        {
            self.message = error.localizedDescription;
            [self adjustTableViewCellSize:cell inTableView:container.tableView showMessage:YES];

            // If -finishEditingForce: was called, textEditMode will be
            // RSTextEditingModeFinishing. We set textEditingMode back to
            // RSTextEditingModeEditing to indicate that -finishEditingForce: should
            // return NO.
            if (container.textEditingMode == RSTextEditingModeFinishing)
                container.textEditingMode = RSTextEditingModeEditing;
            return NO;
        }
        else if (!cell.errorMessageLabel.hidden)
        {
            // If validation succeeds but we previously had shown the validation error message, hide it now.
            self.message = nil;
            [self adjustTableViewCellSize:cell inTableView:container.tableView showMessage:NO];
        }
    }
    return YES;
}

#pragma mark UITextInputTraits

@synthesize autocapitalizationType = _autocapitalizationType;
@synthesize autocorrectionType = _autocorrectionType;
@synthesize spellCheckingType = _spellCheckingType;
@synthesize smartQuotesType = _smartQuotesType;
@synthesize smartDashesType = _smartDashesType;
@synthesize smartInsertDeleteType = _smartInsertDeleteType;
@synthesize enablesReturnKeyAutomatically = _enablesReturnKeyAutomatically;
@synthesize keyboardAppearance = _keyboardAppearance;
@synthesize keyboardType = _keyboardType;
@synthesize returnKeyType = _returnKeyType;
@synthesize secureTextEntry = _secureTextEntry;
@synthesize textContentType = _textContentType;

@end
