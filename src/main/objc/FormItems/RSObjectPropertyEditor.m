//
// RSObjectPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSObjectPropertyEditor.h"
#import "../Core/NSObject+RSForm.h"
#import "../Core/RSLabelTableViewCell.h"


@implementation RSObjectPropertyEditor

#pragma mark RSFormItem

- (UITableViewCell<RSFormItemView> *)newTableViewCell
{
    return [[RSLabelTableViewCell alloc] init];
}

- (void)configureTableViewCellFor
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

