//
// RSBooleanPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSBooleanPropertyEditor.h"
#import "../Core/RSObjectEditorViewController.h"
#import "../Core/RSObjectEditorViewController_PropertyEditor.h"
#import "../Core/RSSwitchTableViewCell.h"


@interface RSObjectEditorViewController (RSBooleanPropertyEditor)

- (void)switchChangedValue:(nonnull id)sender;

@end


@implementation RSObjectEditorViewController (RSBooleanPropertyEditor)

- (void)switchChangedValue:(nonnull id)sender
{
    UISwitch *toggle = (UISwitch *)sender;
    RSPropertyEditor *editor = [self p_propertyEditorForTag:toggle.tag];
    [self.editedObject setValue:@(toggle.on) forKey:editor.key];
}

@end


@implementation RSBooleanPropertyEditor

#pragma mark RSPropertyEditor

- (void)propertyChangedToValue:(nullable id)newValue
{
    UISwitch *toggle = (UISwitch *)self.tableViewCell.accessoryView;
    [toggle setOn:[newValue boolValue] animated:YES];
}

- (nonnull UITableViewCell *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSSwitchTableViewCell class]];
}

- (void)configureTableCellForValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];

    RSSwitchTableViewCell *cell = (RSSwitchTableViewCell *)self.tableViewCell;
    UISwitch *toggle = cell.toggle;
    
    [toggle addTarget:controller action:@selector(switchChangedValue:) forControlEvents:UIControlEventValueChanged];
    toggle.tag = self.tag;
    toggle.on = [value boolValue];
}

@end
