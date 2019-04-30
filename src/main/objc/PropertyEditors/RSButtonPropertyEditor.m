//
// RSButtonPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSButtonPropertyEditor.h"
#import "../Core/RSButtonTableViewCell.h"


@implementation RSButtonPropertyEditor

#pragma mark - RSPropertyEditor

- (nonnull UITableViewCell *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSButtonTableViewCell class]];
}

#pragma mark - RSButtonPropertyEditor

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title action:(void (^_Nullable)(RSObjectEditorViewController *))action
{
    self = [super initWithKey:nil ofObject:nil title:title];
    NSParameterAssert(self != nil);

    _action = action;

    return self;
}

- (void)configureTableViewCellForController:(nonnull RSObjectEditorViewController *)controller
{
    [super configureTableViewCellForController:controller];
    [self styleButtonLabel];
}

- (BOOL)selectable
{
    return _action != nil;
}

- (void)controllerDidSelectEditor:(nonnull RSObjectEditorViewController *)controller
{
    if (_action)
        _action(controller);
}

- (void)setAction:(void (^)(RSObjectEditorViewController * _Nonnull))action
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
