//
// RSObjectEditorViewController.m
//
// © Reaction Software Inc., 2013
//


#import "RSObjectEditorViewController.h"
#import "NSObject+RSEditor.h"
#import "../PropertyEditors/RSTextInputPropertyEditor.h"
#import "RSTextFieldTableViewCell.h"

@implementation RSObjectEditorViewController

#pragma mark - NSObject

- (id)init
{
    return [self initWithObject:nil title:@"" propertyGroups:@[]];
}

- (void)dealloc
{
    NSEnumerator *enumerator = [propertyEditorDictionary objectEnumerator];
    
    for (RSPropertyEditor *propertyEditor in enumerator)
        [propertyEditor stopObserving:editedObject];
}

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!previouslyViewed && style == RSObjectEditorViewStyleForm && [propertyEditorDictionary count] > 0)
    {
        RSPropertyEditor *editor = [self p_propertyEditorForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ([editor canBecomeFirstResponder])
            [editor becomeFirstResponder];
    }
    previouslyViewed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Try to complete any in-progress editing. (Note that
    // if validation fails, the object's property won't be updated.)
    [self finishEditingForce:YES];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Not sure when/where this is disabled, but without this, scrolling is disabled when used
    // in a popover.
    self.tableView.scrollEnabled = YES;
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        propertyEditorDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
        nextTag = 1;
        autoTextFieldNavigation = YES;
        lastTextFieldReturnKeyType = UIReturnKeyDone;
        
        [self setEditedObject:nil title:@"" propertyGroups:@[]];
    }
    return self;
}

#pragma mark - UITableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"-[%@ %@] not supported", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark - RSObjectEditorViewController

@synthesize style;
@synthesize delegate;
@synthesize lastTextInputPropertyEditor;
@synthesize autoTextFieldNavigation;
@synthesize lastTextFieldReturnKeyType;

- (id)initWithObject:(NSObject *)aObject title:(NSString *)aTitle propertyGroups:(NSArray *)aPropertyGroups
{
    if ((self = [super initWithStyle:UITableViewStyleGrouped]))
    {
        propertyEditorDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
        nextTag = 1;
        autoTextFieldNavigation = YES;
        lastTextFieldReturnKeyType = UIReturnKeyDone;
        textEditingMode = RSTextEditingModeNotEditing;

        [self setEditedObject:aObject title:aTitle propertyGroups:aPropertyGroups];
    }
    return self;
}

- (id)initWithObject:(NSObject *)aObject
{
    return [self initWithObject:aObject title:[aObject editorTitle] propertyGroups:[aObject propertyGroups]];
}

- (void)setShowCancelButton:(BOOL)f
{
    if (!showCancelButton && f)
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    else if (showCancelButton && !f)
        self.navigationItem.leftBarButtonItem = nil;
    showCancelButton = f;
}

- (BOOL)showCancelButton
{
    return showCancelButton;
}

- (void)setShowDoneButton:(BOOL)f
{
    if (!showDoneButton && f)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    else if (showDoneButton && !f)
        self.navigationItem.rightBarButtonItem = nil;

    showDoneButton = f;
}

- (BOOL)showDoneButton
{
    return showDoneButton;
}

- (void)p_setPropertyGroups:(NSArray *)aPropertyGroups
{
    if (propertyGroups != aPropertyGroups)
    {
        // Stop observing any currently configured property editors
        NSEnumerator *enumerator = [propertyEditorDictionary objectEnumerator];
        
        for (RSPropertyEditor *propertyEditor in enumerator)
            [propertyEditor stopObserving:editedObject];
        
        propertyGroups = [[NSMutableArray alloc] initWithArray:aPropertyGroups];
        
        // Setup up the propertyEditorDictionary and assign tag values to editors.
        [propertyEditorDictionary removeAllObjects];
        
        const NSUInteger sections = [propertyGroups count];
        
        for (NSUInteger section = 0; section < sections; ++section)
        {
            RSPropertyGroup *group = [propertyGroups objectAtIndex:section];
            NSUInteger rows = [group.propertyEditors count];
            
            for (NSUInteger row = 0; row < rows; ++row)
            {
                RSPropertyEditor *editor = [group.propertyEditors objectAtIndex:row];
                editor.tag = nextTag++;
                [propertyEditorDictionary setObject:editor forKey:@(editor.tag)];
            }
        }
        
        lastTextInputPropertyEditor = [self p_findLastTextInputPropertyEditor];
        activeTextField = nil;
    }
}

- (void)setEditedObject:(NSObject *)object title:(NSString *)title propertyGroups:(NSArray *)aPropertyGroups
{
    [self p_setPropertyGroups:aPropertyGroups];

    editedObject = object;
    
    self.title = title;
    
    if ([self isViewLoaded])
        [self.tableView reloadData];
}

- (void)setEditedObject:(NSObject *)object
{
    if (object == nil)
        [self setEditedObject:nil title:@"" propertyGroups:@[]];
    else
        [self setEditedObject:object title:[object editorTitle] propertyGroups:[object propertyGroups]];
}

- (NSObject *)editedObject
{
    return editedObject;
}

- (void)replacePropertyGroupAtIndex:(NSUInteger)index withPropertyGroup:(RSPropertyGroup *)propertyGroup
{
    // Stop observing properties by the currently configured property editors and remove them
    // from propertyEditorDictionary
    RSPropertyGroup *group = [propertyGroups objectAtIndex:index];
    for (RSPropertyEditor *propertyEditor in group.propertyEditors)
    {
        [propertyEditor stopObserving:editedObject];
        [propertyEditorDictionary removeObjectForKey:@(propertyEditor.tag)];
    }
    
    [propertyGroups replaceObjectAtIndex:index withObject:propertyGroup];

    // We might need to fix-up the return key type of the last text field if
    // autoTextFieldNavigation is YES
    
    if (autoTextFieldNavigation)
    {
        RSTextFieldTableViewCell *cell = (RSTextFieldTableViewCell *)lastTextInputPropertyEditor.tableViewCell;
        
        if (cell)
            cell.textField.returnKeyType = lastTextInputPropertyEditor.returnKeyType;
    }
    
    lastTextInputPropertyEditor = [self p_findLastTextInputPropertyEditor];
    
    if (autoTextFieldNavigation)
    {
        RSTextFieldTableViewCell *cell = (RSTextFieldTableViewCell *)lastTextInputPropertyEditor.tableViewCell;
        
        if (cell)
            cell.textField.returnKeyType = lastTextFieldReturnKeyType;
    }

    for (RSPropertyEditor *propertyEditor in propertyGroup.propertyEditors)
    {
        propertyEditor.tag = nextTag++;
        [propertyEditorDictionary setObject:propertyEditor forKey:@(propertyEditor.tag)];
    }

    if ([self isViewLoaded])
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
}

- (RSPropertyEditor *)p_propertyEditorForIndexPath:(NSIndexPath *)indexPath
{
    RSPropertyGroup *group = [propertyGroups objectAtIndex:indexPath.section];
    RSPropertyEditor *editor = [group.propertyEditors objectAtIndex:indexPath.row];
    return editor;
}

- (RSTextInputPropertyEditor *)p_findLastTextInputPropertyEditor
{
    for (NSInteger section = [propertyGroups count]-1; section >= 0; --section)
    {
        RSPropertyGroup *group = [propertyGroups objectAtIndex:section];
        
        for (NSInteger row = [group.propertyEditors count]-1; row >= 0; --row)
        {
            RSPropertyEditor *editor = [group.propertyEditors objectAtIndex:row];
            
            if ([editor isKindOfClass:[RSTextInputPropertyEditor class]])
                return (RSTextInputPropertyEditor *)editor;
        }
    }
    return nil;
}

- (NSIndexPath *)p_findNextTextInputAfterEditor:(RSPropertyEditor *)aEditor
{
    NSUInteger sections = [propertyGroups count];
    BOOL editorFound = NO;
    
    for (NSUInteger section = 0; section < sections; ++section)
    {
        RSPropertyGroup *group = [propertyGroups objectAtIndex:section];
        NSUInteger rows = [group.propertyEditors count];
        
        for (NSUInteger row = 0; row < rows; ++row)
        {
            RSPropertyEditor *editor = [group.propertyEditors objectAtIndex:row];
            
            if (editorFound)
            {
                if ([editor isKindOfClass:[RSTextInputPropertyEditor class]])
                    return [NSIndexPath indexPathForRow:row inSection:section];
            }
            else if (editor == aEditor)
                editorFound = YES;
        }
    }
    return nil;
}

- (BOOL)finishEditingForce:(BOOL)force
{
    if (activeTextField != nil)
    {
        if (textEditingMode == RSTextEditingModeEditing)
            textEditingMode = force ? RSTextEditingModeFinishingForced : RSTextEditingModeFinishing;
        
        // This will cause –textFieldShouldEndEditing: to be invoked, which will set
        // textEditingMode to RSTextEditingModeEditing if validation failed and retained
        // first responder status (this only happens when textEdtingMode is
        // RSTextEditingModeFinishing, not RSTextEditingModeFinishingForced).
        [activeTextField resignFirstResponder];
    }
    return textEditingMode == RSTextEditingModeNotEditing;
}

- (void)cancelEditing
{
    if (textEditingMode == RSTextEditingModeEditing)
        textEditingMode = RSTextEditingModeCancelling;
    [self finishEditingForce:NO];
}

- (void)donePressed
{
    if ([self finishEditingForce:NO])
    {
        [delegate objectEditorViewControllerDidEnd:self cancelled:NO];
        if (_completionBlock)
            _completionBlock(NO);
    }
}

- (void)cancelPressed
{
    [self cancelEditing];
    [delegate objectEditorViewControllerDidEnd:self cancelled:YES];
    if (_completionBlock)
        _completionBlock(YES);
}

#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSPropertyEditor *editor = [self p_propertyEditorForIndexPath:indexPath];
    
    if ([editor selectable])
        return indexPath;
    else
        [self finishEditingForce:NO];
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSPropertyEditor *editor = [self p_propertyEditorForIndexPath:indexPath];
    
    if ([editor selectable])
    {
        // Note that editor.key can be nil for pseudo property editors (like
        // RSDetailPropertyEditor and RSButtonPropertyEditor).
        id value = editor.key == nil ? nil : [editedObject valueForKey:editor.key];
        [editor tableCellSelected:[tableView cellForRowAtIndexPath:indexPath] forValue:value controller:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSPropertyEditor *editor = [self p_propertyEditorForIndexPath:indexPath];
    return [editor tableCellHeightForController:self];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSPropertyEditor *editor = [self p_propertyEditorForIndexPath:indexPath];

    // Note that editor.key can be nil for pseudo property editors (like
    // RSDetailPropertyEditor and RSButtonPropertyEditor).
    id value = editor.key == nil ? nil : [editedObject valueForKey:editor.key];
    UITableViewCell *cell = [editor tableCellForValue:value controller:self];
    [editor startObserving:editedObject];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RSPropertyGroup *group = [propertyGroups objectAtIndex:section];
    return [group.propertyEditors count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [propertyGroups count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    RSPropertyGroup *group = [propertyGroups objectAtIndex:section];
    return group.title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    RSPropertyGroup *group = [propertyGroups objectAtIndex:section];
    return group.footer;
}

@end


