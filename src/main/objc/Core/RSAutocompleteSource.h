//
// Forma
// RSAutocompleteSource.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>

/// The RSAutocompeteSource protocol defines an interface for objects that provide autocomplete
/// suggestions for a prefix string.
@protocol RSAutocompleteSource <NSObject>

- (nonnull NSArray<NSString *> *)autocompleteSuggestionsForPrefix:(nonnull NSString *)prefix;

@end
