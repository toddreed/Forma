//
// Forma
// RSValidatable.h
//
// © Reaction Software Inc. and Todd Reed, 2021
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>


@protocol RSValidatable;


@protocol RSValidatableDelegate <NSObject>

- (void)validatableChanged:(nonnull id<RSValidatable>)validatable;

@end


/// The RSValidatable protocol should be adopted by form items that can be validated. For
/// example, a form item with a text field is validatable if there are restrictions on what
/// input text is acceptable.
@protocol RSValidatable <NSObject>

/// Returns YES if the receiver is currently valid. This property MUST be KVO compliant.
@property (nonatomic, readonly, getter=isValid) BOOL valid;
@property (nonatomic, weak, nullable) id<RSValidatableDelegate> validatableDelegate;

@end

