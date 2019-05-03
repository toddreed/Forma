//
//  RSArrayAutocompleteSource.m
//  Forma
//
//  Created by Todd Reed on 2013-07-10.
//  Copyright (c) 2013 Reaction Software Inc. All rights reserved.
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
