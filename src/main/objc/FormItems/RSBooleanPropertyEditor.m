//
// Forma
// RSBooleanPropertyEditor.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSBooleanPropertyEditor.h"
#import "../TableViewCells/RSSwitchTableViewCell.h"


@implementation RSBooleanPropertyEditor

#pragma mark RSFormItem

- (nonnull __kindof UITableViewCell *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSSwitchTableViewCell class]];
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];

    RSSwitchTableViewCell *cell = self.tableViewCell;
    cell.titleLabel.text = self.title;

    UISwitch *toggle = cell.toggle;
    [toggle addTarget:self action:@selector(switchChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];

    RSSwitchTableViewCell *cell = self.tableViewCell;
    UISwitch *toggle = cell.toggle;
    toggle.enabled = enabled;
}

#pragma mark - RSPropertyFormItem

- (void)propertyChangedToValue:(nullable id)newValue
{
    RSSwitchTableViewCell *cell = self.tableViewCell;
    UISwitch *toggle = cell.toggle;
    BOOL animated = (cell.window != nil); // Don’t animated if we’re not in a window yet
    [toggle setOn:[newValue boolValue] animated:animated];
}

#pragma mark - RSBooleanPropertyEditor

- (void)switchChangedValue:(nonnull id)sender
{
    UISwitch *toggle = (UISwitch *)sender;
    [self.object setValue:@(toggle.on) forKey:self.key];
}

@end
