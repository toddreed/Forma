//
// QDetailPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "QDetailPropertyEditor.h"
#import "../Core/NSObject+QEditor.h"


@implementation QDetailPropertyEditor

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"-[%@ %@] not supported", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (id)initWithTitle:(NSString *)aTitle object:(NSObject *)aObject
{
    if ((self = [super initWithKey:nil title:aTitle]))
    {
        editedObject = aObject;
    }
    return self;
}

- (void)configureTableCellForValue:(id)value controller:(QObjectEditorViewController *)controller
{
    [super configureTableCellForValue:editedObject controller:controller];
    tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (BOOL)selectable
{
    return YES;
}

- (void)tableCellSelected:(UITableViewCell *)cell forValue:(id)value controller:(UITableViewController *)controller
{
    UINavigationController *navigationController = controller.navigationController;
    QObjectEditorViewController *objectEditorViewController = [editedObject objectEditorViewController];
    [navigationController pushViewController:objectEditorViewController animated:YES];
}

@end

