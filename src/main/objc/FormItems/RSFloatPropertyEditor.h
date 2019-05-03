//
// Forma
// RSFloatPropertyEditor.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSPropertyFormItem.h"


@interface RSFloatPropertyEditor : RSPropertyFormItem

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic, strong, nullable) UIImage *minimumValueImage;
@property (nonatomic, strong, nullable) UIImage *maximumValueImage;

@end
