//
// Forma
// RSSliderTableViewCell.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>

#import "../FormItems/RSFormItem.h"


@interface RSSliderTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly, nonnull) UILabel *titleLabel;
@property (nonatomic, strong, readonly, nonnull) UISlider *slider;

@end
