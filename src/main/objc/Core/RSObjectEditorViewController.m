//
// RSObjectEditorViewController.m
//
// © Reaction Software Inc., 2013
//


#import "RSObjectEditorViewController.h"

#import "NSObject+RSEditor.h"
#import "../FormItems/RSTextInputPropertyEditor.h"
#import "RSTextFieldTableViewCell.h"


@implementation RSObjectEditorViewController
{
    // An array of RSFormSection objects that determine what PropertyEditors are shown.
    NSMutableArray<RSFormSection *> *_formSections;

    // State variable for tracking whether this object has been shown before. On the first
    // view, and when the style is RSObjectEditorViewStyleForm, and when the first form item
    // is a RSTextInputPropertyEditor, focus will automatically be given to the text field of
    // the RSTextInputPropertyEditor.
    BOOL _previouslyViewed;
}

#pragma mark - NSObject

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_previouslyViewed && _style == RSObjectEditorViewStyleForm)
    {
        RSFormItem *formItem = [self formItemForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ([formItem canBecomeFirstResponder])
            [formItem becomeFirstResponder];
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

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title formSections:(nonnull NSArray<RSFormSection *> *)formSections
{
    if ((self = [super initWithStyle:UITableViewStyleGrouped]))
    {
        _autoTextFieldNavigation = YES;
        _lastTextFieldReturnKeyType = UIReturnKeyDone;
        _textEditingMode = RSTextEditingModeNotEditing;

        [self setTitle:title formSections:formSections];
    }
    return self;
}

- (nonnull instancetype)initWithObject:(nonnull NSObject *)object
{
    return [self initWithTitle:[object editorTitle] formSections:[object formSections]];
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

- (void)setFormSections:(NSArray *)formSections
{
    if (_formSections != formSections)
    {
        _formSections = [[NSMutableArray alloc] initWithArray:formSections];
        _lastTextInputPropertyEditor = [self findLastTextInputPropertyEditor];
        _activeTextField = nil;
    }
}

- (void)setTitle:(nonnull NSString *)title formSections:(nonnull NSArray<RSFormSection *> *)formSections
{
    [self setFormSections:formSections];

    self.title = title;
    
    if (self.viewLoaded)
        [self.tableView reloadData];
}

- (void)replaceFormSectionAtIndex:(NSUInteger)index withFormSection:(nonnull RSFormSection *)propertyGroup
{
    _formSections[index] = propertyGroup;

    // We might need to fix-up the return key type of the last text field if
    // autoTextFieldNavigation is YES
    
    if (_autoTextFieldNavigation)
    {
        RSTextFieldTableViewCell *cell = _lastTextInputPropertyEditor.tableViewCell;
        
        if (cell)
            cell.textField.returnKeyType = _lastTextInputPropertyEditor.returnKeyType;
    }
    
    _lastTextInputPropertyEditor = [self findLastTextInputPropertyEditor];
    
    if (_autoTextFieldNavigation)
    {
        RSTextFieldTableViewCell *cell = _lastTextInputPropertyEditor.tableViewCell;
        
        if (cell)
            cell.textField.returnKeyType = _lastTextFieldReturnKeyType;
    }

    if (self.viewLoaded)
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
}

- (nonnull RSFormItem *)formItemForIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSFormSection *formSection = _formSections[indexPath.section];
    RSFormItem *formItem = formSection.formItems[indexPath.row];
    return formItem;
}

- (nullable RSTextInputPropertyEditor *)findLastTextInputPropertyEditor
{
    for (NSInteger section = _formSections.count-1; section >= 0; --section)
    {
        RSFormSection *formSection = _formSections[section];
        
        for (NSInteger row = formSection.formItems.count-1; row >= 0; --row)
        {
            RSFormItem *formItem = formSection.formItems[row];
            
            if ([formItem isKindOfClass:[RSTextInputPropertyEditor class]])
                return (RSTextInputPropertyEditor *)formItem;
        }
    }
    return nil;
}

- (nullable NSIndexPath *)findNextTextInputAfterEditor:(nonnull RSFormItem *)targetEditor
{
    NSUInteger sections = _formSections.count;
    BOOL textInputEditorFound = NO;
    
    for (NSUInteger section = 0; section < sections; ++section)
    {
        RSFormSection *formSection = _formSections[section];
        NSUInteger rows = formSection.formItems.count;
        
        for (NSUInteger row = 0; row < rows; ++row)
        {
            RSFormItem *formItem = formSection.formItems[row];
            
            if (textInputEditorFound)
            {
                if ([formItem isKindOfClass:[RSTextInputPropertyEditor class]])
                    return [NSIndexPath indexPathForRow:row inSection:section];
            }
            else if (formItem == targetEditor)
                textInputEditorFound = YES;
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
    RSFormItem *formItem = [self formItemForIndexPath:indexPath];
    
    if (formItem.selectable)
        return indexPath;
    else
        [self finishEditingForce:NO];
    return nil;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSFormItem *formItem = [self formItemForIndexPath:indexPath];
    
    if (formItem.selectable)
        [formItem controllerDidSelectFormItem:self];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSFormItem *formItem = [self formItemForIndexPath:indexPath];
    UITableViewCell *cell = [formItem tableViewCellForController:self];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RSFormSection *formSection = _formSections[section];
    return formSection.formItems.count;
}

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return _formSections.count;
}

- (nullable NSString *)tableView:(nonnull UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    RSFormSection *formSection = _formSections[section];
    return formSection.title;
}

- (nullable NSString *)tableView:(nonnull UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    RSFormSection *formSection = _formSections[section];
    return formSection.footer;
}

#pragma mark RSFormContainer

@synthesize activeTextField = _activeTextField;
@synthesize lastTextInputPropertyEditor = _lastTextInputPropertyEditor;
@synthesize textEditingMode = _textEditingMode;

@end
