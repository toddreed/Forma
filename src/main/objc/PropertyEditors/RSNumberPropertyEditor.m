//
// RSNumberPropertyEditor.m
//
// © Reaction Software Inc., 2013
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
