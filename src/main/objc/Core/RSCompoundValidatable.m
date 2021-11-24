//
// Forma
// RSCompoundValidatable.m
//
// © Reaction Software Inc. and Todd Reed, 2021
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSCompoundValidatable.h"

@implementation RSCompoundValidatable
{
    // _validCount is the number of validatables that return YES for their valid property.
    NSUInteger _validCount;
    NSMutableArray<id<RSValidatable>> *_validatables;
}

#pragma - NSObject

- (instancetype)init
{
    return [self initWithValidatables:@[]];
}

- (void)dealloc
{
    for (NSObject<RSValidatable> *validatable in _validatables)
        [validatable removeObserver:self forKeyPath:@"valid" context:ObservationContext];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"valid"])
        return NO;
    else
        return [super automaticallyNotifiesObserversForKey:key];
}

#pragma mark NSKeyValueObserving

static void *ObservationContext = &ObservationContext;

- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(nullable void *)context
{
    if (context == ObservationContext)
    {
        NSParameterAssert([keyPath isEqualToString:@"valid"]);

        NSNumber *newValue = change[NSKeyValueChangeNewKey];
        NSNumber *oldValue = change[NSKeyValueChangeOldKey];

        BOOL changed = ![newValue isEqual:oldValue];
        if (changed)
        {
            if (newValue.boolValue)
            {
                NSAssert(_validCount < _validatables.count, @"unexpected state");
                ++_validCount;
                if (_validCount == _validatables.count)
                {
                    [self willChangeValueForKey:@"valid"];
                    _valid = YES;
                    [self didChangeValueForKey:@"valid"];
                    [_validatableDelegate validatableChanged:self];
                }
            }
            else
            {
                NSAssert(_validCount > 0, @"unexpected state");
                --_validCount;
                if (_validCount == _validatables.count-1)
                {
                    [self willChangeValueForKey:@"valid"];
                    _valid = NO;
                    [self didChangeValueForKey:@"valid"];
                    [_validatableDelegate validatableChanged:self];
                }
            }
        }
    }
    else if ([super respondsToSelector:_cmd])
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma - RSCompoundValidatable

- (nonnull instancetype)initWithValidatables:(nonnull NSArray<NSObject<RSValidatable> *> *)validatables
{
    NSParameterAssert(validatables != nil);
    
    self = [super init];
    _validatables = [validatables mutableCopy];
    _validCount = 0;

    for (NSObject<RSValidatable> *validatable in validatables)
    {
        if (validatable.valid)
            ++_validCount;
        [validatable addObserver:self
                      forKeyPath:@"valid"
                         options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                         context:ObservationContext];
    }
    _valid = (_validCount == validatables.count);
    return self;
}

- (void)addValidatable:(nonnull NSObject<RSValidatable> *)validatable
{
    NSParameterAssert(validatable != nil);

    // TODO: This doesn’t not trigger KVO notifications or delegate callbacks
    
    [_validatables addObject:validatable];
    if (validatable.valid)
        ++_validCount;

    if (_valid && _validCount != _validatables.count)
    {
        [self willChangeValueForKey:@"valid"];
        _valid = NO;
        [self didChangeValueForKey:@"valid"];
        [_validatableDelegate validatableChanged:self];
    }
    [validatable addObserver:self
                  forKeyPath:@"valid"
                     options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                     context:ObservationContext];
}

#pragma RSValidatable

@synthesize valid = _valid;
@synthesize validatableDelegate = _validatableDelegate;

@end
