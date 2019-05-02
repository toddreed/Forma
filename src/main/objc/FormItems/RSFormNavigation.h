//
// RSFormNavigation.h
//
// © Reaction Software Inc., 2013
//


#import "RSFormItem.h"

// TODO: review comment A RSFormNavigation is form edit that navigates to form for another
// ancillary object. This must only be used with a RSObjectEditorViewController that is on the
// stack of a UINavigationController. The UI for a RSFormNavigation displays a title and a
// summary of the object’s value obtained with -descriptionWithLocale:, or if this method is not
// defined, -description.
@interface RSFormNavigation : RSFormItem

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithTitle:(nonnull NSString *)title object:(nonnull NSObject *)object NS_DESIGNATED_INITIALIZER;

@end
