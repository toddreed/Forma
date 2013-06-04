//
// QTextFieldTableViewCell.h
//
// © Reaction Software Inc., 2013
//


#import <UIKit/UIKit.h>

const CGFloat kDescriptionLabelTopMargin;
const CGFloat kDescriptionLabelLeftMargin;
const CGFloat kDescriptionLabelRightMargin;
const CGFloat kDescriptionLabelBottomMargin;
const CGFloat kDescriptionLabelFontSize;

@interface QTextFieldTableViewCell : UITableViewCell
{
    UITextField *textField;
    UILabel *descriptionLabel;
    UIImageView *iconView;
}

@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, readonly) UILabel *descriptionLabel;
@property (nonatomic, readonly) UIImageView *iconView;

@end
