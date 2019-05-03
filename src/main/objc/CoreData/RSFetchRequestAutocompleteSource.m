//
// Forma
// RSFetchRequestAutocompleteSource.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSFetchRequestAutocompleteSource.h"


@implementation RSFetchRequestAutocompleteSource
{
    NSManagedObjectContext *_managedObjectContext;
    NSString *_entityName;
    NSString *_attributeKey;
}

#pragma mark - RSFetchRequestAutocompleteSource

- (nonnull instancetype)initWithManagedObjectContext:(nonnull NSManagedObjectContext *)context entityName:(nonnull NSString *)entityName attributeKey:(nonnull NSString *)attributeKey
{
    NSParameterAssert(context != nil);
    NSParameterAssert(entityName != nil);
    NSParameterAssert(attributeKey != nil);

    self = [super init];
    NSParameterAssert(self != nil);

    _managedObjectContext = context;
    _entityName = entityName;
    _attributeKey = attributeKey;

    return self;
}

#pragma mark RSAutocompleteSource

- (nonnull NSArray<NSString *> *)autocompleteSuggestionsForPrefix:(nonnull NSString *)prefix
{
    if (prefix.length > 0)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:_entityName inManagedObjectContext:_managedObjectContext];
        request.fetchLimit = 10;
        request.entity = entity;
        request.propertiesToFetch = @[entity.propertiesByName[_attributeKey]];
        [request setReturnsDistinctResults:YES];
        request.resultType = NSDictionaryResultType;

        NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:_attributeKey];
        NSExpression *valueExpression = [NSExpression expressionForConstantValue:prefix];
        NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:keyPathExpression
                                                                    rightExpression:valueExpression
                                                                           modifier:NSDirectPredicateModifier
                                                                               type:NSBeginsWithPredicateOperatorType
                                                                            options:NSNormalizedPredicateOption];

        request.predicate = predicate;

        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:_attributeKey ascending:YES];
        request.sortDescriptors = @[sortDescriptor];

        NSError *error;
        NSArray *results = [_managedObjectContext executeFetchRequest:request error:&error];

        if (results)
        {
            if (results.count > 0)
            {
                NSMutableArray *suggestions = [[NSMutableArray alloc] initWithCapacity:results.count];
                for (NSDictionary *result in results)
                {
                    [suggestions addObject:result[_attributeKey]];
                }
                return suggestions;
            }
            else
                return @[];
        }
        else
        {
            NSLog(@"Failed to execute autocomplete query: %@", error);
            return @[];
        }
    }
    else
        return @[];
}

@end
