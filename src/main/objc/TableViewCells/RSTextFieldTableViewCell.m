//
// Forma
// RSTextFieldTableViewCell.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <tgmath.h>

#import "RSTextFieldTableViewCell.h"
#import "RSFormLibrary.h"
#import "RSBaseTableViewCell.h"

#define FLOAT_LABEL 1


typedef NS_ENUM(NSInteger, RSTextFieldTableViewCellStyle)
{
    /// This emulates the style typically found in the Settings app where there’s a title on
    /// left and a text field on the right. This is the default style.
    RSTextFieldTableViewCellStyleSettings = 0,

    /// This style has a label above the text field.
    RSTextFieldTableViewCellStyleForm
};


@interface RSTextFieldTableViewCell ()

@property (nonatomic, strong, nonnull) IBOutlet UIStackView *stackView;
@property (nonatomic, strong, nonnull) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong, nonnull) IBOutlet UITextField *textField;

// This property is set in the nib file.
@property (nonatomic) RSTextFieldTableViewCellStyle style;

@end


@implementation RSTextFieldTableViewCell

#pragma mark - NSObject

- (void)dealloc
{
    switch (_style)
    {
        case RSTextFieldTableViewCellStyleSettings:
            break;

        case RSTextFieldTableViewCellStyleForm:
            [NSNotificationCenter.defaultCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
            break;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [_stackView setCustomSpacing:0 afterView:_titleLabel];
    switch (_style)
    {
        case RSTextFieldTableViewCellStyleSettings:
            break;

        case RSTextFieldTableViewCellStyleForm:
            _titleLabel.alpha = 0;
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_textField];
            break;
    }
}

#pragma mark - UIView

#pragma mark - UITableViewCell

#pragma mark - RSTextFieldTableViewCell

- (void)textFieldTextDidChangeNotification:(NSNotification *)notification
{
    if (notification.object == _textField)
        [self textFieldTextChanged];
}

- (void)textFieldTextChanged
{
    switch (_style)
    {
        case RSTextFieldTableViewCellStyleSettings:
            break;

        case RSTextFieldTableViewCellStyleForm:
        {
            BOOL textEntered = (_textField.text != nil && _textField.text.length != 0);
            [self showTitleLabel:textEntered];
            break;
        }
    }
}

- (void)showTitleLabel:(BOOL)show
{
    UIViewAnimationOptions easingOptions = show ? UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveEaseIn;
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | easingOptions;

    [UIView animateWithDuration:0.3 delay:0 options:options animations:^{
        self->_titleLabel.alpha = show ? 1 : 0;
    } completion:nil];
}

@end
