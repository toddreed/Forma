//
// RSDetailPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSDetailPropertyEditor.h"
#import "../Core/NSObject+RSEditor.h"


@implementation RSDetailPropertyEditor
{
    NSObject *_editedObject;
}

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
        _editedObject = aObject;
    }
    return self;
}

- (void)configureTableCellForValue:(id)value controller:(RSObjectEditorViewController *)controller
{
    [super configureTableCellForValue:_editedObject controller:controller];
    self.tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (BOOL)selectable
{
    return YES;
}

- (void)tableCellSelected:(UITableViewCell *)cell forValue:(id)value controller:(UITableViewController *)controller
{
    UINavigationController *navigationController = controller.navigationController;
    RSObjectEditorViewController *objectEditorViewController = [_editedObject objectEditorViewController];
    [navigationController pushViewController:objectEditorViewController animated:YES];
}

@end

