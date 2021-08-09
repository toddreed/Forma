//
// Forma
// RSDiscreteNumericPropertyEditor.h
//
// © Reaction Software Inc. and Todd Reed, 2021
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSPropertyFormItem.h"


/// RSDiscreteNumericPropertyEditor is an property editor that uses a stepper control to modify
/// a numeric property. The editor displays the current value in a label next to the stepper.
@interface RSDiscreteNumericPropertyEditor : RSPropertyFormItem

@property (nonatomic) double minimumValue;
@property (nonatomic) double maximumValue;
@property (nonatomic) double stepValue;

/// The formatter used to display the current proeprty value.
@property (nonatomic) NSFormatter *valueFormatter;

/// This property is applied to the UIStepper used by the editor’s UI. The default value is YES.
@property (nonatomic) BOOL continuous;

@end
