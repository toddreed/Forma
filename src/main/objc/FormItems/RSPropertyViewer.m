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


@implementation RSPropertyViewer

#pragma mark - RSFormItem

- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nonnull id)object title:(nonnull NSString *)title
{
    return [self initWithKey:key ofObject:object title:title formatter:nil];
}

- (nonnull __kindof UITableViewCell *)newTableViewCell
{
    return [[UITableViewCell alloc] init];
}

#pragma mark - RSPropertyFormItem

- (void)propertyChangedToValue:(nullable id)newValue
{
    NSString *valueText;

    if (newValue == nil || newValue == [NSNull null])
        valueText = @"∅";
    else if (_formatter)
        valueText = [_formatter stringForObjectValue:newValue];
    else
    {
        NSAssert([newValue isKindOfClass:[NSString class]], @"A string value is expected for the property “%@”.", self.key);
        valueText = newValue;
    }

    UITableViewCell *cell = self.tableViewCell;
    UIListContentConfiguration *content = [UIListContentConfiguration valueCellConfiguration];
    content.text = self.title;
    content.secondaryText = valueText;
    cell.contentConfiguration = content;
}

#pragma mark - RSPropertyViewer

- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title formatter:(nullable NSFormatter *)formatter
{
    self = [super initWithKey:key ofObject:object title:title];
    _formatter = formatter;
    return self;
}

@end
