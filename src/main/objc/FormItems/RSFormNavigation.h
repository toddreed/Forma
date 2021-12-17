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


typedef void (^RSFormNavigationAction)(UIViewController<RSFormContainer> *_Nonnull formContainer);

// A RSFormNavigation is form item that navigates to another view controller.
@interface RSFormNavigation : RSFormItem

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title UNAVAILABLE_ATTRIBUTE;

/// A convenience initializer for navigating to another RSFormViewController for an object.
///
/// @param title The title of the form item.
/// @param object The object to navigate to. `-formViewController` is sent to the object to
///   create an `RSFormViewController` instance for the object. This view controller is then
///   pushed onto the current form view controller’s navigation controller.
- (nonnull instancetype)initWithTitle:(nonnull NSString *)title object:(nonnull NSObject *)object;

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title navigationAction:(nonnull RSFormNavigationAction)navigationAction NS_DESIGNATED_INITIALIZER;

@end
