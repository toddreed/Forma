//
// QObjectPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "QObjectPropertyEditor.h"
#import "../Core/NSObject+QEditor.h"

@implementation QObjectPropertyEditor

#pragma mark QPropertyEditor

- (void)propertyChangedToValue:(id)newValue
{
    tableViewCell.detailTextLabel.text = ([newValue respondsToSelector:@selector(descriptionWithLocale:)] ?
                                          [newValue descriptionWithLocale:[NSLocale currentLocale]] : [newValue description]);
}

- (void)configureTableCellForValue:(id)value controller:(QObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];
    tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    tableViewCell.detailTextLabel.text = ([value respondsToSelector:@selector(descriptionWithLocale:)] ?
                                          [value descriptionWithLocale:[NSLocale currentLocale]] : [value description]);
}

- (BOOL)selectable
{
    return YES;
}

- (void)tableCellSelected:(UITableViewCell *)cell forValue:(id)value controller:(UITableViewController *)controller
{
    UINavigationController *navigationController = controller.navigationController;
    QObjectEditorViewController *objectEditorViewController = [value objectEditorViewController];
    [navigationController pushViewController:objectEditorViewController animated:YES];
}

@end
