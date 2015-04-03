//
// RSObjectPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSObjectPropertyEditor.h"
#import "../Core/NSObject+RSEditor.h"

@implementation RSObjectPropertyEditor

#pragma mark RSPropertyEditor

- (void)propertyChangedToValue:(id)newValue
{
    self.tableViewCell.detailTextLabel.text = ([newValue respondsToSelector:@selector(descriptionWithLocale:)] ?
                                               [newValue descriptionWithLocale:[NSLocale currentLocale]] : [newValue description]);
}

- (void)configureTableCellForValue:(id)value controller:(RSObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];
    self.tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.tableViewCell.detailTextLabel.text = ([value respondsToSelector:@selector(descriptionWithLocale:)] ?
                                          [value descriptionWithLocale:[NSLocale currentLocale]] : [value description]);
}

- (BOOL)selectable
{
    return YES;
}

- (void)tableCellSelected:(UITableViewCell *)cell forValue:(id)value controller:(UITableViewController *)controller
{
    UINavigationController *navigationController = controller.navigationController;
    RSObjectEditorViewController *objectEditorViewController = [value objectEditorViewController];
    [navigationController pushViewController:objectEditorViewController animated:YES];
}

@end

