//
// Forma
// RSPropertyViewer.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "../FormItems/RSPropertyFormItem.h"


/// RSPropertyViewer is a read-only property form item: it displays the value of a property
/// as text, but provides no UI for altering the property value.
@interface RSPropertyViewer : RSPropertyFormItem

/// The formatter used to format the property value. If the property value is not a string, a
/// formatter MUST be provided.
@property (nonatomic, readonly, nullable) NSFormatter *formatter;

/// Initializes the receiver with a formatter.
///
/// @param formatter The formatter to convert between the text strings and property values. If this
///   is nil, it is assumed that no conversion is needed (i.e. the property is a NSString).
- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title formatter:(nullable NSFormatter *)formatter NS_DESIGNATED_INITIALIZER;

@end
