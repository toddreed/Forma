//
// RSPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyEditor.h"


@implementation RSPropertyEditor

#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString *, id> *)change context:(void *_Nullable)context
{
    NSParameterAssert([keyPath isEqualToString:_key]);
    id value = [change objectForKey:NSKeyValueChangeNewKey];
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

- (nonnull UITableViewCell *)tableCellForValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
{
    if (_tableViewCell == nil)
    {
        _tableViewCell = [self newTableViewCell];
        [self configureTableCellForValue:value controller:controller];
    }
    return _tableViewCell;
}

- (nonnull UITableViewCell *)newTableViewCell
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
}

- (void)configureTableCellForValue:(nullable id)value controller:(nonnull RSObjectEditorViewController *)controller
{
    _tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label = _tableViewCell.textLabel;
    
    label.text = _title;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.6;
    
    _tableViewCell.detailTextLabel.text = nil; // This is needed to vertically align textLabel in the centre on a device (it's not needed on the simulator).
}

- (void)tableCellSelected:(nonnull UITableViewCell *)cell forValue:(nullable id)value controller:(nonnull UITableViewController *)controller
{
    // Do nothing here; subclass will override with appropriate action.
}

- (CGFloat)tableCellHeightForController:(RSObjectEditorViewController *)controller
{
    return 44.0f;
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
