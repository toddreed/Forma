//
// Forma
// RSTextFieldTableViewCell.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>

#import "../FormItems/RSFormItem.h"


@interface RSTextFieldTableViewCell : UITableViewCell <RSFormItemView>

@property (nonatomic, readonly, nonnull) UITextField *textField;
@property (nonatomic, readonly, nonnull) UIStackView *stackView;

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier UNAVAILABLE_ATTRIBUTE;

/// This method must be called when assigning to the text field `text` property to update the visibility of the title label.
- (void)textFieldTextChanged;

@end
