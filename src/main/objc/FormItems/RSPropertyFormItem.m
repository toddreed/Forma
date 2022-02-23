//
// Forma
// RSPropertyFormItem.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSPropertyFormItem.h"
#import "RSFormSection.h"
#import "RSForm.h"


static void *ObservationContext = &ObservationContext;

static void PerformOnMainThread(dispatch_block_t block)
{
    if ([NSThread isMainThread])
        block();
    else
        dispatch_async(dispatch_get_main_queue(), block);
}


@implementation RSPropertyFormItem
{
    BOOL _observing;
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

        id newValue = change[NSKeyValueChangeNewKey];
        id oldValue = change[NSKeyValueChangeOldKey];

        BOOL changed = NO;

        if (newValue == [NSNull null])
            newValue = nil;

        if (oldValue != nil)
        {
            if (oldValue == [NSNull null])
                oldValue = nil;
            changed = (newValue == nil && oldValue != nil) || (newValue != nil && oldValue == nil) || ![newValue isEqual:oldValue];
        }

        dispatch_block_t block = ^{
            if (changed)
                self.formSection.form.modified = YES;
            [self propertyChangedToValue:newValue];
        };
        PerformOnMainThread(block);
    }
    else if ([super respondsToSelector:_cmd])
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - RSFormItem

- (nonnull UITableViewCell *)newTableViewCell
{
    UITableViewCell *cell = [super newTableViewCell];

    return cell;
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];
    [self startObserving];
}

#pragma mark - RSPropertyFormItem

- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nonnull id)object title:(nonnull NSString *)title
{
    NSParameterAssert(key != nil);
    NSParameterAssert(object != nil);

    self = [super initWithTitle:title];
    _key = [key copy];
    _object = object;
    return self;
}

- (void)startObserving
{
    if (_object != nil && _key != nil && !_observing)
    {
        [_object addObserver:self
                  forKeyPath:_key
                     options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                     context:ObservationContext];
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

@end
