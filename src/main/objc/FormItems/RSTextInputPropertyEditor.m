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
#import "../Core/RSFormLibrary.h"
#import "../Core/RSCaptionView.h"


NSString *_Nonnull const RSTextInputPropertyValidationErrorDomain = @"RSTextInputPropertyValidationErrorDomain";


@interface RSTextInputPropertyEditor () <UITextFieldDelegate>

// Override `valid` property from RSValidatable to be read/write.
@property (nonatomic, getter=isValid) BOOL valid;
@property (nonatomic, readonly) NSUInteger firstCaptionViewIndex;

@end


@implementation RSTextInputPropertyEditor
{
    // The formatter used for converting between text strings and the target property. If this is nil,
    // then it is assumed that no conversion is needed (i.e. the target property is an NSString).
    NSFormatter *_formatter;

    RSTextInputPropertyEditorStyle _style;

    // Properties from UITextFieldView
    UITextFieldViewMode _clearButtonMode;
    NSTextAlignment _textAlignment;
    BOOL _clearsOnBeginEditing;
    NSString *_placeholder;
    // If `secureTextEntry` is YES and `conditionalSecureTextEntry` is YES, then a show/hide
    // button is displayed in the text field. This property indicates the current state.
    BOOL _showingSecureText;

    NSMutableArray<RSCaption *> *_captions;
}

#pragma NSObject

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark RSFormItem

- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nonnull id)object title:(nonnull NSString *)title
{
    return [self initWithKey:key ofObject:object title:title style:RSTextInputPropertyEditorStyleSettings formatter:nil];
}

- (nonnull __kindof UITableViewCell<RSFormItemView> *)newTableViewCell
{
    NSString *nibName;
    switch (_style)
    {
        case RSTextInputPropertyEditorStyleSettings:
            nibName = [NSString stringWithFormat:@"%@Setting", NSStringFromClass([RSTextFieldTableViewCell class])];
            break;
        case RSTextInputPropertyEditorStyleForm:
            nibName = [NSString stringWithFormat:@"%@Form", NSStringFromClass([RSTextFieldTableViewCell class])];
            break;
    }

    UINib *nib = [UINib nibWithNibName:nibName bundle:RSFormLibrary.bundle];
    RSTextFieldTableViewCell *cell = [nib instantiateWithOwner:self options:nil][0];

    for (RSCaption *caption in _captions)
    {
        RSCaptionView *captionView = [[RSCaptionView alloc] initWithCaption:caption];
        [cell.stackView addArrangedSubview:captionView];
    }

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

    UITextField *textField = ((RSTextFieldTableViewCell *)self.tableViewCell).textField;

    textField.delegate = self;
    [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingDidEnd|UIControlEventEditingDidEndOnExit];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];

    textField.placeholder = _placeholder;

    textField.clearsOnBeginEditing = _clearsOnBeginEditing;
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

    [self configureRightViewOfTextField:textField];
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
    if (enabled)
        textField.textColor = UIColor.labelColor;
    else
        textField.textColor = UIColor.secondaryLabelColor;
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
        [textFieldTableViewCell textFieldTextChanged];
    }
}

#pragma mark - RSTextInputPropertyEditor

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
    _captions = [[NSMutableArray alloc] init];

    id initialValue = [object valueForKey:key];
    _valid = [object validateValue:&initialValue forKey:key error:nil];
    return self;
}

- (UITextField *)textField
{
    RSTextFieldTableViewCell *cell = self.tableViewCell;
    return cell.textField;
}

- (NSString *)currentText
{
    return self.textField.text ?: @"";
}

- (NSUInteger)firstCaptionViewIndex
{
    switch (_style)
    {
        case RSTextInputPropertyEditorStyleSettings:
            return 1;
        case RSTextInputPropertyEditorStyleForm:
            return 2;
    }
}

- (void)addCaption:(nonnull RSCaption *)caption
{
    NSParameterAssert(caption != nil);
    NSUInteger index = [_captions indexOfObjectPassingTest:^BOOL(RSCaption * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.type == caption.type;
    }];

    RSTextFieldTableViewCell *cell = (RSTextFieldTableViewCell *)self.tableViewCell;

    if (index == NSNotFound)
    {
        RSCaptionView *captionView = [[RSCaptionView alloc] initWithCaption:caption];
        [cell.stackView addArrangedSubview:captionView];
        [_captions addObject:caption];
    }
    else
    {
        const NSUInteger kFirstCaptionViewIndex = self.firstCaptionViewIndex;

        // Replace the arrange subview
        UIView *captionView = cell.stackView.arrangedSubviews[index+kFirstCaptionViewIndex];
        [cell.stackView removeArrangedSubview:captionView];
        [captionView removeFromSuperview];

        captionView = [[RSCaptionView alloc] initWithCaption:caption];
        [cell.stackView insertArrangedSubview:captionView atIndex:index+kFirstCaptionViewIndex];
        _captions[index] = caption;
    }

    id<RSFormContainer> container = self.formSection.form.formContainer;

    // Calling -beginUpdates, -endUpdates will cause the table cell to resize.
    //
    // Note that the following doesn't work:
    //
    //   NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //   [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //
    // This requires the text field to resign first responder because the table view will delete
    // and insert the cell.
    [container.tableView beginUpdates];
    [container.tableView endUpdates];
}

- (void)removeCaptionWithType:(RSCaptionType)type
{
    NSUInteger index = [_captions indexOfObjectPassingTest:^BOOL(RSCaption * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.type == type;
    }];

    if (index != NSNotFound)
    {
        [_captions removeObjectAtIndex:index];
        
        RSTextFieldTableViewCell *cell = (RSTextFieldTableViewCell *)self.tableViewCell;
        RSCaptionView *captionView = cell.stackView.arrangedSubviews[index+self.firstCaptionViewIndex];
        [cell.stackView removeArrangedSubview:captionView];
        [captionView removeFromSuperview];

        id<RSFormContainer> container = self.formSection.form.formContainer;

        // Calling -beginUpdates, -endUpdates will cause the table cell to resize.
        [container.tableView beginUpdates];
        [container.tableView endUpdates];
    }
}

/// Validates the input text. If a formatter is configured, it is used to convert the text into
/// an object. -validateValue:forKey:error: is then called on the target object to validate the
/// value.
- (BOOL)validateTextInput:(nonnull NSString *)textInput output:(out id _Nullable *_Nullable)output error:(NSError *_Nullable __autoreleasing *_Nullable)error
{
    // -validateValue:forKey:error: was already invoked by -textFieldShouldEndEditing. We
    // invoke it again however because -validateValue:forKey:error: can also perform
    // normalization. We don’t normally expect the validation to fail here, but it could
    // because even if -textFieldShouldEndEditing returns NO, editing could still end (see the
    // API documentation for -textFieldShouldEndEditing.)

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
        if (output != NULL)
            *output = value;
        return YES;
    }
    else
        return NO;
}

// Get’s called when the text field ends editing (no longer has focus).
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
            [self.object setValue:value forKey:self.key];
        else
        {
            if (container.textEditingMode != RSTextEditingModeFinishingForced)
            {
                RSCaption *caption = [[RSCaption alloc] initWithText:error.localizedDescription type:RSCaptionTypeError];
                [self addCaption:caption];
            }
        }
    }
}

- (void)textFieldTextDidChangeNotification:(NSNotification *)notification
{
    NSParameterAssert(notification.object == self.textField);

    UITextField *textField = notification.object;

    BOOL wasValid = _valid;
    self.valid = [self validateTextInput:textField.text output:NULL error:NULL];
    if (wasValid != _valid)
        [_validatableDelegate validatableChanged:self];
}

- (void)configureRightViewOfTextField:(nonnull UITextField *)textField
{
    if (_secureTextEntry && _conditionalSecureTextEntry)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tintColor = UIColor.placeholderTextColor;
        UIImageSymbolConfiguration *symbolConfiguration = [UIImageSymbolConfiguration configurationWithTextStyle:UIFontTextStyleBody];
        UIImage *showImage = [UIImage systemImageNamed:@"eye.slash.fill"];
        [button setImage:showImage forState:UIControlStateNormal];
        [button setPreferredSymbolConfiguration:symbolConfiguration forImageInState:UIControlStateNormal];

        [button addTarget:self action:@selector(toggleSecureTextEntry) forControlEvents:UIControlEventPrimaryActionTriggered];
        [button sizeToFit];
        textField.rightView = button;
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.clearButtonMode = UITextFieldViewModeNever;
    }
    else
    {
        textField.clearButtonMode = _clearButtonMode;
    }
}

- (void)toggleSecureTextEntry
{
    _showingSecureText = !_showingSecureText;

    if (_showingSecureText)
    {
        UITextField *textField = self.textField;
        textField.secureTextEntry = NO;
        UIButton *button = (UIButton *)textField.rightView;
        UIImage *hideImage = [UIImage systemImageNamed:@"eye.fill"];
        [button setImage:hideImage forState:UIControlStateNormal];
    }
    else
    {
        UITextField *textField = self.textField;
        textField.secureTextEntry = YES;
        UIButton *button = (UIButton *)textField.rightView;
        UIImage *showImage = [UIImage systemImageNamed:@"eye.slash.fill"];
        [button setImage:showImage forState:UIControlStateNormal];
    }
}

#pragma mark RSValidatable

@synthesize valid = _valid;
@synthesize validatableDelegate = _validatableDelegate;

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(nonnull UITextField *)textField
{
    id<RSFormContainer> container = self.formSection.form.formContainer;
    NSParameterAssert(container != nil);

    container.textEditingMode = RSTextEditingModeEditing;
    container.activeTextField = textField;
    if (_formatter)
    {
        id value = [self.object valueForKey:self.key];
        textField.text = [_formatter editingStringForObjectValue:value];
        RSTextFieldTableViewCell *textFieldTableViewCell = (RSTextFieldTableViewCell *)self.tableViewCell;
        [textFieldTableViewCell textFieldTextChanged];
    }
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
        UIViewController<RSFormContainer> *container = form.formContainer;
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
            [container commitForm];
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
        NSError *error;
        id value;
        if (![self validateTextInput:textField.text output:&value error:&error])
        {
            RSCaption *caption = [[RSCaption alloc] initWithText:error.localizedDescription type:RSCaptionTypeError];
            [self addCaption:caption];
        }
        else
            [self removeCaptionWithType:RSCaptionTypeError];
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
