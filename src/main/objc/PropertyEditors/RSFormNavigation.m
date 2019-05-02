//
// RSFormNavigation.m
//
// © Reaction Software Inc., 2013
//


#import "RSFormNavigation.h"
#import "../Core/NSObject+RSEditor.h"
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

- (void)configureTableViewCellForController:(nonnull RSObjectEditorViewController *)controller
{
    [super configureTableViewCellForController:controller];
    self.tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (BOOL)selectable
{
    return YES;
}

- (void)controllerDidSelectFormItem:(nonnull RSObjectEditorViewController *)controller
{
    UINavigationController *navigationController = controller.navigationController;
    RSObjectEditorViewController *objectEditorViewController = [_object objectEditorViewController];
    [navigationController pushViewController:objectEditorViewController animated:YES];
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

