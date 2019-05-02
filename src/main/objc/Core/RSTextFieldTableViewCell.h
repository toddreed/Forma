//
// RSTextFieldTableViewCell.h
//
// © Reaction Software Inc., 2013
//


#import <UIKit/UIKit.h>

#import "../FormItems/RSFormItem.h"


@interface RSTextFieldTableViewCell : UITableViewCell <RSFormItemView>

@property (nonatomic, readonly, nonnull) UITextField *textField;
@property (nonatomic, readonly, nonnull) UILabel *errorMessageLabel;

/// Indicates whether the error message is visible.
@property (nonatomic) BOOL showError;

/// Whether the desciption label and icon image view should be included in the layout.
@property (nonatomic) BOOL includeErrorInLayout;

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder NS_DESIGNATED_INITIALIZER;

@end
