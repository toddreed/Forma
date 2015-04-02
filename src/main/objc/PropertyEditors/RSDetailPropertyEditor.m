//
// RSDetailPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSDetailPropertyEditor.h"
#import "../Core/NSObject+RSEditor.h"


@implementation RSDetailPropertyEditor

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

- (void)configureTableCellForValue:(id)value controller:(RSObjectEditorViewController *)controller
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
    RSObjectEditorViewController *objectEditorViewController = [editedObject objectEditorViewController];
    [navigationController pushViewController:objectEditorViewController animated:YES];
}

@end

