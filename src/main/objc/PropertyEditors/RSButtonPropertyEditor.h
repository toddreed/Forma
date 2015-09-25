//
// RSButtonPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyEditor.h"


/// RSButtonPropertyEditor is pseudo property editor that behaves like a button. When selected, a block
/// is executed.
@interface RSButtonPropertyEditor : RSPropertyEditor

@property (nonatomic, strong, nullable) void (^action)(RSObjectEditorViewController *_Nonnull);

- (nonnull instancetype)initWithKey:(nullable NSString *)aKey title:(nonnull NSString *)aTitle UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithTitle:(nonnull NSString *)aTitle action:(void (^_Nullable)(RSObjectEditorViewController *_Nonnull))aAction NS_DESIGNATED_INITIALIZER;

@end
