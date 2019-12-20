//
// Forma
// RSEnumPropertyEditor.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSPropertyFormItem.h"
#import "../Core/RSEnumDescriptor.h"


@interface RSEnumPropertyEditor : RSPropertyFormItem


- (nonnull instancetype)initWithKey:(nullable NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithKey:(nonnull NSString *)key
                           ofObject:(nonnull id)object
                              title:(nonnull NSString *)title
                     enumDescriptor:(nonnull RSEnumDescriptor *)enumDescriptor NS_DESIGNATED_INITIALIZER;

@end

