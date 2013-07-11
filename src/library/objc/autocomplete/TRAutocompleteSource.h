//
// TRAutocompleteSource.h
//
// © Reaction Software Inc., 2013
//

#import <Foundation/Foundation.h>

/// The TRAutocompeteSource protocol defines an interface for objects that provide autocomplete
/// suggestions for a prefix string.
@protocol TRAutocompleteSource <NSObject>

- (NSArray *)autocompleteSuggestionsForPrefix:(NSString *)prefix;

@end
