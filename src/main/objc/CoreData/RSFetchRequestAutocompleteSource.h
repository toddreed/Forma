//
// Forma
// RSFetchRequestAutocompleteSource.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "../Core/RSAutocompleteSource.h"


@interface RSFetchRequestAutocompleteSource : NSObject <RSAutocompleteSource>

- (nonnull instancetype)initWithManagedObjectContext:(nonnull NSManagedObjectContext *)context entityName:(nonnull NSString *)entityName attributeKey:(nonnull NSString *)attributeKey;

@end
