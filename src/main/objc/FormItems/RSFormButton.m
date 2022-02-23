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
#import "RSForm.h"

#import "../TableViewCells/RSButtonTableViewCell.h"


@implementation RSFormButton

#pragma mark - RSFormItem

- (nonnull __kindof UITableViewCell *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSButtonTableViewCell class]];
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];

    UIButton *button = self.button;
    button.enabled = self.enabled;
    [button setTitle:self.title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventPrimaryActionTriggered];
}

- (BOOL)selectable
{
    // The form item isn’t selectable because the UIButton handles the touch event.
    return NO;
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

- (UIButton *)button
{
    RSButtonTableViewCell *cell = (RSButtonTableViewCell *)self.tableViewCell;
    NSParameterAssert(cell.button != nil);
    return cell.button;
}

- (void)buttonPressed:(id)sender
{
    if (_action != nil)
        _action(self.formSection.form.formContainer);
}

@end
