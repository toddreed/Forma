//
// RSFloatPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSFloatPropertyEditor.h"
#import "../Core/RSObjectEditorViewController.h"
#import "../Core/RSSliderTableViewCell.h"


@implementation RSFloatPropertyEditor

#pragma mark - RSFormItem

- (nonnull UITableViewCell *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSSliderTableViewCell class]];
}

- (void)configureTableViewCellForController:(nonnull RSObjectEditorViewController *)controller
{
    [super configureTableViewCellForController:controller];

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
}

@end
