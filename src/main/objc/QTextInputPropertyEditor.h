//
// QTextInputPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import "QPropertyEditor.h"
#import "TRAutocompleteSource.h"

extern NSString *const QTextInputPropertyValidationErrorDomain;

typedef enum QTextInputPropertyEditorStyle
{
    /// This emulates the style typically found in the Settings app where there's a title on
    /// left and a text field on the right. This is the default style.
    QTextInputPropertyEditorStyleSettings,
    
    /// This style has no label, and the text field occupies the entire table cell content. The
    /// text field's placeholder is set.
    QTextInputPropertyEditorStyleForm
} QTextInputPropertyEditorStyle;

@interface QTextInputPropertyEditor : QPropertyEditor <UITextInputTraits>

/// Designated initializer.
///
/// @param formatter The formatter to convert between the text strings and property values. If this
///   is nil, it is assumed that no conversion is needed (i.e. the property is a NSString).
- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle style:(QTextInputPropertyEditorStyle)aStyle formatter:(NSFormatter *)formatter;

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle style:(QTextInputPropertyEditorStyle)aStyle;

@property (nonatomic, readonly) NSFormatter *formatter;
@property (nonatomic) QTextInputPropertyEditorStyle style;
@property (nonatomic) UITextFieldViewMode clearButtonMode;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) BOOL clearsOnBeginEditing;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) id<TRAutocompleteSource> autocompleteSource;

- (id)validateTextInput:(NSString *)textInput error:(NSError **)error;

@end
