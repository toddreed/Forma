//
// RSDetailPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSDetailPropertyEditor.h"
#import "../Core/NSObject+RSEditor.h"
#import "../Core/RSDetailTableViewCell.h"


@implementation RSDetailPropertyEditor
{
    NSObject *_editedObject;
}

- (nonnull instancetype)initWithTitle:(nonnull NSString *)aTitle object:(nonnull NSObject *)aObject
{
    self = [super initWithKey:nil title:aTitle];
    NSParameterAssert(self != nil);

    _editedObject = aObject;

    return self;
}

- (UITableViewCell<RSPropertyEditorView> *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSDetailTableViewCell class]];
}

- (void)configureTableCellForValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
{
    [super configureTableCellForValue:_editedObject controller:controller];
    self.tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (BOOL)selectable
{
    return YES;
}

- (void)tableCellSelected:(nonnull UITableViewCell *)cell forValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
{
    UINavigationController *navigationController = controller.navigationController;
    RSObjectEditorViewController *objectEditorViewController = [_editedObject objectEditorViewController]; // XXX should this be `value`?
    [navigationController pushViewController:objectEditorViewController animated:YES];
}

@end

