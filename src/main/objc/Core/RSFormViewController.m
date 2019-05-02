//
// RSFormViewController.m
//
// © Reaction Software Inc., 2013
//


#import "RSFormViewController.h"

#import "NSObject+RSForm.h"
#import "../FormItems/RSTextInputPropertyEditor.h"
#import "RSTextFieldTableViewCell.h"


@implementation RSFormViewController
{
    RSForm *_form;

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
    
    if (!_previouslyViewed)
    {
        RSFormItem *formItem = [_form formItemForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
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

#pragma mark - RSFormViewController

- (nonnull instancetype)initWithForm:(nonnull RSForm *)form
{
    if ((self = [super initWithStyle:UITableViewStyleGrouped]))
    {
        self.title = form.title;

        _textEditingMode = RSTextEditingModeNotEditing;
        _form = form;
        _form.formContainer = self;
    }
    return self;

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
        [_formDelegate formContainer:self didEndEditingSessionWithAction:RSFormActionCommit];
        if (_completionBlock)
            _completionBlock(NO);
    }
}

- (void)cancelPressed
{
    [self cancelEditing];
    [_formDelegate formContainer:self didEndEditingSessionWithAction:RSFormActionCancel];
    if (_completionBlock)
        _completionBlock(YES);
}

#pragma mark UITableViewDelegate

- (nullable NSIndexPath *)tableView:(nonnull UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSFormItem *formItem = [_form formItemForIndexPath:indexPath];
    
    if (formItem.selectable)
        return indexPath;
    else
        [self finishEditingForce:NO];
    return nil;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSFormItem *formItem = [_form formItemForIndexPath:indexPath];
    
    if (formItem.selectable)
        [formItem controllerDidSelectFormItem:self];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSFormItem *formItem = [_form formItemForIndexPath:indexPath];
    return formItem.tableViewCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RSFormSection *formSection = _form.sections[section];
    return formSection.formItems.count;
}

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return _form.sections.count;
}

- (nullable NSString *)tableView:(nonnull UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    RSFormSection *formSection = _form.sections[section];
    return formSection.title;
}

- (nullable NSString *)tableView:(nonnull UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    RSFormSection *formSection = _form.sections[section];
    return formSection.footer;
}

#pragma mark RSFormContainer

@synthesize form = _form;
@synthesize activeTextField = _activeTextField;
@synthesize textEditingMode = _textEditingMode;
@synthesize formDelegate = _formDelegate;

@end
