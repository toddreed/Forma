//
// QTextInputPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "QTextInputPropertyEditor.h"
#import "QTextFieldTableViewCell.h"
#import "QObjectEditorViewController.h"

NSString *const QTextInputPropertyValidationErrorDomain = @"QTextInputPropertyValidationErrorDomain";

@interface QObjectEditorViewController (QTextInputPropertyEditor)

- (void)textChanged:(id)sender;

@end


@implementation QObjectEditorViewController (QTextInputPropertyEditor)

- (void)textChanged:(id)sender
{
    if (textEditingMode != QTextEditingModeCancelling)
    {
        UITextField *textField = (UITextField *)sender;
        QTextInputPropertyEditor *editor = [propertyEditorDictionary objectForKey:@(textField.tag)];

        NSError *error;
        id value = [editor validateTextInput:textField.text error:&error];

        if (value)
        {
            [editedObject setValue:value forKey:editor.key];
        }
        else
        {
            if (textEditingMode != QTextEditingModeFinishingForced)
            {
                editor.message = [error localizedDescription];

                // Calling -beginUpdates, -endUpdates will cause the table cell to resize.
                // Note that calling -reloadRowsAtIndexPaths:withRowAnimation doesn't work:
                // it requires the text field to resign first responder.
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            }
        }
    }
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textEditingMode = QTextEditingModeEditing;
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textEditingMode = QTextEditingModeNotEditing;
    activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Note that resigning first responder will cause -textShouldEndEditing: to be invoked, which
    // validates the text input. If validation fails, -resignFirstResponder will return NO.
    if ([textField resignFirstResponder])
    {
        if (textField.returnKeyType == UIReturnKeyNext)
        {
            QTextInputPropertyEditor *editor = [propertyEditorDictionary objectForKey:@(textField.tag)];
            NSIndexPath *nextTextInputIndexPath = [self p_findNextTextInputAfterEditor:editor];

            if (nextTextInputIndexPath != nil)
            {
                [self.tableView scrollToRowAtIndexPath:nextTextInputIndexPath
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:YES];

                QTextFieldTableViewCell *cell = (QTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:nextTextInputIndexPath];
                [cell.textField becomeFirstResponder];
                return NO;
            }
        }
        else if (textField.returnKeyType == UIReturnKeyDone ||
                 textField.returnKeyType == UIReturnKeyGo ||
                 textField.returnKeyType == UIReturnKeySearch)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate objectEditorViewControllerDidEnd:self cancelled:NO];
            });
        }

        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSAssert(textEditingMode != QTextEditingModeNotEditing, @"Unexpected textEditingMode.");

    if (textEditingMode != QTextEditingModeCancelling && textEditingMode != QTextEditingModeFinishingForced)
    {
        QTextInputPropertyEditor *editor = [propertyEditorDictionary objectForKey:@(textField.tag)];
        NSError *error;
        
        id value = [editor validateTextInput:textField.text error:&error];

        QTextFieldTableViewCell *cell = (QTextFieldTableViewCell *)editor.tableViewCell;

        if (value == nil)
        {
            editor.message = [error localizedDescription];

            // Calling -beginUpdates, -endUpdates will cause the table cell to resize.
            // Note that calling -reloadRowsAtIndexPaths:withRowAnimation doesn't work:
            // it requires the text field to resign first responder.
            [self.tableView beginUpdates];
            [self.tableView endUpdates];

            // If -finishEditingForce: was called, textEditMode will be
            // QTextEditingModeFinishing. We set textEditingMode back to
            // QTextEditingModeEditing to indicate that -finishEditingForce: should
            // return NO.
            if (textEditingMode == QTextEditingModeFinishing)
                textEditingMode = QTextEditingModeEditing;
            return NO;
        }
        else if (!cell.descriptionLabel.hidden)
        {
            // If validation succeeds but we previously had shown the validation error message, hide it now.
            editor.message = nil;
            // Force table cell to resize.
            [self.tableView beginUpdates];
            [self.tableView endUpdates];

            return YES;
        }
    }
    return YES;
}

@end

@implementation QTextInputPropertyEditor
{
    // The formatter used for converting between text strings and the target property. If this is nil,
    // then it is assumed that that no conversion is needed (i.e. the target property is an NSString).
    NSFormatter *_formatter;

    QTextInputPropertyEditorStyle _style;

    UITextAutocapitalizationType _autocapitalizationType;
    UITextAutocorrectionType _autocorrectionType;
    UITextSpellCheckingType _spellCheckingType;
    BOOL _enablesReturnKeyAutomatically;
    UIKeyboardAppearance _keyboardAppearance;
    UIKeyboardType _keyboardType;
    UIReturnKeyType _returnKeyType;
    BOOL _secureTextEntry;

    // Properties from UITextFieldView
    UITextFieldViewMode _clearButtonMode;
    NSTextAlignment _textAlignment;
    BOOL _clearsOnBeginEditing;
    NSString *_placeholder;

    // An optional extra string used to display instructions or validation error messages.
    NSString *_message;
}

#pragma mark QPropertyEditor

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle
{
    return [self initWithKey:aKey title:aTitle style:QTextInputPropertyEditorStyleSettings formatter:nil];
}

- (void)propertyChangedToValue:(id)newValue
{
    QTextFieldTableViewCell *textFieldTableViewCell = (QTextFieldTableViewCell *)tableViewCell;
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

- (UITableViewCell *)newTableViewCell
{
    QTextFieldTableViewCell *cell = [[QTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (_message && [_message length] > 0)
        cell.descriptionLabel.text = _message;
    return cell;
}

- (void)configureTableCellForValue:(id)value controller:(QObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];

    if (_style == QTextInputPropertyEditorStyleForm)
    {
        // The super -configureTableCellForValue:controller: sets the label.
        UILabel *label = tableViewCell.textLabel;
        label.text = @"";
    }

    UITextField *textField = ((QTextFieldTableViewCell *)tableViewCell).textField;
    NSString *textValue = _formatter ? [_formatter stringForObjectValue:value] : (NSString *)value;

    textField.delegate = controller;
    [textField addTarget:controller action:@selector(textChanged:) forControlEvents:UIControlEventEditingDidEnd|UIControlEventEditingDidEndOnExit];

    // FIXME: When right aligned, the placeholder gets truncated on the right by a pixel, so we
    // add a trailing space character as a workaround. Confirmed with iOS <= 4.3.
    textField.placeholder = [_placeholder stringByAppendingFormat:@" "];
    textField.text = textValue;
    textField.tag = tag;

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

- (void)tableCellSelected:(UITableViewCell *)cell forValue:(id)value controller:(UITableViewController *)controller
{
    UITextField *textField = ((QTextFieldTableViewCell *)cell).textField;
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
    UITextField *textField = ((QTextFieldTableViewCell *)tableViewCell).textField;
    [textField becomeFirstResponder];
}

- (CGFloat)tableCellHeightForController:(QObjectEditorViewController *)controller
{
    if (_message == nil || [_message length] == 0)
        return 44.0f;
    else
    {
        // This is the margin of the contentView for UITableViewCell's of style UITableViewCellStyleValue1.
        const CGFloat kUITableViewCellStyleValue1HorizontalMargins = 20.0f;
        // This is the top margin of the textLabel for UITableViewCell's of style UITableViewCellStyleValue1.
        const CGFloat kUITableViewCellStyleValue1TopMargin = 11.0f;

        CGSize tableSize = controller.tableView.frame.size;
        CGSize constraint = CGSizeMake(tableSize.width-kDescriptionLabelLeftMargin-kDescriptionLabelRightMargin-kUITableViewCellStyleValue1HorizontalMargins, CGFLOAT_MAX);
        CGSize requiredSize = [_message sizeWithFont:[UIFont systemFontOfSize:kDescriptionLabelFontSize]
                                   constrainedToSize:constraint
                                       lineBreakMode:NSLineBreakByWordWrapping];
        return requiredSize.height+kDescriptionLabelTopMargin+kDescriptionLabelBottomMargin+kUITableViewCellStyleValue1TopMargin;
    }
}


#pragma mark QTextInputPropertyEditor

@synthesize autocapitalizationType = _autocapitalizationType;
@synthesize autocorrectionType = _autocorrectionType;
@synthesize spellCheckingType = _spellCheckingType;
@synthesize enablesReturnKeyAutomatically = _enablesReturnKeyAutomatically;
@synthesize keyboardAppearance = _keyboardAppearance;
@synthesize keyboardType = _keyboardType;
@synthesize returnKeyType = _returnKeyType;
@synthesize secureTextEntry = _secureTextEntry;

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle style:(QTextInputPropertyEditorStyle)aStyle
{
    return [self initWithKey:aKey title:aTitle style:aStyle formatter:nil];
}

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle style:(QTextInputPropertyEditorStyle)aStyle formatter:(NSFormatter *)formatter
{
    if ((self = [super initWithKey:aKey title:aTitle]))
    {
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
        _textAlignment = aStyle == QTextInputPropertyEditorStyleSettings ? NSTextAlignmentRight : NSTextAlignmentLeft;
        _clearsOnBeginEditing = NO;
        _placeholder = aStyle == QTextInputPropertyEditorStyleSettings ? nil : aTitle;
    }
    return self;
}

- (void)setStyle:(QTextInputPropertyEditorStyle)aStyle
{
    switch (aStyle)
    {
        case QTextInputPropertyEditorStyleSettings:
            _style = aStyle;
            _textAlignment = NSTextAlignmentRight;
            _placeholder = nil;
            break;
            
        case QTextInputPropertyEditorStyleForm:
        default:
            _style = aStyle;
            _textAlignment = NSTextAlignmentLeft;
            _placeholder = self.title;
            break;
    }
}

- (void)setMessage:(NSString *)message
{
    if (_message != message)
        _message = [message copy];

    QTextFieldTableViewCell *cell = (QTextFieldTableViewCell *)tableViewCell;
    if (cell)
    {
        cell.descriptionLabel.text = _message;

        BOOL hidden = (_message == nil || [_message length] == 0);
        cell.descriptionLabel.hidden = hidden;
        cell.iconView.hidden = hidden;
    }
}

- (id)validateTextInput:(NSString *)textInput error:(NSError **)error
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
                *error = [NSError errorWithDomain:QTextInputPropertyValidationErrorDomain
                                             code:0
                                         userInfo:@{NSLocalizedDescriptionKey: errorDescription}];
            }
            return nil;
        }
    }
    else
        value = textInput;

    if ([_target validateValue:&value forKey:self.key error:error])
        return value;
    else
        return nil;
}

@end

