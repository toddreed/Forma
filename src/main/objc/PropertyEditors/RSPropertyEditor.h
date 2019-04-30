//
// RSPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@class RSObjectEditorViewController;


@protocol RSPropertyEditorView <NSObject>

@property (nonatomic, strong, readonly, nullable) UILabel *titleLabel;

@end


/// The RSPropertyEditor class is part of a framework for building a user interface for editing
/// model objects. RSPropertyEditor is an abstract base class; there are concrete subclasses of
/// RSPropertyEditor that provide support for editing specific types of properties. For example,
/// RSTextInputPropertyEditor provides support for editing NSString properties. RSProperityEditor
/// instances are used by the RSObjectEditorViewController class to build the user interface for
/// editing the properties of an object.
///
/// RSPropertyEditor uses key-value observing to keep the UI synchronized with changes to the model
/// object. If the model’s properties are modified via its accessors and the model’s class is KVO
/// compliant, the UI will automatically update to reflect the changed property value.
///
/// Similarly, RSPropertyEditor uses key-value coding to automatically update a model’s property
/// value that is changed from a UI control. (This is actually implemented by a category extension
/// to RSEditorObjectViewController.)
@interface RSPropertyEditor : NSObject

/// The object this editor modifies.
@property (nonatomic, readonly, nullable) id object;

/// The key use to update the model object with KVC. This is always non-nil for “normal” property
/// editors, but some special “pseudo” property editors have a nil key; RSDetailPropertyEditor and
/// RSButtonPropertyEditor are examples.
@property (nonatomic, readonly, nullable) NSString *key;

/// The UI title displayed in the editor.
@property (nonatomic, copy, nonnull) NSString *title;

/// Tracks whether this property editor is currently observing the edited object’s key property.
@property (nonatomic, readonly) BOOL observing;

/// The table view cell containing the UI for editing the property value. RSPropertyEditors
/// don’t reuse UITableViewCells as is otherwise common with UITableView programming. There are
/// practical and technical reasons for this: because KVO is used, it’s easier to keep a unique
/// table cell for for each property so a KVO change notification can update the UI. The table
/// cell is lazily created. Subclasses should not override this property, and instead override
/// `-newTableViewCell`.
@property (nonatomic, readonly, nonnull) __kindof UITableViewCell<RSPropertyEditorView> *tableViewCell;

/// Returns YES if this property editor is selectable. If NO is returned,
/// -controllerDidSelectEditor: will not be invoked. The default value is NO.
@property (nonatomic, readonly) BOOL selectable;

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithKey:(nullable NSString *)key ofObject:(nullable id)object title:(nonnull NSString *)title NS_DESIGNATED_INITIALIZER;

/// This method must be overridden by subclasses to update their UI to reflect a change in the
/// observed property’s value.
- (void)propertyChangedToValue:(nullable id)newValue;

/// A helper function for instantiating a table view cell from a nib file.
///
/// This method only works for table view cells that are part of the Object Editor library as
/// the nib file is loaded from the Object Editor’s resource bundle.
+ (nonnull __kindof UITableViewCell<RSPropertyEditorView> *)instantiateTableViewCellFromNibOfClass:(nonnull Class)cls;

/// This is a helper factory function used to create a new UITableViewCell when needed. This is
/// invoked the first time the `tableViewCell` property is accessed.
- (nonnull __kindof UITableViewCell<RSPropertyEditorView> *)newTableViewCell;

/// This method is invoked by RSObjectEditorViewController (from it’s
/// -tableView:cellForRowAtIndexPath: method) and should not be called directly. This method
/// should not be subclassed.
- (nonnull __kindof UITableViewCell<RSPropertyEditorView> *)tableViewCellForController:(nonnull RSObjectEditorViewController *)controller;

/// This method is invoked by RSObjectEditorViewController (from it’s
/// -tableView:cellForRowAtIndexPath: method) and should not be called directly. Subclasses
/// should override this method to perform any required table view cell configuration.
- (void)configureTableViewCellForController:(nonnull RSObjectEditorViewController *)controller;

/// This is invoked by RSObjectEditorViewController when the UITableCellView for the receiver is
/// selected. This is used when implementing a hierarchical editor when the user can drill-down into
/// a sub-editor.
- (void)controllerDidSelectEditor:(nonnull RSObjectEditorViewController *)controller;

/// Returns YES if this property editor can become the first responder. The default is NO. If this
/// property returns YES, then RSObjectEditorViewController may call -becomeFirstResponder.
@property (nonatomic, readonly) BOOL canBecomeFirstResponder;

/// Makes the receiver the first responder. (The actual first responder will likely be a view
/// managed by the editor.)
- (void)becomeFirstResponder;

@end
