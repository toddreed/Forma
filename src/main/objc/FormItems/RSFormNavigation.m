//
// Forma
// RSFormNavigation.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSFormNavigation.h"
#import "../Core/NSObject+RSForm.h"


@implementation RSFormNavigation
{
    RSFormNavigationAction _navigationAction;
}

#pragma mark - RSFormItem

- (UITableViewCell *)newTableViewCell
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];
    UITableViewCell *cell = self.tableViewCell;

    UIListContentConfiguration *content = [cell defaultContentConfiguration];
    content.text = self.title;
    cell.contentConfiguration = content;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (BOOL)selectable
{
    return YES;
}

- (void)controllerDidSelectFormItem:(nonnull UIViewController<RSFormContainer> *)controller
{
    _navigationAction(controller);
}

#pragma mark - RSFormNavigation

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title object:(nonnull NSObject *)object
{
    NSParameterAssert(object != nil);

    return [self initWithTitle:title navigationAction:^(UIViewController<RSFormContainer> *_Nonnull formContainer) {
        UIViewController *viewController = [object formViewController];
        [formContainer.navigationController pushViewController:viewController animated:YES];
    }];
}

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title navigationAction:(RSFormNavigationAction)navigationAction
{
    NSParameterAssert(title != nil);
    NSParameterAssert(navigationAction != nil);

    self = [super initWithTitle:title];
    _navigationAction = [navigationAction copy];
    return self;
}

@end

