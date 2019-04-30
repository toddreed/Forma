//
// RSBooleanPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSBooleanPropertyEditor.h"
#import "../Core/RSObjectEditorViewController.h"
#import "../Core/RSSwitchTableViewCell.h"


@implementation RSBooleanPropertyEditor

#pragma mark RSPropertyEditor

- (void)propertyChangedToValue:(nullable id)newValue
{
    RSSwitchTableViewCell *cell = self.tableViewCell;
    UISwitch *toggle = cell.toggle;
    [toggle setOn:[newValue boolValue] animated:YES];
}

- (nonnull UITableViewCell *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSSwitchTableViewCell class]];
}

- (void)configureTableViewCellForController:(nonnull RSObjectEditorViewController *)controller
{
    [super configureTableViewCellForController:controller];

    RSSwitchTableViewCell *cell = self.tableViewCell;
    UISwitch *toggle = cell.toggle;
    
    [toggle addTarget:self action:@selector(switchChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchChangedValue:(nonnull id)sender
{
    UISwitch *toggle = (UISwitch *)sender;
    [self.object setValue:@(toggle.on) forKey:self.key];
}

@end
