//
// RFetchRequestAutocompleteSource.h
//
// © Reaction Software Inc., 2013
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "../Core/RSAutocompleteSource.h"


@interface RSFetchRequestAutocompleteSource : NSObject <RSAutocompleteSource>

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context entityName:(NSString *)entityName attributeKey:(NSString *)attributeKey;

@end
