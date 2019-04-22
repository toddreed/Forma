//
// RSPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyEditor.h"
#import "../Core/RSObjectEditor.h"


@implementation RSPropertyEditor

#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString *, id> *)change context:(void *_Nullable)context
{
    NSParameterAssert([keyPath isEqualToString:_key]);
    id value = change[NSKeyValueChangeNewKey];
    if (value == [NSNull null])
        value = nil;

    [self propertyChangedToValue:value];
}

#pragma mark RSPropertyEditor

- (nonnull instancetype)initWithKey:(nullable NSString *)key title:(nonnull NSString *)title
{
    self = [super init];
    NSParameterAssert(self != nil);

    _key = [key copy];
    _title = [title copy];
    _tag = -1;

    return self;
}

- (void)startObserving:(nonnull NSObject *)editedObject
{
    if (_key && !_observing)
    {
        _target = editedObject;
        [editedObject addObserver:self forKeyPath:_key options:NSKeyValueObservingOptionNew context:NULL];
        _observing = YES;
    }
}

- (void)stopObserving:(nonnull NSObject *)editedObject
{
    if (_key && _observing)
    {
        _target = nil;
        [editedObject removeObserver:self forKeyPath:_key];
        _observing = NO;
        _tableViewCell = nil;
    }
}

- (void)propertyChangedToValue:(nullable id)newValue
{
    // Subclasses will override this method to update the UI to reflect the new value
}

- (nonnull UITableViewCell<RSPropertyEditorView> *)tableCellForValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
{
    if (_tableViewCell == nil)
    {
        _tableViewCell = [self newTableViewCell];
        [self configureTableCellForValue:value controller:controller];
    }
    return _tableViewCell;
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

- (void)configureTableCellForValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
{
    _tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *titleLabel = _tableViewCell.titleLabel;
    if (titleLabel != nil)
        titleLabel.text = _title;
}

- (void)tableCellSelected:(nonnull UITableViewCell<RSPropertyEditorView> *)cell forValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
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
