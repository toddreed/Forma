//
// RSButtonPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyEditor.h"


/// RSButtonPropertyEditor is pseudo property editor that behaves like a button. When selected, an
/// action is sent to the controller class. This imposes the requirement that
/// RSObjectEditorViewController must be subclassed so the appropriate method can be implemented.
/// 
/// Enhancement #120: Add target property to RSButtonPropertyEditor
@interface RSButtonPropertyEditor : RSPropertyEditor

@property (nonatomic, strong) void (^action)(RSObjectEditorViewController *);

- (id)initWithTitle:(NSString *)aTitle action:(void (^)(RSObjectEditorViewController *))aAction;

@end
