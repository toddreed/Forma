//
// Forma
// RSStepperTableViewCell.h
//
// © Reaction Software Inc. and Todd Reed, 2021
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>

#import "RSBaseTableViewCell.h"


@interface RSStepperTableViewCell : RSBaseTableViewCell

@property (nonatomic, strong, readonly, nonnull) UIStepper *stepper;
@property (nonatomic, strong, readonly, nonnull) UILabel *titleLabel;
@property (nonatomic, strong, readonly, nonnull) UILabel *valueLabel;

@end
