//
// RSButtonPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSButtonPropertyEditor.h"


@implementation RSButtonPropertyEditor
{
    void (^_action)(RSObjectEditorViewController *);
}

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"-[%@ %@] not supported", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (id)initWithTitle:(NSString *)aTitle action:(void (^)(RSObjectEditorViewController *))aAction
{
    if ((self = [super initWithKey:nil title:aTitle]))
    {
        _action = aAction;
    }
    return self;
}

- (void)configureTableCellForValue:(id)value controller:(RSObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];
    self.tableViewCell.textLabel.textAlignment =  NSTextAlignmentCenter;
}

- (BOOL)selectable
{
    return _action != nil;
}

- (void)tableCellSelected:(UITableViewCell *)cell forValue:(id)value controller:(UITableViewController *)controller
{
    if (_action)
        _action((RSObjectEditorViewController *)controller);
}

@end
