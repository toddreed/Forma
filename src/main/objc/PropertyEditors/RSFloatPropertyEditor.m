//
// RSFloatPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSFloatPropertyEditor.h"
#import "../Core/RSObjectEditorViewController.h"
#import "../Core/RSObjectEditorViewController_PropertyEditor.h"
#import "../Core/RSSliderTableViewCell.h"


@interface RSObjectEditorViewController (RSFloatPropertyEditor)

- (void)sliderChangedValue:(id)sender;

@end


@implementation RSObjectEditorViewController (RSFloatPropertyEditor)

- (void)sliderChangedValue:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    RSPropertyEditor *editor = [self p_propertyEditorForTag:slider.tag];
    [self.editedObject setValue:@(slider.value) forKey:editor.key];
}

@end


@implementation RSFloatPropertyEditor

#pragma mark - RSFloatPropertyEditor

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle
{
    if ((self = [super initWithKey:aKey title:aTitle]))
    {
        _minimumValue = 0.0f;
        _maximumValue = 1.0f;
    }
    return self;
}

- (void)propertyChangedToValue:(id)newValue
{
    UISlider *slider = ((RSSliderTableViewCell *)self.tableViewCell).slider;
    slider.value = [newValue floatValue];
}

- (UITableViewCell *)newTableViewCell
{
    return [[RSSliderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
}

- (void)configureTableCellForValue:(id)value controller:(RSObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];

    UISlider *slider = ((RSSliderTableViewCell *)self.tableViewCell).slider;

    [slider addTarget:controller action:@selector(sliderChangedValue:) forControlEvents:UIControlEventValueChanged];
    slider.minimumValueImage = _minimumValueImage;
    slider.maximumValueImage = _maximumValueImage;
    slider.value = [value floatValue];
    slider.tag = self.tag;
}

@end
