//
//  QStringPropertyEditor.m
//  WordHunt
//
//  Created by Todd Reed on 11-01-20.
//  Copyright 2011 Reaction Software Inc. All rights reserved.
//

#import "QStringPropertyEditor.h"
#import "QTextFieldTableViewCell.h"
#import "QObjectEditorViewController.h"


@interface QObjectEditorViewController (QStringPropertyEditor)

- (void)textChanged:(id)sender;

@end


@implementation QObjectEditorViewController (QStringPropertyEditor)

- (void)textChanged:(id)sender
{
    if (textEditingMode != QTextEditingModeCancelling)
    {
        UITextField *textField = (UITextField *)sender;
        QStringPropertyEditor *editor = [propertyEditorDictionary objectForKey:@(textField.tag)];

        // -validateValue:forKey:error: was already invoked by -textFieldShouldEndEditing.
        // We invoke it again however because -validateValue:forKey:error: can also perform
        // normalization. We don't expect the validation to failed here.
        NSString *text = textField.text;
        BOOL valid = [editedObject validateValue:&text forKey:editor.key error:NULL];
        NSAssert(valid, @"Unexpected validation failure.");
        [editedObject setValue:text forKey:editor.key];
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
            QStringPropertyEditor *editor = [propertyEditorDictionary objectForKey:@(textField.tag)];
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

    if (textEditingMode != QTextEditingModeCancelling)
    {
        QStringPropertyEditor *editor = [propertyEditorDictionary objectForKey:@(textField.tag)];
        NSString *text = textField.text;
        NSError *error;

        BOOL valid = [editedObject validateValue:&text forKey:editor.key error:&error];
        QTextFieldTableViewCell *cell = (QTextFieldTableViewCell *)editor.tableViewCell;

        if (!valid)
        {
            editor.message = [error localizedDescription];

            // Calling -beginUpdates, -endUpdates will cause the table cell to resize.
            // Note that calling -reloadRowsAtIndexPaths:withRowAnimation doesn't work:
            // it requires the text field to resign first responder.
            [self.tableView beginUpdates];
            [self.tableView endUpdates];

            // If -finishEditing was called, textEditMode will be
            // QTextEditingModeFinishing. We set textEditingMode back to
            // QTextEditingModeEditing to indicate that -finishEditing should return NO.
            if (textEditingMode == QTextEditingModeFinishing)
                textEditingMode = QTextEditingModeEditing;
        }
        else if (!cell.descriptionLabel.hidden)
        {
            // If validation succeeds but we previously had shown the validation error message, hide it now.
            editor.message = nil;
            // Force table cell to resize.
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }
        return valid;
    }
    return YES;
}

@end

@implementation QStringPropertyEditor

#pragma mark QPropertyEditor

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle
{
    return [self initWithKey:aKey title:aTitle style:QStringPropertyEditorStyleSettings];
}

- (void)propertyChangedToValue:(id)newValue
{
    QTextFieldTableViewCell *textFieldTableViewCell = (QTextFieldTableViewCell *)tableViewCell;
    UITextField *textField = textFieldTableViewCell.textField;

    // Only update the UI if the text field isn't being edited right now.
    if (!textField.editing)
    {
        if (newValue == [NSNull null])
            textField.text = @"";
        else
            textField.text = (NSString *)newValue;
    }
}

- (UITableViewCell *)newTableViewCell
{
    QTextFieldTableViewCell *cell = [[QTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (message && [message length] > 0)
        cell.descriptionLabel.text = message;
    return cell;
}

- (void)configureTableCellForValue:(id)value controller:(QObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];

    if (style == QStringPropertyEditorStyleForm)
    {
        // The super -configureTableCellForValue:controller: sets the label. If this
        UILabel *label = tableViewCell.textLabel;
        label.text = @"";
    }

    UITextField *textField = ((QTextFieldTableViewCell *)tableViewCell).textField;
    NSString *textValue = (NSString *)value;

    textField.delegate = controller;
    [textField addTarget:controller action:@selector(textChanged:) forControlEvents:UIControlEventEditingDidEnd|UIControlEventEditingDidEndOnExit];

    // FIXME: When right aligned, the placeholder gets truncated on the right by a pixel, so we
    // add a trailing space character as a workaround. Confirmed with iOS <= 4.3.
    textField.placeholder = [placeholder stringByAppendingFormat:@" "];
    textField.text = textValue;
    textField.tag = tag;

    textField.clearsOnBeginEditing = clearsOnBeginEditing;
    textField.clearButtonMode = clearButtonMode;
    textField.textAlignment = textAlignment;

    // UITextInputTraits settings
    textField.autocapitalizationType = autocapitalizationType;
    textField.autocorrectionType = autocorrectionType;
    textField.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
    textField.keyboardAppearance = keyboardAppearance;
    textField.keyboardType = keyboardType;

    if (controller.autoTextFieldNavigation)
    {
        if (self == controller.lastStringPropertyEditor)
            textField.returnKeyType = controller.lastTextFieldReturnKeyType;
        else
            textField.returnKeyType = UIReturnKeyNext;
    }
    else
        textField.returnKeyType = returnKeyType;

    textField.secureTextEntry = secureTextEntry;
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
    if (message == nil || [message length] == 0)
        return 44.0f;
    else
    {
        // This is the margin of the contentView for UITableViewCell's of style UITableViewCellStyleValue1.
        const CGFloat kUITableViewCellStyleValue1HorizontalMargins = 20.0f;
        // This is the top margin of the textLabel for UITableViewCell's of style UITableViewCellStyleValue1.
        const CGFloat kUITableViewCellStyleValue1TopMargin = 11.0f;

        CGSize tableSize = controller.tableView.frame.size;
        CGSize constraint = CGSizeMake(tableSize.width-kDescriptionLabelLeftMargin-kDescriptionLabelRightMargin-kUITableViewCellStyleValue1HorizontalMargins, CGFLOAT_MAX);
        CGSize requiredSize = [message sizeWithFont:[UIFont systemFontOfSize:kDescriptionLabelFontSize]
                                  constrainedToSize:constraint
                                      lineBreakMode:NSLineBreakByWordWrapping];
        return requiredSize.height+kDescriptionLabelTopMargin+kDescriptionLabelBottomMargin+kUITableViewCellStyleValue1TopMargin;
    }
}


#pragma mark QStringPropertyEditor

// Synthesize properties declared in UITextInputTraits
@synthesize autocapitalizationType;
@synthesize autocorrectionType;
@synthesize enablesReturnKeyAutomatically;
@synthesize keyboardAppearance;
@synthesize keyboardType;
@synthesize returnKeyType;
@synthesize secureTextEntry;
@synthesize clearButtonMode;
@synthesize textAlignment;
@synthesize clearsOnBeginEditing;
@synthesize style;
@synthesize placeholder;

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle style:(QStringPropertyEditorStyle)aStyle
{
    if ((self = [super initWithKey:aKey title:aTitle]))
    {
        style = aStyle;
        autocapitalizationType = UITextAutocapitalizationTypeNone;
        autocorrectionType = UITextAutocorrectionTypeNo;
        enablesReturnKeyAutomatically = NO;
        keyboardAppearance = UIKeyboardAppearanceDefault;
        keyboardType = UIKeyboardTypeDefault;
        returnKeyType = UIReturnKeyNext;
        secureTextEntry = NO;
        clearButtonMode = UITextFieldViewModeWhileEditing;
        textAlignment = aStyle == QStringPropertyEditorStyleSettings ? NSTextAlignmentRight : NSTextAlignmentLeft;
        clearsOnBeginEditing = NO;
        placeholder = aStyle == QStringPropertyEditorStyleSettings ? nil : aTitle;
    }
    return self;
}

- (void)setStyle:(QStringPropertyEditorStyle)aStyle
{
    switch (aStyle)
    {
        case QStringPropertyEditorStyleSettings:
            style = aStyle;
            textAlignment = NSTextAlignmentRight;
            placeholder = nil;
            break;
            
        case QStringPropertyEditorStyleForm:
        default:
            style = aStyle;
            textAlignment = NSTextAlignmentLeft;
            placeholder = self.title;
            break;
    }
}

- (void)setMessage:(NSString *)aMessage
{
    if (message != aMessage)
    {
        message = [aMessage copy];
    }

    QTextFieldTableViewCell *cell = (QTextFieldTableViewCell *)tableViewCell;
    if (cell)
    {
        cell.descriptionLabel.text = message;

        BOOL hidden = (message == nil || [message length] == 0);
        cell.descriptionLabel.hidden = hidden;
        cell.iconView.hidden = hidden;
    }
}

- (NSString *)message
{
    return message;
}

@end

