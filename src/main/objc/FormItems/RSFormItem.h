//
// Forma
// RSFormItem.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "../Core/RSFormItemView.h"
#import "../Core/RSFormContainer.h"


@class RSFormSection;


/// RSFormItem is the base class for all form items. There are three main types of form items:
///
/// - Property form items (of which there are "viewers" and "editors")
/// - Buttons
/// - Navigation items
///
/// @see RSPropertyFormItem
/// @see RSFormButton
/// @see RSNavigationItem
@interface RSFormItem : NSObject

/// The form section this item belongs to.
@property (nonatomic, weak, readonly, nullable) RSFormSection *formSection;

/// The UI title displayed in the editor.
@property (nonatomic, copy, readonly, nonnull) NSString *title;

/// The table view cell containing the UI for editing the property value. RSPropertyEditors
/// don’t reuse UITableViewCells as is otherwise common with UITableView programming. There are
/// practical and technical reasons for this: because KVO is used, it’s easier to keep a unique
/// table cell for for each property so a KVO change notification can update the UI. The table
/// cell is lazily created. Subclasses should not override this property, and instead override
/// `-newTableViewCell`.
@property (nonatomic, readonly, nonnull) __kindof UITableViewCell<RSFormItemView> *tableViewCell;

/// Returns YES if this property editor can become the first responder. The default is NO. If
/// this property returns YES, then the form container may call -becomeFirstResponder.
@property (nonatomic, readonly) BOOL canBecomeFirstResponder;

/// Returns YES if this property editor is selectable. If NO is returned,
/// -controllerDidSelectFormItem: will not be invoked. The default value is NO.
@property (nonatomic, readonly) BOOL selectable;

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithTitle:(nonnull NSString *)title NS_DESIGNATED_INITIALIZER;

/// A helper function for instantiating a table view cell from a nib file.
///
/// This method only works for table view cells that are part of the Forma library as the nib
/// file is loaded from the Forma’s resource bundle.
+ (nonnull __kindof UITableViewCell<RSFormItemView> *)instantiateTableViewCellFromNibOfClass:(nonnull Class)cls;

/// This is a helper factory function used to create a new UITableViewCell when needed. This is
/// invoked the first time the `tableViewCell` property is accessed.
- (nonnull __kindof UITableViewCell<RSFormItemView> *)newTableViewCell;

/// This method is invoked by the form container (from it’s -tableView:cellForRowAtIndexPath:
/// method) and should not be called directly. Subclasses should override this method to perform
/// any required table view cell configuration.
- (void)configureTableViewCell;

/// This is invoked by form container when the UITableCellView for the receiver is selected.
/// This is used when implementing a hierarchical editor when the user can drill-down into a
/// sub-editor.
- (void)controllerDidSelectFormItem:(nonnull UIViewController<RSFormContainer> *)controller;

/// Makes the receiver the first responder. (The actual first responder will likely be a view
/// managed by the editor.)
- (void)becomeFirstResponder;

@end
