//
// RSObjectPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSObjectPropertyEditor.h"
#import "../Core/NSObject+RSEditor.h"

@implementation RSObjectPropertyEditor

#pragma mark RSPropertyEditor

- (void)propertyChangedToValue:(nullable id)newValue
{
    self.tableViewCell.detailTextLabel.text = ([newValue respondsToSelector:@selector(descriptionWithLocale:)] ?
                                               [newValue descriptionWithLocale:[NSLocale currentLocale]] : [newValue description]);
}

- (void)configureTableCellForValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
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

- (void)tableCellSelected:(nonnull UITableViewCell *)cell forValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
{
    UINavigationController *navigationController = controller.navigationController;
    RSObjectEditorViewController *objectEditorViewController = [value objectEditorViewController];
    [navigationController pushViewController:objectEditorViewController animated:YES];
}

@end

