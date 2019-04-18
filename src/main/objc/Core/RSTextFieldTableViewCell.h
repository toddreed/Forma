//
// RSTextFieldTableViewCell.h
//
// © Reaction Software Inc., 2013
//


#import <UIKit/UIKit.h>

#import "../PropertyEditors/RSPropertyEditor.h"


@interface RSTextFieldTableViewCell : UITableViewCell <RSPropertyEditorView>

@property (nonatomic, readonly, nonnull) UITextField *textField;
@property (nonatomic, readonly, nonnull) UILabel *descriptionLabel;
@property (nonatomic, readonly, nonnull) UIView *iconView;

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder NS_DESIGNATED_INITIALIZER;

@end
