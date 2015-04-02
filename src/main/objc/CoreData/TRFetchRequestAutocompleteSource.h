//
// RFetchRequestAutocompleteSource.h
//
// © Reaction Software Inc., 2013
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "../Core/TRAutocompleteSource.h"


@interface TRFetchRequestAutocompleteSource : NSObject <TRAutocompleteSource>

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context entityName:(NSString *)entityName attributeKey:(NSString *)attributeKey;

@end
