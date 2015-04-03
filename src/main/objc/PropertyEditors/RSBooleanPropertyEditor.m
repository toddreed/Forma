//
// RSBooleanPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSBooleanPropertyEditor.h"
#import "../Core/RSObjectEditorViewController.h"
#import "../Core/RSObjectEditorViewController_PropertyEditor.h"


@interface RSObjectEditorViewController (RSBooleanPropertyEditor)

- (void)switchChangedValue:(id)sender;

@end


@implementation RSObjectEditorViewController (RSBooleanPropertyEditor)

- (void)switchChangedValue:(id)sender
{
    UISwitch *toggle = (UISwitch *)sender;
    RSPropertyEditor *editor = [self p_propertyEditorForTag:toggle.tag];
    [self.editedObject setValue:@(toggle.on) forKey:editor.key];
}

@end


@implementation RSBooleanPropertyEditor

#pragma mark RSPropertyEditor

- (void)propertyChangedToValue:(id)newValue
{
    UISwitch *toggle = (UISwitch *)self.tableViewCell.accessoryView;
    [toggle setOn:[newValue boolValue] animated:YES];
}

- (UITableViewCell *)newTableViewCell
{
    UITableViewCell *cell = [super newTableViewCell];
    UISwitch *toggle = [[UISwitch alloc] init];
    cell.accessoryView = toggle;
    return cell;
}

- (void)configureTableCellForValue:(id)value controller:(RSObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];
    
    UISwitch *toggle = (UISwitch *)self.tableViewCell.accessoryView;
    
    [toggle addTarget:controller action:@selector(switchChangedValue:) forControlEvents:UIControlEventValueChanged];
    toggle.tag = self.tag;
    toggle.on = [value boolValue];
}

@end
