//
//  QStringPropertyEditor.h
//  WordHunt
//
//  Created by Todd Reed on 11-01-20.
//  Copyright 2011 Reaction Software Inc. All rights reserved.
//

#import "QPropertyEditor.h"

typedef enum QStringPropertyEditorStyle
{
    /// This emulates the style typically found in the Settings app where there's a title on
    /// left and a text field on the right. This is the default style.
    QStringPropertyEditorStyleSettings,
    
    /// This style has no label, and the text field occupies the entire table cell content. The
    /// text field's placeholder is set.
    QStringPropertyEditorStyleForm
} QStringPropertyEditorStyle;

@interface QStringPropertyEditor : QPropertyEditor <UITextInputTraits>
{
    QStringPropertyEditorStyle style;
    
    UITextAutocapitalizationType autocapitalizationType;
    UITextAutocorrectionType autocorrectionType;
    BOOL enablesReturnKeyAutomatically;
    UIKeyboardAppearance keyboardAppearance;
    UIKeyboardType keyboardType;
    UIReturnKeyType returnKeyType;
    BOOL secureTextEntry;
    
    // Properties from UITextFieldView
    UITextFieldViewMode clearButtonMode;
    NSTextAlignment textAlignment;
    BOOL clearsOnBeginEditing;
    NSString *placeholder;
    
    // An optional extra string used to display instructions or validation error messages.
    NSString *message;
}

/// Designated initializer.
- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle style:(QStringPropertyEditorStyle)aStyle;

@property (nonatomic) QStringPropertyEditorStyle style;
@property (nonatomic) UITextFieldViewMode clearButtonMode;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) BOOL clearsOnBeginEditing;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *message;

@end
