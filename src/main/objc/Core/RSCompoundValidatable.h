//
// Forma
// RSCompoundValidatable.h
//
// © Reaction Software Inc. and Todd Reed, 2021
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>

#import "RSValidatable.h"

@interface RSCompoundValidatable : NSObject <RSValidatable>

- (nonnull instancetype)initWithValidatables:(nonnull NSArray<NSObject<RSValidatable> *> *)validatables NS_DESIGNATED_INITIALIZER;

- (void)addValidatable:(nonnull NSObject<RSValidatable> *)validatable;

@end

