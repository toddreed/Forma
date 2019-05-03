//
// Forma
// RSFormNavigation.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSFormItem.h"

// A RSFormNavigation is form item that navigates to another form for an ancillary object. This
// must only be used with a RSFormViewController that is on the stack of a
// UINavigationController. The UI for a RSFormNavigation displays a title and a summary of the
// object’s value obtained with -descriptionWithLocale:, or if this method is not defined,
// -description.
@interface RSFormNavigation : RSFormItem

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithTitle:(nonnull NSString *)title object:(nonnull NSObject *)object NS_DESIGNATED_INITIALIZER;

@end
