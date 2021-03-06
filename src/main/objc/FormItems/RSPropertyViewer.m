//
// Forma
// RSPropertyViewer.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSPropertyViewer.h"
#import "../TableViewCells/RSLabelTableViewCell.h"


@implementation RSPropertyViewer

#pragma mark - RSFormItem

- (nonnull instancetype)initWithKey:(nullable NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title
{
    return [self initWithKey:key ofObject:object title:title formatter:nil];
}

- (nonnull __kindof UITableViewCell<RSFormItemView> *)newTableViewCell
{
    return [[RSLabelTableViewCell alloc] init];
}

#pragma mark - RSPropertyFormItem

- (void)propertyChangedToValue:(nullable id)newValue
{
    NSString *text;

    if (newValue == [NSNull null])
        text = @"";
    else if (_formatter)
        text = [_formatter stringForObjectValue:newValue];
    else
    {
        NSAssert([newValue isKindOfClass:[NSString class]], ([NSString stringWithFormat:@"A string value is expected for the property “%@”.", self.key]));
        text = newValue;
    }

    RSLabelTableViewCell *labelTableViewCell = self.tableViewCell;
    labelTableViewCell.valueLabel.text = text;
}

#pragma mark - RSPropertyViewer

- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title formatter:(nullable NSFormatter *)formatter
{
    self = [super initWithKey:key ofObject:object title:title];
    _formatter = formatter;
    return self;
}

@end
