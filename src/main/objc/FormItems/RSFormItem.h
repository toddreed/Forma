//
//  RSFormItem.h
//  Object Editor
//
//  Created by Todd Reed on 2019-05-01.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "../Core/RSFormItemView.h"


@class RSObjectEditorViewController;


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

/// The UI title displayed in the editor.
@property (nonatomic, copy, nonnull) NSString *title;

/// The table view cell containing the UI for editing the property value. RSPropertyEditors
/// don’t reuse UITableViewCells as is otherwise common with UITableView programming. There are
/// practical and technical reasons for this: because KVO is used, it’s easier to keep a unique
/// table cell for for each property so a KVO change notification can update the UI. The table
/// cell is lazily created. Subclasses should not override this property, and instead override
/// `-newTableViewCell`.
@property (nonatomic, readonly, nonnull) __kindof UITableViewCell<RSFormItemView> *tableViewCell;

/// Returns YES if this property editor can become the first responder. The default is NO. If this
/// property returns YES, then RSObjectEditorViewController may call -becomeFirstResponder.
@property (nonatomic, readonly) BOOL canBecomeFirstResponder;

/// Returns YES if this property editor is selectable. If NO is returned,
/// -controllerDidSelectFormItem: will not be invoked. The default value is NO.
@property (nonatomic, readonly) BOOL selectable;

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithTitle:(nonnull NSString *)title NS_DESIGNATED_INITIALIZER;

/// A helper function for instantiating a table view cell from a nib file.
///
/// This method only works for table view cells that are part of the Object Editor library as
/// the nib file is loaded from the Object Editor’s resource bundle.
+ (nonnull __kindof UITableViewCell<RSFormItemView> *)instantiateTableViewCellFromNibOfClass:(nonnull Class)cls;

/// This is a helper factory function used to create a new UITableViewCell when needed. This is
/// invoked the first time the `tableViewCell` property is accessed.
- (nonnull __kindof UITableViewCell<RSFormItemView> *)newTableViewCell;

/// This method is invoked by RSObjectEditorViewController (from it’s
/// -tableView:cellForRowAtIndexPath: method) and should not be called directly. This method
/// should not be subclassed.
- (nonnull __kindof UITableViewCell<RSFormItemView> *)tableViewCellForController:(nonnull RSObjectEditorViewController *)controller;

/// This method is invoked by RSObjectEditorViewController (from it’s
/// -tableView:cellForRowAtIndexPath: method) and should not be called directly. Subclasses
/// should override this method to perform any required table view cell configuration.
- (void)configureTableViewCellForController:(nonnull RSObjectEditorViewController *)controller;

/// This is invoked by RSObjectEditorViewController when the UITableCellView for the receiver is
/// selected. This is used when implementing a hierarchical editor when the user can drill-down into
/// a sub-editor.
- (void)controllerDidSelectFormItem:(nonnull RSObjectEditorViewController *)controller;

/// Makes the receiver the first responder. (The actual first responder will likely be a view
/// managed by the editor.)
- (void)becomeFirstResponder;

@end
