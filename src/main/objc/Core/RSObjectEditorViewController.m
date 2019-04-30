//
// RSObjectEditorViewController.m
//
// © Reaction Software Inc., 2013
//


#import "RSObjectEditorViewController.h"
#import "RSObjectEditorViewController_PropertyEditor.h"

#import "NSObject+RSEditor.h"
#import "../PropertyEditors/RSTextInputPropertyEditor.h"
#import "RSTextFieldTableViewCell.h"

@implementation RSObjectEditorViewController
{
    // An array of RSPropertyGroup objects that determine what PropertyEditors are shown.
    NSMutableArray<RSPropertyGroup *> *_propertyGroups;

    // propertyEditorDictionary stores references to all the property editors, keyed by a unique
    // tag value assigned to each editor. The tag value is an NSInteger (stored as an NSNumber
    // in the dictionary) that may be assigned to the tag property of a UIControl. This is used
    // so the "owning" RSPropertyEditor can be determined from a UIControl instance, which is
    // typically needed when a UIControl delegate method needs access to the RSPropertyEditor
    // key.
    NSMutableDictionary<NSNumber *, RSPropertyEditor *> *_propertyEditorDictionary;

    // The next available unique tag that can be assigned to a RSPropertyEditor.
    NSInteger _nextTag;

    // State variable for tracking whether this object has been shown before. On the first view,
    // and when the style is RSObjectEditorViewStyleForm, and when the first editor is a
    // RSTextInputPropertyEditor, focus will automatically be given to the text field of the
    // RSTextInputPropertyEditor.
    BOOL _previouslyViewed;
}

#pragma mark - NSObject

- (void)dealloc
{
    NSEnumerator *enumerator = [_propertyEditorDictionary objectEnumerator];
    
    for (RSPropertyEditor *propertyEditor in enumerator)
        [propertyEditor stopObserving:_editedObject];
}

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_previouslyViewed && _style == RSObjectEditorViewStyleForm && _propertyEditorDictionary.count > 0)
    {
        RSPropertyEditor *editor = [self p_propertyEditorForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ([editor canBecomeFirstResponder])
            [editor becomeFirstResponder];
    }
    _previouslyViewed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Try to complete any in-progress editing. (Note that
    // if validation fails, the object's property won't be updated.)
    [self finishEditingForce:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    // Not sure when/where this is disabled, but without this, scrolling is disabled when used
    // in a popover.
    self.tableView.scrollEnabled = YES;

    self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
}

#pragma mark - UITableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"-[%@ %@] not supported", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark - RSObjectEditorViewController

- (nonnull instancetype)initWithObject:(nonnull NSObject *)aObject title:(nonnull NSString *)aTitle propertyGroups:(nonnull NSArray<RSPropertyGroup *> *)aPropertyGroups
{
    if ((self = [super initWithStyle:UITableViewStyleGrouped]))
    {
        _propertyEditorDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
        _nextTag = 1;
        _autoTextFieldNavigation = YES;
        _lastTextFieldReturnKeyType = UIReturnKeyDone;
        _textEditingMode = RSTextEditingModeNotEditing;

        [self setEditedObject:aObject title:aTitle propertyGroups:aPropertyGroups];
    }
    return self;
}

- (nonnull instancetype)initWithObject:(nonnull NSObject *)aObject
{
    return [self initWithObject:aObject title:[aObject editorTitle] propertyGroups:[aObject propertyGroups]];
}

- (void)setShowCancelButton:(BOOL)f
{
    if (!_showCancelButton && f)
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    else if (_showCancelButton && !f)
        self.navigationItem.leftBarButtonItem = nil;
    _showCancelButton = f;
}

- (void)setShowDoneButton:(BOOL)f
{
    if (!_showDoneButton && f)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    else if (_showDoneButton && !f)
        self.navigationItem.rightBarButtonItem = nil;

    _showDoneButton = f;
}

- (void)p_setPropertyGroups:(NSArray *)aPropertyGroups
{
    if (_propertyGroups != aPropertyGroups)
    {
        // Stop observing any currently configured property editors
        NSEnumerator *enumerator = [_propertyEditorDictionary objectEnumerator];
        
        for (RSPropertyEditor *propertyEditor in enumerator)
            [propertyEditor stopObserving:_editedObject];
        
        _propertyGroups = [[NSMutableArray alloc] initWithArray:aPropertyGroups];
        
        // Setup up the propertyEditorDictionary and assign tag values to editors.
        [_propertyEditorDictionary removeAllObjects];
        
        const NSUInteger sections = _propertyGroups.count;
        
        for (NSUInteger section = 0; section < sections; ++section)
        {
            RSPropertyGroup *group = _propertyGroups[section];
            NSUInteger rows = group.propertyEditors.count;
            
            for (NSUInteger row = 0; row < rows; ++row)
            {
                RSPropertyEditor *editor = group.propertyEditors[row];
                editor.tag = _nextTag++;
                _propertyEditorDictionary[@(editor.tag)] = editor;
            }
        }
        
        _lastTextInputPropertyEditor = [self p_findLastTextInputPropertyEditor];
        _activeTextField = nil;
    }
}

- (void)setEditedObject:(nonnull NSObject *)object title:(nonnull NSString *)title propertyGroups:(nonnull NSArray<RSPropertyGroup *> *)aPropertyGroups
{
    [self p_setPropertyGroups:aPropertyGroups];

    _editedObject = object;
    
    self.title = title;
    
    if (self.viewLoaded)
        [self.tableView reloadData];
}

- (void)setEditedObject:(nonnull NSObject *)object
{
    [self setEditedObject:object title:[object editorTitle] propertyGroups:[object propertyGroups]];
}

- (void)replacePropertyGroupAtIndex:(NSUInteger)index withPropertyGroup:(nonnull RSPropertyGroup *)propertyGroup
{
    // Stop observing properties by the currently configured property editors and remove them
    // from propertyEditorDictionary
    RSPropertyGroup *group = _propertyGroups[index];
    for (RSPropertyEditor *propertyEditor in group.propertyEditors)
    {
        [propertyEditor stopObserving:_editedObject];
        [_propertyEditorDictionary removeObjectForKey:@(propertyEditor.tag)];
    }
    
    _propertyGroups[index] = propertyGroup;

    // We might need to fix-up the return key type of the last text field if
    // autoTextFieldNavigation is YES
    
    if (_autoTextFieldNavigation)
    {
        RSTextFieldTableViewCell *cell = _lastTextInputPropertyEditor.tableViewCell;
        
        if (cell)
            cell.textField.returnKeyType = _lastTextInputPropertyEditor.returnKeyType;
    }
    
    _lastTextInputPropertyEditor = [self p_findLastTextInputPropertyEditor];
    
    if (_autoTextFieldNavigation)
    {
        RSTextFieldTableViewCell *cell = _lastTextInputPropertyEditor.tableViewCell;
        
        if (cell)
            cell.textField.returnKeyType = _lastTextFieldReturnKeyType;
    }

    for (RSPropertyEditor *propertyEditor in propertyGroup.propertyEditors)
    {
        propertyEditor.tag = _nextTag++;
        _propertyEditorDictionary[@(propertyEditor.tag)] = propertyEditor;
    }

    if (self.viewLoaded)
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
}

- (nonnull RSPropertyEditor *)p_propertyEditorForIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSPropertyGroup *group = _propertyGroups[indexPath.section];
    RSPropertyEditor *editor = group.propertyEditors[indexPath.row];
    return editor;
}

- (nonnull RSPropertyEditor *)p_propertyEditorForTag:(NSInteger)tag
{
    return _propertyEditorDictionary[@(tag)];
}

- (nullable RSTextInputPropertyEditor *)p_findLastTextInputPropertyEditor
{
    for (NSInteger section = _propertyGroups.count-1; section >= 0; --section)
    {
        RSPropertyGroup *group = _propertyGroups[section];
        
        for (NSInteger row = group.propertyEditors.count-1; row >= 0; --row)
        {
            RSPropertyEditor *editor = group.propertyEditors[row];
            
            if ([editor isKindOfClass:[RSTextInputPropertyEditor class]])
                return (RSTextInputPropertyEditor *)editor;
        }
    }
    return nil;
}

- (nullable NSIndexPath *)p_findNextTextInputAfterEditor:(nonnull RSPropertyEditor *)aEditor
{
    NSUInteger sections = _propertyGroups.count;
    BOOL editorFound = NO;
    
    for (NSUInteger section = 0; section < sections; ++section)
    {
        RSPropertyGroup *group = _propertyGroups[section];
        NSUInteger rows = group.propertyEditors.count;
        
        for (NSUInteger row = 0; row < rows; ++row)
        {
            RSPropertyEditor *editor = group.propertyEditors[row];
            
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
    if (_activeTextField != nil)
    {
        if (_textEditingMode == RSTextEditingModeEditing)
            _textEditingMode = force ? RSTextEditingModeFinishingForced : RSTextEditingModeFinishing;
        
        // This will cause –textFieldShouldEndEditing: to be invoked, which will set
        // textEditingMode to RSTextEditingModeEditing if validation failed and retained
        // first responder status (this only happens when textEdtingMode is
        // RSTextEditingModeFinishing, not RSTextEditingModeFinishingForced).
        [_activeTextField resignFirstResponder];
    }
    return _textEditingMode == RSTextEditingModeNotEditing;
}

- (void)cancelEditing
{
    if (_textEditingMode == RSTextEditingModeEditing)
        _textEditingMode = RSTextEditingModeCancelling;
    [self finishEditingForce:NO];
}

- (void)donePressed
{
    if ([self finishEditingForce:NO])
    {
        [_delegate objectEditorViewControllerDidEnd:self cancelled:NO];
        if (_completionBlock)
            _completionBlock(NO);
    }
}

- (void)cancelPressed
{
    [self cancelEditing];
    [_delegate objectEditorViewControllerDidEnd:self cancelled:YES];
    if (_completionBlock)
        _completionBlock(YES);
}

#pragma mark UITableViewDelegate

- (nullable NSIndexPath *)tableView:(nonnull UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSPropertyEditor *editor = [self p_propertyEditorForIndexPath:indexPath];
    
    if (editor.selectable)
        return indexPath;
    else
        [self finishEditingForce:NO];
    return nil;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSPropertyEditor *editor = [self p_propertyEditorForIndexPath:indexPath];
    
    if (editor.selectable)
    {
        // Note that editor.key can be nil for pseudo property editors (like
        // RSDetailPropertyEditor and RSButtonPropertyEditor).
        id value = editor.key == nil ? nil : [_editedObject valueForKey:editor.key];
        [editor tableCellSelected:[tableView cellForRowAtIndexPath:indexPath] forValue:value controller:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSPropertyEditor *editor = [self p_propertyEditorForIndexPath:indexPath];

    // Note that editor.key can be nil for pseudo property editors (like
    // RSDetailPropertyEditor and RSButtonPropertyEditor).
    id value = editor.key == nil ? nil : [_editedObject valueForKey:editor.key];
    [editor configureTableCellForValue:value controller:self];
    [editor startObserving:_editedObject];
    return editor.tableViewCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RSPropertyGroup *group = _propertyGroups[section];
    return group.propertyEditors.count;
}

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return _propertyGroups.count;
}

- (nullable NSString *)tableView:(nonnull UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    RSPropertyGroup *group = _propertyGroups[section];
    return group.title;
}

- (nullable NSString *)tableView:(nonnull UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    RSPropertyGroup *group = _propertyGroups[section];
    return group.footer;
}

@end


