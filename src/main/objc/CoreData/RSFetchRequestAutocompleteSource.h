//
// RFetchRequestAutocompleteSource.h
//
// © Reaction Software Inc., 2013
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "../Core/RSAutocompleteSource.h"


@interface RSFetchRequestAutocompleteSource : NSObject <RSAutocompleteSource>

- (nonnull instancetype)initWithManagedObjectContext:(nonnull NSManagedObjectContext *)context entityName:(nonnull NSString *)entityName attributeKey:(nonnull NSString *)attributeKey;

@end
