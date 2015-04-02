//
// RSFloatPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyEditor.h"


@interface RSFloatPropertyEditor : RSPropertyEditor
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
