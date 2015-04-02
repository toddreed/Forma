//
// RSSliderTableViewCell.h
//
// © Reaction Software Inc., 2013
//


#import <UIKit/UIKit.h>

@interface RSSliderTableViewCell : UITableViewCell
{
    UISlider *slider;
}

@property (nonatomic, strong, readonly) UISlider *slider;

@end
