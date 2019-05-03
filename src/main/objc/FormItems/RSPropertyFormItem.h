//
//  RSPropertyFormItem.h
//  Forma
//
//  Created by Todd Reed on 2019-05-01.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
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
/// Similarly, RSPropertyFormItem that are editors uses key-value coding to automatically update
/// a model’s property value that is changed from a UI control.
@interface RSPropertyFormItem : RSFormItem

/// The object this editor modifies.
@property (nonatomic, readonly, nullable) id object;

/// The key use to update the model object with KVC. This is always non-nil for “normal” property
/// editors, but some special “pseudo” property editors have a nil key; RSFormNavigation and
/// RSFormButton are examples.
@property (nonatomic, readonly, nullable) NSString *key;

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithKey:(nullable NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title;

/// This method must be overridden by subclasses to update their UI to reflect a change in the
/// observed property’s value.
- (void)propertyChangedToValue:(nullable id)newValue;

@end

