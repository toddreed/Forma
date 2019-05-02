//
// RSSliderTableViewCell.h
//
// © Reaction Software Inc., 2013
//


#import <UIKit/UIKit.h>

#import "../FormItems/RSFormItem.h"


@interface RSSliderTableViewCell : UITableViewCell <RSFormItemView>

@property (nonatomic, strong, readonly, nonnull) UISlider *slider;

@end
