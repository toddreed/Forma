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


@implementation RSObjectPropertyEditor

#pragma mark RSFormItem

- (UITableViewCell *)newTableViewCell
{
    return [[UITableViewCell alloc] init];
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];

    UITableViewCell *cell = self.tableViewCell;
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
    UITableViewCell *cell = self.tableViewCell;
    NSString *objectText = ([newValue respondsToSelector:@selector(descriptionWithLocale:)] ?
                            [newValue descriptionWithLocale:[NSLocale currentLocale]] : [newValue description]);
    UIListContentConfiguration *content = [UIListContentConfiguration valueCellConfiguration];
    content.text = self.title;
    content.secondaryText = objectText;
    cell.contentConfiguration = content;
}

@end

