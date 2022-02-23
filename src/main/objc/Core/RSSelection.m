//
// Forma
// RSSelection.m
//
// © Reaction Software Inc. and Todd Reed, 2022
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSSelection.h"


@implementation RSOption

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (value: %@)", _label, _value];
}

#pragma mark - RSOption

+ (nonnull instancetype)optionForValue:(nullable id<NSCopying>)value label:(nonnull NSString *)label
{
    return [[self alloc] initWithValue:value label:label];
}

- (nonnull instancetype)initWithValue:(nullable id<NSCopying>)value label:(nonnull NSString *)label
{
    self = [super init];
    _value = [value copyWithZone:nil];
    _label = [label copy];
    return self;
}

@end


@implementation RSSelection

- (nonnull instancetype)initWithOptions:(nonnull NSArray<RSOption *> *)options
{
    NSParameterAssert(options != nil);
    NSParameterAssert(options.count > 0);
    self = [super init];
    _options = [options copy];
    return self;
}

- (nonnull NSString *)labelForValue:(nullable id)value
{
    NSUInteger index = [self indexOfValue:value];
    return _options[index].label;
}

- (nonnull NSString *)labelForIndex:(NSUInteger)index
{
    return _options[index].label;
}

- (NSUInteger)indexOfValue:(nullable id)value
{
    NSUInteger index = [_options indexOfObjectPassingTest:^BOOL(RSOption * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (value == nil)
            return obj == nil;
        else
            return [value isEqual:obj.value];
    }];
    return index;
}

- (nullable id)valueForIndex:(NSUInteger)index
{
    return _options[index].value;
}

@end
