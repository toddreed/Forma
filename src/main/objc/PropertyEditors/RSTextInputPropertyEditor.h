//
// RSTextInputPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyEditor.h"
#import "../Core/RSAutocompleteSource.h"

extern NSString *_Nonnull const RSTextInputPropertyValidationErrorDomain;

typedef enum RSTextInputPropertyEditorStyle
{
    /// This emulates the style typically found in the Settings app where there’s a title on
    /// left and a text field on the right. This is the default style.
    RSTextInputPropertyEditorStyleSettings,
    
    /// This style has no label, and the text field occupies the entire table cell content.
    /// The text field’s placeholder is set.
    RSTextInputPropertyEditorStyleForm
} RSTextInputPropertyEditorStyle;

@interface RSTextInputPropertyEditor : RSPropertyEditor <UITextInputTraits>

/// Designated initializer.
///
/// @param formatter The formatter to convert between the text strings and property values. If this
///   is nil, it is assumed that no conversion is needed (i.e. the property is a NSString).
- (nonnull instancetype)initWithKey:(nonnull NSString *)key title:(nonnull NSString *)title style:(RSTextInputPropertyEditorStyle)style formatter:(nullable NSFormatter *)formatter NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)initWithKey:(nonnull NSString *)key title:(nonnull NSString *)title style:(RSTextInputPropertyEditorStyle)style;

@property (nonatomic, readonly, nullable) NSFormatter *formatter;
@property (nonatomic, readonly) RSTextInputPropertyEditorStyle style;
@property (nonatomic) UITextFieldViewMode clearButtonMode;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) BOOL clearsOnBeginEditing;
@property (nonatomic, copy, nullable) NSString *placeholder;
@property (nonatomic, copy, nullable) NSString *message;

@property (nonatomic, strong, nullable) id<RSAutocompleteSource> autocompleteSource;

- (nullable NSString *)validateTextInput:(nonnull NSString *)textInput error:(NSError *_Nonnull *_Nonnull)error;

@end
