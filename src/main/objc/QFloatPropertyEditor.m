//
// QFloatPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "QFloatPropertyEditor.h"
#import "QObjectEditorViewController.h"
#import "QSliderTableViewCell.h"


@interface QObjectEditorViewController (QFloatPropertyEditor)

- (void)sliderChangedValue:(id)sender;

@end


@implementation QObjectEditorViewController (QFloatPropertyEditor)

- (void)sliderChangedValue:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    QPropertyEditor *editor = [propertyEditorDictionary objectForKey:@(slider.tag)];
    [editedObject setValue:@(slider.value) forKey:editor.key];
}

@end


@implementation QFloatPropertyEditor

#pragma mark - QFloatPropertyEditor

@synthesize minimumValue;
@synthesize maximumValue;
@synthesize minimumValueImage;
@synthesize maximumValueImage;

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle
{
    if ((self = [super initWithKey:aKey title:aTitle]))
    {
        minimumValue = 0.0f;
        maximumValue = 1.0f;
    }
    return self;
}

- (void)propertyChangedToValue:(id)newValue
{
    UISlider *slider = ((QSliderTableViewCell *)tableViewCell).slider;
    slider.value = [newValue floatValue];
}

- (UITableViewCell *)newTableViewCell
{
    return [[QSliderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
}

- (void)configureTableCellForValue:(id)value controller:(QObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];

    UISlider *slider = ((QSliderTableViewCell *)tableViewCell).slider;

    [slider addTarget:controller action:@selector(sliderChangedValue:) forControlEvents:UIControlEventValueChanged];
    slider.minimumValueImage = minimumValueImage;
    slider.maximumValueImage = maximumValueImage;  
    slider.value = [value floatValue];
    slider.tag = tag;
}

@end
