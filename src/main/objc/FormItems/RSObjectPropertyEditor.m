//
// Forma
// RSObjectPropertyEditor.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSObjectPropertyEditor.h"
#import "../Core/NSObject+RSForm.h"
#import "../TableViewCells/RSLabelTableViewCell.h"


@implementation RSObjectPropertyEditor

#pragma mark RSFormItem

- (UITableViewCell *)newTableViewCell
{
    return [[RSLabelTableViewCell alloc] init];
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];
    RSLabelTableViewCell *cell = self.tableViewCell;
    cell.titleLabel.text = self.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (BOOL)selectable
{
    return YES;
}

- (void)controllerDidSelectFormItem:(nonnull UIViewController<RSFormContainer> *)controller
{
    UINavigationController *navigationController = controller.navigationController;
    id value = [self.object valueForKey:self.key];
    UIViewController<RSFormContainer> *formViewController = [value formViewController];
    [navigationController pushViewController:formViewController animated:YES];
}

#pragma mark - RSPropertyFormItem

- (void)propertyChangedToValue:(nullable id)newValue
{
    RSLabelTableViewCell *cell = self.tableViewCell;
    cell.valueLabel.text = ([newValue respondsToSelector:@selector(descriptionWithLocale:)] ?
                            [newValue descriptionWithLocale:[NSLocale currentLocale]] : [newValue description]);
}

@end

