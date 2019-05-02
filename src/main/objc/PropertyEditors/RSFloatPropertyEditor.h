//
// RSFloatPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyFormItem.h"


@interface RSFloatPropertyEditor : RSPropertyFormItem

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic, strong, nullable) UIImage *minimumValueImage;
@property (nonatomic, strong, nullable) UIImage *maximumValueImage;

@end
