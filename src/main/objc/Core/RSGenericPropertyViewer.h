//
//  RSGenericPropertyViewer.h
//  Object Editor
//
//  Created by Todd Reed on 2019-04-22.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import "../PropertyEditors/RSPropertyEditor.h"


/// RSGenericPropertyViewer is a read-only property editor: it displays the value of a property
/// as text, but provides no UI for altering the property value.
@interface RSGenericPropertyViewer : RSPropertyEditor

/// The formatter used to format the property value. If the property value is not a string, a
/// formatter MUST be provided.
@property (nonatomic, readonly, nullable) NSFormatter *formatter;

/// Initializes the receiver with a formatter.
///
/// @param formatter The formatter to convert between the text strings and property values. If this
///   is nil, it is assumed that no conversion is needed (i.e. the property is a NSString).
- (nonnull instancetype)initWithKey:(nonnull NSString *)key title:(nonnull NSString *)title formatter:(nullable NSFormatter *)formatter NS_DESIGNATED_INITIALIZER;

@end