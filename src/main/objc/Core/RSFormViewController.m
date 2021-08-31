//
// Forma
// RSFormViewController.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSFormViewController.h"

#import "NSObject+RSForm.h"
#import "RSTableHeaderImageView.h"
#import "RSTableFooterButtonView.h"

@implementation RSFormViewController
{
    RSForm *_form;
    CGFloat _headerViewLayoutWidth;
    CGFloat _footerViewLayoutWidth;

    UIBarButtonItem *_doneBarButtonItem;
    UIBarButtonItem *_cancelBarButtonItem;

    // State variable for tracking whether this object has been shown before. On the first
    // view and when the first form item is a RSTextInputPropertyEditor, focus will
    // automatically be given to the text field of the RSTextInputPropertyEditor.
    BOOL _previouslyViewed;
}

#pragma mark - NSObject

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_previouslyViewed)
    {
        if (_form.autoTextFieldNavigation)
        {
            RSFormItem *formItem = [_form formItemForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            if ([formItem canBecomeFirstResponder])
                [formItem becomeFirstResponder];
        }
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

    if (_headerView == nil)
    {
        if (_headerImage != nil)
            self.tableView.tableHeaderView = [[RSTableHeaderImageView alloc] initWithImage:_headerImage];
    }
    else
        self.tableView.tableHeaderView = _headerView;

    if (_footerView == nil)
    {
        if (_submitButton != nil)
            self.tableView.tableFooterView = [[RSTableFooterButtonView alloc] initWithButton:_submitButton];
    }
    else
        self.tableView.tableFooterView = _footerView;

    [_submitButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self updateButtons];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(contentSizeCategoryDidChangeNotification:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!self.beingDismissed)
    {
        UITableView *tableView = self.tableView;
        if (tableView.tableHeaderView != nil)
            [self layoutTableHeaderView];
        if (tableView.tableFooterView != nil)
            [self layoutTableFooterView];
    }
}

- (BOOL)isModalInPresentation
{
    if (_form.modified)
        return YES;
    else
        return !_showCancelButton;
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
        _doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
        _cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    }
    return self;

}

- (void)contentSizeCategoryDidChangeNotification:(NSNotification *)notification
{
    if (self.viewLoaded)
        [self.tableView reloadData];
}

- (void)setShowCancelButton:(BOOL)f
{
    if (!_showCancelButton && f)
        self.navigationItem.leftBarButtonItem = _cancelBarButtonItem;
    else if (_showCancelButton && !f)
        self.navigationItem.leftBarButtonItem = nil;
    _showCancelButton = f;
}

- (void)setShowDoneButton:(BOOL)f
{
    if (!_showDoneButton && f)
        self.navigationItem.rightBarButtonItem = _doneBarButtonItem;
    else if (_showDoneButton && !f)
        self.navigationItem.rightBarButtonItem = nil;

    _showDoneButton = f;
}

- (void)updateButtons
{
    if (_form.enabled)
    {
        BOOL valid = _form.delegate == nil || [_form.delegate isFormValid:_form];
        BOOL buttonsEnabled = valid;

        _submitButton.enabled = buttonsEnabled;
        _cancelBarButtonItem.enabled = buttonsEnabled;
        _doneBarButtonItem.enabled = buttonsEnabled;
    }
    else
    {
        _submitButton.enabled = NO;
        _cancelBarButtonItem.enabled = NO;
        _doneBarButtonItem.enabled = NO;
    }
}

- (BOOL)enabled
{
    return _form.enabled;
}

- (void)setEnabled:(BOOL)enabled
{
    _form.enabled = enabled;
    [self updateButtons];
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
    [self commitForm];
}

- (void)cancelPressed
{
    [self cancelForm];
}

- (void)layoutTableHeaderView
{
    NSAssert(self.tableView.tableHeaderView != nil, @"No table header view set");
    UITableView *tableView = self.tableView;
    CGFloat tableWidth = tableView.bounds.size.width;

    if (_headerViewLayoutWidth != tableWidth)
    {
        _headerViewLayoutWidth = tableWidth;
        UIView *headerView = tableView.tableHeaderView;
        if ([self layoutTableHeaderOrFooter:headerView withWidth:tableWidth])
            tableView.tableHeaderView = headerView;
    }
}

- (void)layoutTableFooterView
{
    NSAssert(self.tableView.tableFooterView != nil, @"No table footer set");
    UITableView *tableView = self.tableView;
    CGFloat tableWidth = tableView.bounds.size.width;

    if (_footerViewLayoutWidth != tableWidth)
    {
        _footerViewLayoutWidth = tableWidth;
        UIView *footerView = tableView.tableFooterView;
        if ([self layoutTableHeaderOrFooter:footerView withWidth:tableWidth])
            tableView.tableFooterView = footerView;
    }
}

- (bool)layoutTableHeaderOrFooter:(nonnull UIView *)headerOrFooterView withWidth:(CGFloat)width
{
    NSParameterAssert(headerOrFooterView != nil);
    CGSize size = [headerOrFooterView sizeThatFits:CGSizeMake(width, 0)];

    if (!CGSizeEqualToSize(headerOrFooterView.frame.size, size))
    {
        CGRect frame = headerOrFooterView.frame;
        frame.size = size;
        headerOrFooterView.frame = frame;
        return true;
    }
    return false;
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

- (void)commitForm
{
    if ([self finishEditingForce:NO])
    {
        BOOL valid = _form.delegate == nil || [_form.delegate isFormValid:_form];
        if (valid)
        {
            [_formDelegate formContainer:self didEndEditingSessionWithAction:RSFormActionCommit];
            if (_completionBlock)
                _completionBlock(self, NO);
        }
    }
}

- (void)cancelForm
{
    [self cancelEditing];
    [_formDelegate formContainer:self didEndEditingSessionWithAction:RSFormActionCancel];
    if (_completionBlock)
        _completionBlock(self, YES);
}

- (void)formWasUpdated
{
    [self updateButtons];
}

#pragma mark UIAdaptivePresentationControllerDelegate

- (BOOL)presentationControllerShouldDismiss:(UIPresentationController *)presentationController
{
    return !_form.modified;
}

- (void)presentationControllerDidAttemptToDismiss:(UIPresentationController *)presentationController
{
    if (_showCancelButton)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Save Changes?", @"alert button")
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"alert button") style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Discard", @"alert button") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self cancelForm];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Save", @"alert button") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self commitForm];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
