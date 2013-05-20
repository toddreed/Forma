//
//  QFloatPropertyEditor.h
//  WordHunt
//
//  Created by Todd Reed on 11-01-20.
//  Copyright 2011 Reaction Software Inc. All rights reserved.
//

#import "QPropertyEditor.h"


@interface QFloatPropertyEditor : QPropertyEditor
{
    float minimumValue;
    float maximumValue;
    
    UIImage *minimumValueImage;
    UIImage *maximumValueImage;
}

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic, strong) UIImage *minimumValueImage;
@property (nonatomic, strong) UIImage *maximumValueImage;

@end
