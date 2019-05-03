//
// Forma
// RSArrayAutocompleteSource.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>
#import "RSAutocompleteSource.h"

@interface RSArrayAutocompleteSource : NSObject <RSAutocompleteSource>

- (nonnull instancetype)init;
- (nonnull instancetype)initWithArray:(nonnull NSArray<NSString *> *)array NS_DESIGNATED_INITIALIZER;

@end
