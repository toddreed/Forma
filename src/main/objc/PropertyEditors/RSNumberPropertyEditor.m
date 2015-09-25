//
// RSNumberPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "RSNumberPropertyEditor.h"

@implementation RSNumberPropertyEditor

#pragma mark - RSTextInputPropertyEditor

- (nonnull instancetype)initWithKey:(nonnull NSString *)aKey title:(nonnull NSString *)aTitle style:(RSTextInputPropertyEditorStyle)aStyle
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [self initWithKey:aKey title:aTitle style:aStyle formatter:formatter];
}

- (nonnull instancetype)initWithKey:(nonnull NSString *)aKey title:(nonnull NSString *)aTitle style:(RSTextInputPropertyEditorStyle)aStyle formatter:(nullable NSFormatter *)formatter
{
    NSParameterAssert([formatter isKindOfClass:[NSNumberFormatter class]]);

    self = [super initWithKey:aKey title:aTitle style:aStyle formatter:formatter];

    NSNumberFormatter *numberFormatter = (NSNumberFormatter *)formatter;
    self.keyboardType = [numberFormatter allowsFloats] ? UIKeyboardTypeDecimalPad : UIKeyboardTypeNumberPad;

    return self;
}

@end
