//
// RSButtonPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSButtonPropertyEditor.h"


@implementation RSButtonPropertyEditor

#pragma mark - RSPropertyEditor

- (nonnull UITableViewCell *)newTableViewCell
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

#pragma mark - RSButtonPropertyEditor

- (nonnull instancetype)initWithTitle:(nonnull NSString *)aTitle action:(void (^_Nullable)(RSObjectEditorViewController *))aAction
{
    self = [super initWithKey:nil title:aTitle];
    NSParameterAssert(self != nil);

    _action = aAction;

    return self;
}

- (void)configureTableCellForValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];
    [self styleButtonLabel];
}

- (BOOL)selectable
{
    return _action != nil;
}

- (void)tableCellSelected:(nonnull UITableViewCell *)cell forValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
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
    self.tableViewCell.textLabel.textColor = buttonColor;
}

@end
