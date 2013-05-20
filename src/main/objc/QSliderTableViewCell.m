//
//  SliderTableViewCell.m
//  WordHunt
//
//  Created by Todd Reed on 10-05-06.
//  Copyright 2010 Reaction Software Inc. All rights reserved.
//

#import "QSliderTableViewCell.h"


@implementation QSliderTableViewCell

#pragma mark QSliderTableViewCell

@synthesize slider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        slider = [[UISlider alloc] initWithFrame:CGRectZero];
        slider.continuous = NO;
        [self.contentView addSubview:slider];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize labelSize = [self.textLabel sizeThatFits:CGSizeZero];
    CGRect contentBounds = self.contentView.bounds;
    CGRect sliderFrame = slider.frame;
    
    sliderFrame.size = [slider sizeThatFits:CGSizeZero];
    sliderFrame.origin.x = self.textLabel.frame.origin.x + labelSize.width + 10;
    sliderFrame.origin.y = contentBounds.origin.y+(contentBounds.size.height-sliderFrame.size.height)/2;
    sliderFrame.size.width = contentBounds.size.width - sliderFrame.origin.x - self.textLabel.frame.origin.x;
    slider.frame = sliderFrame;
}

@end
