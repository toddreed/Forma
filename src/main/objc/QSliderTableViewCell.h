//
//  SliderTableViewCell.h
//  WordHunt
//
//  Created by Todd Reed on 10-05-06.
//  Copyright 2010 Reaction Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSliderTableViewCell : UITableViewCell
{
    UISlider *slider;
}

@property (nonatomic, strong, readonly) UISlider *slider;

@end
