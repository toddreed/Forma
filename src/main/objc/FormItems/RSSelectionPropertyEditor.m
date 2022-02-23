//
// Forma
// RSSelectionPropertyEditor.m
//
// © Reaction Software Inc. and Todd Reed, 2022
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSSelectionPropertyEditor.h"
#import "../Core/RSSelectionViewController.h"


@interface RSSelectionPropertyEditor () <RSSelectionViewControllerDelegate>

@end


@implementation RSSelectionPropertyEditor
{
    RSSelection *_selection;
}

#pragma mark - RSFormItem

- (nonnull __kindof UITableViewCell *)newTableViewCell
{
    return [[UITableViewCell alloc] init];
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];
    UITableViewCell *cell = self.tableViewCell;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    UIListContentConfiguration *content = [UIListContentConfiguration valueCellConfiguration];
    content.text = self.title;
    content.secondaryText = [_selection labelForValue:[self.object valueForKey:self.key]];
    cell.contentConfiguration = content;
}

- (void)controllerDidSelectFormItem:(nonnull UIViewController<RSFormContainer> *)controller
{
    UINavigationController *navigationController = controller.navigationController;
    id value = [self.object valueForKey:self.key];
    NSUInteger selectedIndex = [_selection indexOfValue:value];
    RSSelectionViewController *selectionViewController = [[RSSelectionViewController alloc] initWithSelection:_selection selectedIndex:selectedIndex];
    selectionViewController.title = self.title;
    selectionViewController.delegate = self;
    [navigationController pushViewController:selectionViewController animated:YES];
}

- (BOOL)selectable
{
    return YES;
}

#pragma mark - RSPropertyFormItem

- (void)propertyChangedToValue:(nullable id)newValue
{
    UITableViewCell *cell = self.tableViewCell;
    UIListContentConfiguration *content = [UIListContentConfiguration valueCellConfiguration];
    content.text = self.title;
    content.secondaryText = [_selection labelForValue:newValue];
    cell.contentConfiguration = content;
}

#pragma mark - RSSelectionPropertyEditor

- (nonnull instancetype)initWithKey:(nonnull NSString *)key
                           ofObject:(nonnull id)object
                              title:(nonnull NSString *)title
                          selection:(nonnull RSSelection *)selection
{
    self = [super initWithKey:key ofObject:object title:title];
    _selection = selection;
    return self;
}

#pragma mark RSSelectionViewController

- (void)selectionViewController:(nonnull RSSelectionViewController *)viewController didSelectOptionAtIndex:(NSUInteger)optionIndex
{
    id value = [_selection valueForIndex:optionIndex];
    [self.object setValue:value forKey:self.key];
}

@end
