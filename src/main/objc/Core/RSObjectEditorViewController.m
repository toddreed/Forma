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

    // State variable for tracking whether this object has been shown before. On the first view,
    // and when the style is RSObjectEditorViewStyleForm, and when the first editor is a
    // RSTextInputPropertyEditor, focus will automatically be given to the text field of the
    // RSTextInputPropertyEditor.
    BOOL _previouslyViewed;
}

#pragma mark - NSObject

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_previouslyViewed && _style == RSObjectEditorViewStyleForm)
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

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title propertyGroups:(nonnull NSArray<RSPropertyGroup *> *)propertyGroups
{
    if ((self = [super initWithStyle:UITableViewStyleGrouped]))
    {
        _autoTextFieldNavigation = YES;
        _lastTextFieldReturnKeyType = UIReturnKeyDone;
        _textEditingMode = RSTextEditingModeNotEditing;

        [self setTitle:title propertyGroups:propertyGroups];
    }
    return self;
}

- (nonnull instancetype)initWithObject:(nonnull NSObject *)object
{
    return [self initWithTitle:[object editorTitle] propertyGroups:[object propertyGroups]];
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

- (void)p_setPropertyGroups:(NSArray *)propertyGroups
{
    if (_propertyGroups != propertyGroups)
    {
        _propertyGroups = [[NSMutableArray alloc] initWithArray:propertyGroups];
        _lastTextInputPropertyEditor = [self p_findLastTextInputPropertyEditor];
        _activeTextField = nil;
    }
}

- (void)setTitle:(nonnull NSString *)title propertyGroups:(nonnull NSArray<RSPropertyGroup *> *)propertyGroups
{
    [self p_setPropertyGroups:propertyGroups];

    self.title = title;
    
    if (self.viewLoaded)
        [self.tableView reloadData];
}

- (void)replacePropertyGroupAtIndex:(NSUInteger)index withPropertyGroup:(nonnull RSPropertyGroup *)propertyGroup
{
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

    if (self.viewLoaded)
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
}

- (nonnull RSPropertyEditor *)p_propertyEditorForIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSPropertyGroup *group = _propertyGroups[indexPath.section];
    RSPropertyEditor *editor = group.propertyEditors[indexPath.row];
    return editor;
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

- (nullable NSIndexPath *)p_findNextTextInputAfterEditor:(nonnull RSPropertyEditor *)targetEditor
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
            else if (editor == targetEditor)
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
        [editor controllerDidSelectEditor:self];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSPropertyEditor *editor = [self p_propertyEditorForIndexPath:indexPath];
    UITableViewCell *cell = [editor tableViewCellForController:self];
    return cell;
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


