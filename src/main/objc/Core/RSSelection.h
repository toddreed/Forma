//
// Forma
// RSSelection.h
//
// © Reaction Software Inc. and Todd Reed, 2022
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/// RSOption represent one choice in a selection.
///
/// @see RSSelection
@interface RSOption : NSObject

/// The label displayed in the UI for this option.
@property (nonatomic, readonly, copy, nonnull) NSString *label;

/// The value associated with this option.
@property (nonatomic, readonly, copy, nullable) id<NSCopying> value;

+ (nonnull instancetype)optionForValue:(nullable id<NSCopying>)value label:(nonnull NSString *)label;

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithValue:(nullable id<NSCopying>)value label:(nonnull NSString *)label;

@end



/// RSSelection represents a mutually exclusive choice among several options. In a desktop UI, this
/// would typically be presented with a dropdown menu or radio buttons.
@interface RSSelection : NSObject

/// The options available for selection.
@property (nonatomic, strong, readonly, nonnull) NSArray<RSOption *> *options;

/// An explanatory description of the selection’s purpose. This will be displayed above the
/// options in the UI.
@property (nonatomic, copy, nullable) NSString *expanatoryDescription;

/// An optional image to be displayed near the explanatory description.
@property (nonatomic, strong, nullable) UIImage *image;

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;

- (nonnull instancetype)initWithOptions:(nonnull NSArray<RSOption *> *)options NS_DESIGNATED_INITIALIZER;

- (nonnull NSString *)labelForValue:(nullable id)value;
- (nonnull NSString *)labelForIndex:(NSUInteger)index;
- (NSUInteger)indexOfValue:(nullable id)value;
- (nullable id)valueForIndex:(NSUInteger)index;

@end

