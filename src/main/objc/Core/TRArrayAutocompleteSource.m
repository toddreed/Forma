//
//  TRArrayAutocompleteSource.m
//  Object Editor
//
//  Created by Todd Reed on 2013-07-10.
//  Copyright (c) 2013 Reaction Software Inc. All rights reserved.
//

#import "TRArrayAutocompleteSource.h"

@implementation TRArrayAutocompleteSource
{
    NSArray *_array;
}

#pragma mark - NSObject

- (id)init
{
    return [self initWithArray:@[]];
}

#pragma mark - TRArrayAutocompleteSource

- (id)initWithArray:(NSArray *)array
{
    NSParameterAssert(array != nil);
    self = [super init];
    if (self)
    {
        _array = array;
    }
    return self;
}

#pragma mark TRAutocompleteSource

- (NSArray *)autocompleteSuggestionsForPrefix:(NSString *)prefix
{
    return [_array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject hasPrefix:prefix];
    }]];
}

@end
