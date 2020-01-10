//
// Forma
// RSFloatPropertyEditor.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSFloatPropertyEditor.h"
#import "../TableViewCells/RSSliderTableViewCell.h"
#import "../Core/RSFormSection.h"
#import "../Core/RSForm.h"


@implementation RSFloatPropertyEditor

#pragma mark - RSFormItem

- (nonnull __kindof UITableViewCell<RSFormItemView> *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSSliderTableViewCell class]];
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];

    UISlider *slider = ((RSSliderTableViewCell *)self.tableViewCell).slider;

    [slider addTarget:self action:@selector(sliderChangedValue:) forControlEvents:UIControlEventValueChanged];
    slider.minimumValueImage = _minimumValueImage;
    slider.maximumValueImage = _maximumValueImage;
}

#pragma mark - RSPropertyFormItem

- (nonnull instancetype)initWithKey:(nullable NSString *)key ofObject:(nullable id)object title:(NSString *)title
{
    NSParameterAssert(key != nil);

    self = [super initWithKey:key ofObject:object title:title];
    NSParameterAssert(self != nil);

    _minimumValue = 0.0f;
    _maximumValue = 1.0f;

    return self;
}

#pragma mark - RSFloatPropertyEditor

- (void)propertyChangedToValue:(nullable id)newValue
{
    UISlider *slider = ((RSSliderTableViewCell *)self.tableViewCell).slider;
    slider.value = [newValue floatValue];
}

- (void)sliderChangedValue:(nonnull id)sender
{
    UISlider *slider = (UISlider *)sender;
    [self.object setValue:@(slider.value) forKey:self.key];
    self.formSection.form.modified = YES;
}

@end
