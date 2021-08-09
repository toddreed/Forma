//
// Forma
// RSEnumDescriptor.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSEnumDescriptor.h"

@implementation RSEnumDescriptor
{
    NSArray<NSNumber *> *_values;
}

#pragma mark - RSEnumDescriptor

- (nonnull instancetype)initWithEnumValues:(nonnull NSArray<NSNumber *> *)values labels:(nonnull NSArray<NSString *> *)labels
{
    NSParameterAssert(values != nil);
    NSParameterAssert(values.count > 0);
    NSParameterAssert(labels != nil);
    NSParameterAssert(values.count == labels.count);

    self = [super init];
    _values = [values copy];
    _labels = [labels copy];
    return self;
}

- (nonnull NSString *)labelForValue:(NSInteger)value
{
    NSInteger index = [self indexOfValue:value];
    return [_labels objectAtIndex:index];
}

- (nonnull NSString *)labelForIndex:(NSUInteger)index
{
    return [_labels objectAtIndex:index];
}

- (NSUInteger)indexOfValue:(NSInteger)value
{
    const NSUInteger count = _labels.count;
    for (NSUInteger i = 0; i < count; ++i)
    {
        if (_values[i].integerValue == value)
            return i;
    }
    NSString *reason = [NSString stringWithFormat:@"The value %ld is not a valid enumeration value.", (long)value];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (NSInteger)valueForIndex:(NSUInteger)index
{
    NSParameterAssert(index < _labels.count);
    return _values[index].integerValue;
}

@end
