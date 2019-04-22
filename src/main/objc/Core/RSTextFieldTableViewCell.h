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
@property (nonatomic, readonly, nonnull) UIImageView *iconImageView;

/// Indicates whether the description label and icon image view are visible.
@property (nonatomic) BOOL showDescription;

/// Whether the desciption label and icon image view should be included in the layout.
@property (nonatomic) BOOL includeDescriptionInLayout;

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder NS_DESIGNATED_INITIALIZER;

@end
