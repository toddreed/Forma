//
// Forma
// RSArrayAutocompleteSource.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSArrayAutocompleteSource.h"

@implementation RSArrayAutocompleteSource
{
    NSArray *_array;
}

#pragma mark - NSObject

- (nonnull instancetype)init
{
    return [self initWithArray:@[]];
}

#pragma mark - RSArrayAutocompleteSource

- (nonnull instancetype)initWithArray:(nonnull NSArray<NSString *> *)array
{
    NSParameterAssert(array != nil);
    self = [super init];
    NSParameterAssert(self != nil);

    _array = [array copy];

    return self;
}

#pragma mark RSAutocompleteSource

- (nonnull NSArray<NSString *> *)autocompleteSuggestionsForPrefix:(nonnull NSString *)prefix
{
    return [_array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject hasPrefix:prefix];
    }]];
}

@end
