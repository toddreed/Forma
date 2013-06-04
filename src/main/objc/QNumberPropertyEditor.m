//
// QNumberPropertyEditor.m
//
// © Reaction Software Inc., 2013
//


#import "QNumberPropertyEditor.h"

@implementation QNumberPropertyEditor

#pragma mark - QTextInputPropertyEditor

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle style:(QTextInputPropertyEditorStyle)aStyle
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [self initWithKey:aKey title:aTitle style:aStyle formatter:formatter];
}

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle style:(QTextInputPropertyEditorStyle)aStyle formatter:(NSFormatter *)formatter
{
    NSParameterAssert([formatter isKindOfClass:[NSNumberFormatter class]]);

    self = [super initWithKey:aKey title:aTitle style:aStyle formatter:formatter];
    if (self)
    {
        NSNumberFormatter *numberFormatter = (NSNumberFormatter *)formatter;
        self.keyboardType = [numberFormatter allowsFloats] ? UIKeyboardTypeDecimalPad : UIKeyboardTypeNumberPad;
    }
    return self;
}

@end
