//
// Forma
// RSDiscreteNumericPropertyEditor.m
//
// © Reaction Software Inc. and Todd Reed, 2021
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSDiscreteNumericPropertyEditor.h"
#import "../TableViewCells/RSStepperTableViewCell.h"
#import "../Core/RSFormSection.h"
#import "../Core/RSForm.h"


@implementation RSDiscreteNumericPropertyEditor

#pragma mark - RSFormItem

- (nonnull __kindof UITableViewCell<RSFormItemView> *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSStepperTableViewCell class]];
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];

    UIStepper *stepper = ((RSStepperTableViewCell *)self.tableViewCell).stepper;

    [stepper addTarget:self action:@selector(sliderChangedValue:) forControlEvents:UIControlEventValueChanged];
    stepper.continuous = _continuous;
    stepper.minimumValue = _minimumValue;
    stepper.maximumValue = _maximumValue;
    stepper.stepValue = _stepValue;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    UIStepper *stepper = ((RSStepperTableViewCell *)self.tableViewCell).stepper;
    stepper.enabled = enabled;
}

#pragma mark - RSPropertyFormItem

- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nonnull id)object title:(NSString *)title
{
    NSParameterAssert(key != nil);
    NSParameterAssert(object != nil);

    self = [super initWithKey:key ofObject:object title:title];
    NSParameterAssert(self != nil);

    _minimumValue = 0.0;
    _maximumValue = 1.0;
    _stepValue = 0.1;
    _continuous = YES;
    _valueFormatter = [[NSNumberFormatter alloc] init];
    return self;
}

- (void)propertyChangedToValue:(nullable id)newValue
{
    RSStepperTableViewCell *cell = (RSStepperTableViewCell *)self.tableViewCell;
    UIStepper *stepper = cell.stepper;
    stepper.value = [newValue doubleValue];
    cell.valueLabel.text = [_valueFormatter stringForObjectValue:newValue];
}

#pragma mark - RSDiscreteNumericPropertyEditor

- (void)sliderChangedValue:(nonnull id)sender
{
    UIStepper *stepper = (UIStepper *)sender;
    [self.object setValue:@(stepper.value) forKey:self.key];
    self.formSection.form.modified = YES;
}

- (void)setContinuous:(BOOL)continuous
{
    _continuous = continuous;
    if (self.tableViewCellInstantiated)
    {
        UIStepper *stepper = ((RSStepperTableViewCell *)self.tableViewCell).stepper;
        stepper.continuous = continuous;
    }
}

@end
