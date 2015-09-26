//
// RSButtonPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSButtonPropertyEditor.h"


@implementation RSButtonPropertyEditor

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

@end
