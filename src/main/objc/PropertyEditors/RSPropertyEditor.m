//
// RSPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyEditor.h"
#import "../Core/RSObjectEditor.h"


static void *ObservationContext = &ObservationContext;

static void PerformOnMainThread(dispatch_block_t block)
{
    if ([NSThread isMainThread])
        block();
    else
        dispatch_async(dispatch_get_main_queue(), block);
}


@implementation RSPropertyEditor
{
    __kindof UITableViewCell<RSPropertyEditorView> *_tableViewCell;
}

#pragma mark - NSObject

- (void)dealloc
{
    [self stopObserving];
}

#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(nullable void *)context
{
    if (context == ObservationContext)
    {
        NSParameterAssert([keyPath isEqualToString:_key]);

        id value = change[NSKeyValueChangeNewKey];
        if (value == [NSNull null])
            value = nil;

        dispatch_block_t block = ^{
            [self propertyChangedToValue:value];
        };
        PerformOnMainThread(block);
    }
    else if ([super respondsToSelector:_cmd])
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark RSPropertyEditor

- (nonnull instancetype)initWithKey:(nullable NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title
{
    self = [super init];
    NSParameterAssert(self != nil);

    _key = [key copy];
    _object = object;
    _title = [title copy];

    return self;
}

- (UITableViewCell<RSPropertyEditorView> *)tableViewCell
{
    if (_tableViewCell == nil)
        _tableViewCell = [self newTableViewCell];
    return _tableViewCell;
}

- (void)startObserving
{
    if (_object != nil && _key != nil && !_observing)
    {
        [_object addObserver:self forKeyPath:_key options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:ObservationContext];
        _observing = YES;
    }
}

- (void)stopObserving
{
    if (_object != nil && _key != nil && _observing)
    {
        [_object removeObserver:self forKeyPath:_key context:ObservationContext];
        _observing = NO;
    }
}

- (void)propertyChangedToValue:(nullable id)newValue
{
    // Subclasses will override this method to update the UI to reflect the new value
}

+ (nonnull __kindof UITableViewCell<RSPropertyEditorView> *)instantiateTableViewCellFromNibOfClass:(Class)cls
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cls) bundle:RSObjectEditor.bundle];
    return [nib instantiateWithOwner:self options:nil][0];
}

- (nonnull UITableViewCell<RSPropertyEditorView> *)newTableViewCell
{
    NSString *reason = [NSString stringWithFormat:@"%s must be implemented in %@ or a superclass", __func__, NSStringFromClass([self class])];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (nonnull __kindof UITableViewCell<RSPropertyEditorView> *)tableViewCellForController:(nonnull RSObjectEditorViewController *)controller
{
    if (_tableViewCell == nil)
    {
        __unused UITableViewCell<RSPropertyEditorView> *cell = self.tableViewCell; // getter will instantiate cell
        [self configureTableViewCellForController:controller];
        [self startObserving];
    }
    return _tableViewCell;
}

- (void)configureTableViewCellForController:(nonnull RSObjectEditorViewController *)controller
{
    UITableViewCell<RSPropertyEditorView> *cell = self.tableViewCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *titleLabel = cell.titleLabel;
    if (titleLabel != nil)
        titleLabel.text = _title;
}

- (void)controllerDidSelectEditor:(nonnull RSObjectEditorViewController *)controller
{
    // Do nothing here; subclass will override with appropriate action.
}

- (BOOL)selectable
{
    return NO;
}

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

- (void)becomeFirstResponder
{
    NSAssert(NO, @"Invalid state: property editor asked to become first responder when it can't.");
}

@end
