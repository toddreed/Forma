//
//  TextFieldTableViewCell.h
//  WordHunt
//
//  Created by Todd Reed on 10-05-06.
//  Copyright 2010 Reaction Software Inc. All rights reserved.
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
