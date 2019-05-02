//
// RSFormButton.h
//
// © Reaction Software Inc., 2013
//


#import "RSFormItem.h"


/// RSFormButton representes a button that is be rendered in a table view cell.
@interface RSFormButton : RSFormItem

@property (nonatomic, strong, nullable) void (^action)(UIViewController<RSFormContainer> *_Nonnull);

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithTitle:(nonnull NSString *)title action:(void (^_Nullable)(UIViewController<RSFormContainer> *_Nonnull))action NS_DESIGNATED_INITIALIZER;

@end
