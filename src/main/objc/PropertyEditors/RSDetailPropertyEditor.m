//
// RSDetailPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSDetailPropertyEditor.h"
#import "../Core/NSObject+RSEditor.h"
#import "../Core/RSDetailTableViewCell.h"


@implementation RSDetailPropertyEditor

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title object:(nonnull NSObject *)object
{
    NSParameterAssert(object != nil);

    self = [super initWithKey:nil ofObject:object title:title];
    NSParameterAssert(self != nil);
    return self;
}

- (UITableViewCell<RSPropertyEditorView> *)newTableViewCell
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

- (void)controllerDidSelectEditor:(nonnull RSObjectEditorViewController *)controller
{
    UINavigationController *navigationController = controller.navigationController;
    RSObjectEditorViewController *objectEditorViewController = [self.object objectEditorViewController];
    [navigationController pushViewController:objectEditorViewController animated:YES];
}

@end

