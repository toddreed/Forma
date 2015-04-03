//
// RSPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyEditor.h"


@implementation RSPropertyEditor

#pragma mark NSObject

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"-[%@ %@] not supported", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSParameterAssert([keyPath isEqualToString:_key]);
    [self propertyChangedToValue:[change objectForKey:NSKeyValueChangeNewKey]];
}

#pragma mark RSPropertyEditor

- (id)initWithKey:(NSString *)key title:(NSString *)title
{
    if ((self = [super init]))
    {
        _key = key;
        _title = title;
        _tag = -1;
    }
    return self;
}

- (void)startObserving:(NSObject *)editedObject
{
    if (_key && !_observing)
    {
        _target = editedObject;
        [editedObject addObserver:self forKeyPath:_key options:NSKeyValueObservingOptionNew context:NULL];
        _observing = YES;
    }
}

- (void)stopObserving:(NSObject *)editedObject
{
    if (_key && _observing)
    {
        _target = nil;
        [editedObject removeObserver:self forKeyPath:_key];
        _observing = NO;
        _tableViewCell = nil;
    }
}

- (void)propertyChangedToValue:(id)newValue
{
    // Subclasses will override this method to update the UI to reflect the new value
}

- (UITableViewCell *)tableCellForValue:(id)value controller:(RSObjectEditorViewController *)controller
{
    if (_tableViewCell == nil)
    {
        _tableViewCell = [self newTableViewCell];
        [self configureTableCellForValue:value controller:controller];
    }
    return _tableViewCell;
}

- (UITableViewCell *)newTableViewCell
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
}

- (void)configureTableCellForValue:(id)value controller:(RSObjectEditorViewController *)controller
{
    _tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label = _tableViewCell.textLabel;
    
    label.text = _title;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.6;
    
    _tableViewCell.detailTextLabel.text = nil; // This is needed to vertically align textLabel in the centre on a device (it's not needed on the simulator).
}

- (void)tableCellSelected:(UITableViewCell *)cell forValue:(id)value controller:(UITableViewController *)controller
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
