//
//  RSGenericPropertyViewer.m
//  Object Editor
//
//  Created by Todd Reed on 2019-04-22.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import "RSGenericPropertyViewer.h"
#import "RSLabelTableViewCell.h"


@implementation RSGenericPropertyViewer

#pragma mark - RSPropertyEditor

- (nonnull instancetype)initWithKey:(nullable NSString *)key title:(nonnull NSString *)title
{
    return [self initWithKey:key title:title formatter:nil];
}

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

- (nonnull UITableViewCell *)newTableViewCell
{
    return [[RSLabelTableViewCell alloc] init];
}

- (void)configureTableCellForValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];
    [self propertyChangedToValue:value];
}

#pragma mark - RSGenericPropertyViewer

- (nonnull instancetype)initWithKey:(nonnull NSString *)key title:(nonnull NSString *)title formatter:(nullable NSFormatter *)formatter
{
    self = [super initWithKey:key title:title];
    _formatter = formatter;
    return self;
}

@end
