//
// Forma
// RSFormItem.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSFormItem.h"
#import "RSFormItem+Private.h"
#import "RSFormLibrary.h"


@implementation RSFormItem
{
    __kindof UITableViewCell<RSFormItemView> *_tableViewCell;
}

#pragma mark - RSFormItem

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title
{
    self = [super init];
    _title = [title copy];
    return self;
}

- (UITableViewCell<RSFormItemView> *)tableViewCell
{
    if (_tableViewCell == nil)
    {
        _tableViewCell = [self newTableViewCell];
        _tableViewCellInstantiated = YES;
        [self configureTableViewCell];
    }
    return _tableViewCell;
}

+ (nonnull __kindof UITableViewCell<RSFormItemView> *)instantiateTableViewCellFromNibOfClass:(Class)cls
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cls) bundle:RSFormLibrary.bundle];
    return [nib instantiateWithOwner:self options:nil][0];
}

- (nonnull UITableViewCell<RSFormItemView> *)newTableViewCell
{
    NSString *reason = [NSString stringWithFormat:@"%s must be implemented in %@ or a superclass", __func__, NSStringFromClass([self class])];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (void)configureTableViewCell
{
    UITableViewCell<RSFormItemView> *cell = self.tableViewCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *titleLabel = cell.titleLabel;
    if (titleLabel != nil)
        titleLabel.text = _title;
}

- (void)controllerDidSelectFormItem:(nonnull UIViewController<RSFormContainer> *)controller
{
    // Do nothing here; subclass will override with appropriate action.
}

- (BOOL)selectable
{
    return NO;
}

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

- (void)becomeFirstResponder
{
    NSString *reason = [NSString stringWithFormat:@"Property editor %@ asked to become first responder when it can’t.", NSStringFromClass([self class])];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

@end
