//
//  RSPropertyFormItem.m
//  Forma
//
//  Created by Todd Reed on 2019-05-01.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import "RSPropertyFormItem.h"


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

#pragma mark - RSFormItem

- (nonnull UITableViewCell<RSFormItemView> *)newTableViewCell
{
    UITableViewCell<RSFormItemView> *cell = [super newTableViewCell];

    return cell;
}

- (void)configureTableViewCell
{
    [super configureTableViewCell];
    [self startObserving];
}

#pragma mark - RSPropertyFormItem

- (nonnull instancetype)initWithKey:(nullable NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title
{
    self = [super initWithTitle:title];
    _key = [key copy];
    _object = object;
    return self;
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

@end
