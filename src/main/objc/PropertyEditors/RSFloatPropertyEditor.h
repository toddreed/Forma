//
// RSFloatPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyEditor.h"


@interface RSFloatPropertyEditor : RSPropertyEditor

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic, strong, nullable) UIImage *minimumValueImage;
@property (nonatomic, strong, nullable) UIImage *maximumValueImage;

@end
