//
// RSBooleanPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSBooleanPropertyEditor.h"
#import "../Core/RSSwitchTableViewCell.h"


@implementation RSBooleanPropertyEditor

#pragma mark RSFormItem

- (nonnull __kindof UITableViewCell<RSFormItemView> *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSSwitchTableViewCell class]];
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];

    RSSwitchTableViewCell *cell = self.tableViewCell;
    UISwitch *toggle = cell.toggle;
    
    [toggle addTarget:self action:@selector(switchChangedValue:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - RSPropertyFormItem

- (void)propertyChangedToValue:(nullable id)newValue
{
    RSSwitchTableViewCell *cell = self.tableViewCell;
    UISwitch *toggle = cell.toggle;
    [toggle setOn:[newValue boolValue] animated:YES];
}

#pragma mark - RSBooleanPropertyEditor

- (void)switchChangedValue:(nonnull id)sender
{
    UISwitch *toggle = (UISwitch *)sender;
    [self.object setValue:@(toggle.on) forKey:self.key];
}

@end
