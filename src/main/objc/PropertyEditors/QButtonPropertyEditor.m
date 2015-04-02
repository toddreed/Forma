//
// QButtonPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "QButtonPropertyEditor.h"


@implementation QButtonPropertyEditor

@synthesize action;

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"-[%@ %@] not supported", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (id)initWithTitle:(NSString *)aTitle action:(void (^)(QObjectEditorViewController *))aAction
{
    if ((self = [super initWithKey:nil title:aTitle]))
    {
        action = aAction;
    }
    return self;
}

- (void)configureTableCellForValue:(id)value controller:(QObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];
    tableViewCell.textLabel.textAlignment =  NSTextAlignmentCenter;
}

- (BOOL)selectable
{
    return action != nil;
}

- (void)tableCellSelected:(UITableViewCell *)cell forValue:(id)value controller:(UITableViewController *)controller
{
    if (action)
        action((QObjectEditorViewController *)controller);
}

@end
