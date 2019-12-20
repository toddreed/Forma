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
    NSInteger *_values;
}

#pragma mark - NSObject

- (void)dealloc
{
    free(_values);
}

#pragma mark - RSEnumDescriptor

- (nonnull instancetype)initWithEnumValues:(nonnull NSInteger *)values labels:(nonnull NSArray<NSString *> *)labels
{
    NSParameterAssert(labels != nil);
    NSParameterAssert(labels.count > 0);

    self = [super init];
    const NSUInteger items = labels.count;
    _values = malloc(sizeof(NSInteger) * items);
    memcpy(_values, values, sizeof(NSInteger) * items);
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
        if (_values[i] == value)
            return i;
    }
    NSString *reason = [NSString stringWithFormat:@"The value %ld is not a valid enumeration value.", (long)value];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (NSInteger)valueForIndex:(NSUInteger)index
{
    NSParameterAssert(index < _labels.count);
    return _values[index];
}

@end
