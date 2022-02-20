//
// Forma
// RSFormSection.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>

#import "../Core/RSCompoundValidatable.h"


@class RSFormItem;
@class RSForm;


@interface RSFormSection : RSCompoundValidatable

/// The form this form section belongs to.
@property (nonatomic, weak, readonly, nullable) RSForm *form;

@property (nonatomic) BOOL enabled;

@property (nonatomic, copy, nullable) NSString *title;

/// The text to be displayed in the section’s footer. Setting this property sets `footerAttributedText` to nil.
@property (nonatomic, copy, nullable) NSString  *footerText;

/// Attributed text to be displayed in the section‘s footer. Setting this property set `footerText` to nil.
@property (nonatomic, copy, nullable) NSAttributedString  *footerAttributedText;

@property (nonatomic, readonly, nonnull) NSArray<RSFormItem *> *formItems;

- (nonnull instancetype)initWithValidatables:(nonnull NSArray<NSObject<RSValidatable> *> *)validatables UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithTitle:(nullable NSString *)title formItems:(nonnull NSArray<RSFormItem *> *)formItems NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithTitle:(nullable NSString *)title formItem:(nonnull RSFormItem *)formItem;
- (nonnull instancetype)initWithTitle:(nullable NSString *)title;

@end
