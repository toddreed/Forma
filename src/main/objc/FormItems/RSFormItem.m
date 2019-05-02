//
//  RSFormItem.m
//  Object Editor
//
//  Created by Todd Reed on 2019-05-01.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import "RSFormItem.h"
#import "RSObjectEditor.h"


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
        _tableViewCell = [self newTableViewCell];
    return _tableViewCell;
}

+ (nonnull __kindof UITableViewCell<RSFormItemView> *)instantiateTableViewCellFromNibOfClass:(Class)cls
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cls) bundle:RSObjectEditor.bundle];
    return [nib instantiateWithOwner:self options:nil][0];
}

- (nonnull UITableViewCell<RSFormItemView> *)newTableViewCell
{
    NSString *reason = [NSString stringWithFormat:@"%s must be implemented in %@ or a superclass", __func__, NSStringFromClass([self class])];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (nonnull __kindof UITableViewCell<RSFormItemView> *)tableViewCellForController:(nonnull RSObjectEditorViewController *)controller
{
    if (_tableViewCell == nil)
    {
        __unused UITableViewCell<RSFormItemView> *cell = self.tableViewCell; // getter will instantiate cell
        [self configureTableViewCellForController:controller];
    }
    return _tableViewCell;
}

- (void)configureTableViewCellForController:(nonnull RSObjectEditorViewController *)controller
{
    UITableViewCell<RSFormItemView> *cell = self.tableViewCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *titleLabel = cell.titleLabel;
    if (titleLabel != nil)
        titleLabel.text = _title;
}

- (void)controllerDidSelectFormItem:(nonnull RSObjectEditorViewController *)controller
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
