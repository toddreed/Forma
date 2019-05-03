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
#import "../Core/RSDetailTableViewCell.h"


@implementation RSFormNavigation
{
    id _object;
}

#pragma mark - RSFormItem

- (UITableViewCell<RSFormItemView> *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSDetailTableViewCell class]];
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];
    self.tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (BOOL)selectable
{
    return YES;
}

- (void)controllerDidSelectFormItem:(nonnull UIViewController<RSFormContainer> *)controller
{
    UINavigationController *navigationController = controller.navigationController;
    UIViewController<RSFormContainer> *formViewController = [_object formViewController];
    [navigationController pushViewController:formViewController animated:YES];
}

#pragma mark - RSFormNavigation

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title object:(nonnull NSObject *)object
{
    NSParameterAssert(object != nil);

    self = [super initWithTitle:title];
    _object = object;
    return self;
}

@end

