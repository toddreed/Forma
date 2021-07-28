//
// Forma
// RSEnumDescriptor.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>

/// The RSEnumDescriptor class provides a runtime reflection interface for C enum types. Since
/// Objective-C doesn’t provide reflection for C types, this class must be
/// manually initialized for C enum types.
///
/// Consider the enum type below:
///
/// typedef enum Size
/// {
///     Small,
///     Medium,
///     Large
/// } Size;
///
/// A RSEnumDescriptor for Size would be created like this:
///
/// ```objc
/// NSInteger values[] = {Small, Medium, Large};
/// NSArray<NSString *> *labels = @[@"Small", @"Medium", @"Large"];
/// RSEnumDescriptor *desc = [[RSEnumDescriptor alloc] initWithEnumValues:values labels:labels];
/// ```
///
@interface RSEnumDescriptor : NSObject

@property (nonatomic, strong, readonly, nonnull) NSArray<NSString *> *labels;

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;

// Designated initializer. The size of the enumValues array is assumed to the same size as the
// labels array.
- (nonnull instancetype)initWithEnumValues:(nonnull NSInteger *)enumValues labels:(nonnull NSArray<NSString *> *)labels NS_DESIGNATED_INITIALIZER;

- (nonnull NSString *)labelForValue:(NSInteger)value;
- (nonnull NSString *)labelForIndex:(NSUInteger)index;
- (NSUInteger)indexOfValue:(NSInteger)value;
- (NSInteger)valueForIndex:(NSUInteger)index;

@end
