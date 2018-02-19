//
// RSTextFieldTableViewCell.h
//
// © Reaction Software Inc., 2013
//


#import <UIKit/UIKit.h>

extern const CGFloat kDescriptionLabelTopMargin;
extern const CGFloat kDescriptionLabelLeftMargin;
extern const CGFloat kDescriptionLabelRightMargin;
extern const CGFloat kDescriptionLabelBottomMargin;
extern const CGFloat kDescriptionLabelFontSize;

@interface RSTextFieldTableViewCell : UITableViewCell

@property (nonatomic, readonly, nonnull) UITextField *textField;
@property (nonatomic, readonly, nonnull) UILabel *descriptionLabel;
@property (nonatomic, readonly, nonnull) UIView *iconView;

@end
