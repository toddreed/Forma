//
// Forma
// RSTextInputPropertyEditor.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSPropertyFormItem.h"
#import "../Core/RSAutocompleteSource.h"
#import "../Core/RSValidatable.h"


extern NSString *_Nonnull const RSTextInputPropertyValidationErrorDomain;

typedef NS_ENUM(NSInteger, RSTextInputPropertyEditorStyle)
{
    /// This emulates the style typically found in the Settings app where there’s a title on
    /// left and a text field on the right. This is the default style.
    RSTextInputPropertyEditorStyleSettings,
    
    /// This style has a label above the text field.
    RSTextInputPropertyEditorStyleForm
};

@interface RSTextInputPropertyEditor : RSPropertyFormItem <UITextInputTraits, RSValidatable>

/// Designated initializer.
///
/// @param formatter The formatter to convert between the text strings and property values. If this
///   is nil, it is assumed that no conversion is needed (i.e. the property is a NSString).
- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title style:(RSTextInputPropertyEditorStyle)style formatter:(nullable NSFormatter *)formatter NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)initWithKey:(nonnull NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title style:(RSTextInputPropertyEditorStyle)style;

@property (nonatomic, readonly, nonnull) UITextField *textField;

/// Returns the current (possibly uncommited) text value of the text field.
@property (nonatomic, readonly, nonnull) NSString *currentText;

@property (nonatomic, readonly, nullable) NSFormatter *formatter;
@property (nonatomic, readonly) RSTextInputPropertyEditorStyle style;
@property (nonatomic) UITextFieldViewMode clearButtonMode;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) BOOL clearsOnBeginEditing;

/// If `secureTextEntry` is NO, then this property is ignored. If `conditionalSecureTextEntry`
/// is YES (and `secureTextEntry` is YES), then the text field contains a toggle button to hide
/// or show the content of the text field. The default value of this property is NO.
///
/// Setting this property to YES overrides `clearButtonMode`; `clearButtonMode` will effectively
/// be UITextFieldViewModeNever.
@property (nonatomic, getter=isConditionalSecureTextEntry) BOOL conditionalSecureTextEntry;
@property (nonatomic, copy, nullable) NSString *placeholder;
@property (nonatomic, copy, nullable) NSString *message;

@property (nonatomic, strong, nullable) id<RSAutocompleteSource> autocompleteSource;

@end
