//
// RSAutocompleteSource.h
//
// © Reaction Software Inc., 2013
//

#import <Foundation/Foundation.h>

/// The RSAutocompeteSource protocol defines an interface for objects that provide autocomplete
/// suggestions for a prefix string.
@protocol RSAutocompleteSource <NSObject>

- (NSArray *)autocompleteSuggestionsForPrefix:(NSString *)prefix;

@end
