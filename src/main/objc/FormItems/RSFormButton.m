//
// Forma
// RSFormButton.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSFormButton.h"
#import "../TableViewCells/RSButtonTableViewCell.h"


@implementation RSFormButton

#pragma mark - RSFormItem

- (nonnull __kindof UITableViewCell<RSFormItemView> *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSButtonTableViewCell class]];
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];
    [self styleButtonLabel];
}

- (BOOL)selectable
{
    return _action != nil;
}

- (void)controllerDidSelectFormItem:(nonnull UIViewController<RSFormContainer> *)controller
{
    if (_action)
        _action(controller);
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    UIButton *button = ((RSButtonTableViewCell *)self.tableViewCell).button;
    button.enabled = enabled;
}

#pragma mark - RSFormButton

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title action:(void (^_Nullable)(UIViewController<RSFormContainer> *_Nonnull))action
{
    self = [super initWithTitle:title];
    _action = action;
    return self;
}

- (void)setAction:(void (^)(UIViewController<RSFormContainer> * _Nonnull))action
{
    _action = action;
    [self styleButtonLabel];
}

- (void)styleButtonLabel
{
    UIColor *buttonColor = self.selectable ? self.tableViewCell.tintColor : [UIColor grayColor];
    self.tableViewCell.titleLabel.textColor = buttonColor;
}

@end
