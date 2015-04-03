//
// RSFloatPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyEditor.h"


@interface RSFloatPropertyEditor : RSPropertyEditor

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic, strong) UIImage *minimumValueImage;
@property (nonatomic, strong) UIImage *maximumValueImage;

@end
