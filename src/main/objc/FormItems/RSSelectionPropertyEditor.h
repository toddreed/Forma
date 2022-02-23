//
// Forma
// RSSelectionPropertyEditor.h
//
// © Reaction Software Inc. and Todd Reed, 2022
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSPropertyFormItem.h"
#import "../Core/RSSelection.h"


@interface RSSelectionPropertyEditor : RSPropertyFormItem

- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nonnull id)object title:(nonnull NSString *)title UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithKey:(nonnull NSString *)key
                           ofObject:(nonnull id)object
                              title:(nonnull NSString *)title
                          selection:(nonnull RSSelection *)selection NS_DESIGNATED_INITIALIZER;

@end

