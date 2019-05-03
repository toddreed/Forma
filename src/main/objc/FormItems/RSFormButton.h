//
// Forma
// RSFormButton.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSFormItem.h"


/// RSFormButton representes a button that is be rendered in a table view cell.
@interface RSFormButton : RSFormItem

@property (nonatomic, strong, nullable) void (^action)(UIViewController<RSFormContainer> *_Nonnull);

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithTitle:(nonnull NSString *)title action:(void (^_Nullable)(UIViewController<RSFormContainer> *_Nonnull))action NS_DESIGNATED_INITIALIZER;

@end
