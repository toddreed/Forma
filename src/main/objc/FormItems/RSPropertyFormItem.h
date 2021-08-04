//
// Forma
// RSPropertyFormItem.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>

#import "RSFormItem.h"


/// RSPropertyFormItem is an abstract base class for form items that are associated with an
/// object’s property. There are two conceptual types of property form items: “viewers” and
/// “editors”. Concrete subclasses of RSPropertyFormItem provide support for viewing or editing
/// specific types of properties. For example, RSTextInputPropertyEditor provides support for
/// editing NSString properties.
///
/// RSPropertyFormItem uses key-value observing to keep the UI synchronized with changes to the
/// model object. If the model’s properties are modified via its accessors and the model’s class
/// is KVO compliant, the UI will automatically update to reflect the changed property value.
///
/// Similarly, RSPropertyFormItems that are editors uses key-value coding to automatically update
/// a model’s property value that is changed from a UI control.
@interface RSPropertyFormItem : RSFormItem

/// The object this editor modifies.
@property (nonatomic, readonly, nonnull) id object;

/// The key used to update the model object with KVC.
@property (nonatomic, readonly, nonnull) NSString *key;

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nonnull id)object title:(nonnull NSString *)title;

/// This method must be overridden by subclasses to update their UI to reflect a change in the
/// observed property’s value.
- (void)propertyChangedToValue:(nullable id)newValue;

@end

