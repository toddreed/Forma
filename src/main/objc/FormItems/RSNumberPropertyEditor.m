//
// Forma
// RSNumberPropertyEditor.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSNumberPropertyEditor.h"

@implementation RSNumberPropertyEditor

#pragma mark - RSTextInputPropertyEditor

- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title style:(RSTextInputPropertyEditorStyle)style
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [self initWithKey:key ofObject:object title:title style:style formatter:formatter];
}

- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title style:(RSTextInputPropertyEditorStyle)style formatter:(nullable NSFormatter *)formatter
{
    NSParameterAssert([formatter isKindOfClass:[NSNumberFormatter class]]);

    self = [super initWithKey:key ofObject:object title:title style:style formatter:formatter];

    NSNumberFormatter *numberFormatter = (NSNumberFormatter *)formatter;
    self.keyboardType = numberFormatter.allowsFloats ? UIKeyboardTypeDecimalPad : UIKeyboardTypeNumberPad;

    return self;
}

@end
