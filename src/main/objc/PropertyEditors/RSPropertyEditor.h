//
// RSPropertyEditor.h
//
// © Reaction Software Inc., 2013
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/// The RSPropertyEditor class is part of a framework for building a user interface for editing
/// model objects. RSPropertyEditor is an abstract base class; there are concrete subclasses of
/// RSPropertyEditor that provide support for editing specific types of properties. For example,
/// RSTextInputPropertyEditor provides support for editing NSString properties. RSProperityEditor
/// instances are used by the RSObjectEditorViewController class to build the user interface for
/// editing many properties of an object.
/// 
/// RSPropertyEditor uses key-value observing to keep the UI synchronized with changes to the model
/// object. If the model's properties are modified via its accessors and the model's class is KVO
/// compliant, the UI will automatically update to reflect the changed property value.
/// 
/// Similarly, RSPropertyEditor uses key-value coding to automatically update a model's property
/// value that is changed from a UI control. (This is actually implemented by a category extension
/// to RSEditorObjectViewController.)
@class RSObjectEditorViewController;


@interface RSPropertyEditor : NSObject

/// The object this editor modifies.
@property (nonatomic, weak, readonly) id target;

/// The key use to update the model object with KVC. This is always non-nil for "normal"
/// property editors, but some special "pseudo" property editors have a nil key;
/// RSDetailPropertyEditor and RSButtonPropertyEditor are examples.
@property (nonatomic, readonly) NSString *key;

/// The UI title displayed in the editor.
@property (nonatomic, copy) NSString *title;

/// This is used by RSObjectEditorViewController to associate view controls with this
/// instance. It is managed by RSObjectEditorViewController.
@property (nonatomic) NSInteger tag;

/// Tracks whether this property editor is currently observing the edited object's key
/// property.
@property (nonatomic, readonly) BOOL observing;

/// The table view cell containing the UI for editing the property value. RSPropertyEditors
/// don't reuse UITableViewCells as is otherwise common with UITableView programming. There
/// are practical and technical reasons for this: because KVO is used, it's easier to keep a
/// unique table cell for for each property so a KVO change notification can update the
/// UI. The table cell is lazily created, and released when no longer observing a property.
@property (nonatomic, readonly) UITableViewCell *tableViewCell;

/// Returns YES if this property editor is selectable. If NO is returned,
/// -tableCellSelected:forValue:controller: will not be invoked. The default value is NO.
@property (nonatomic, readonly) BOOL selectable;

/// Designated initializer.
- (id)initWithKey:(NSString *)key title:(NSString *)title;

/// Do not call this directly. This is called by RSObjectEditorViewController when it creates a UI
/// for this property editor. This enables key-value observing on the property, allowing the
/// receiver to automatically update the UI if the model object changes. If you override this, you
/// must call super.
- (void)startObserving:(NSObject *)editedObject;

/// Do not call this directly. This is called by RSObjectEditorViewController when there's no longer
/// a UI for this property editor. This disables key-value observing on the property and releases
/// the table view cell. If you override this, you must call super.
- (void)stopObserving:(NSObject *)editedObject;

/// This method must be overridden by subclasses to update their UI to reflect a change in the
/// observed property's value.
- (void)propertyChangedToValue:(id)newValue;

/// Do not call this directly. This is invoked by RSObjectEditorViewController to obtain a
/// UITableCellView for this editor. This method is not normally overridden; override
/// -newTableCellView and/or -configureTableCellForValue:controller: instead.
- (UITableViewCell *)tableCellForValue:(id)value controller:(RSObjectEditorViewController *)controller;

/// This is a helper factory function used by -tableCellForValue:controller: to create a new
/// UITableViewCell when needed.
- (UITableViewCell *)newTableViewCell;

/// This is a helper function used by -tableCellForValue:controller: to configure a new
/// UITableCellView. Subclasses that override -tableCellForValue:controller: may want to call super.
- (void)configureTableCellForValue:(id)value controller:(RSObjectEditorViewController *)controller;

/// This is invoked by RSObjectEditorViewController when the UITableCellView for the receiver is
/// selected. This is used when implementing a hierarchical editor when the user can drill-down into
/// a sub-editor.
- (void)tableCellSelected:(UITableViewCell *)cell forValue:(id)value controller:(UITableViewController *)controller;

/// Returns the height of the table cell for this editor. This is called by
/// RSObjectEditorViewController's -tableView:heightForRowAtIndexPath:. Returns 44.0f, which is the
/// normal default table cell height.
- (CGFloat)tableCellHeightForController:(RSObjectEditorViewController *)controller;

/// Returns YES if thie property editor can become the first responder. The default is NO. If this
/// property returns YES, then RSObjectEditorViewController may call -becomeFirstResponder.
- (BOOL)canBecomeFirstResponder;

/// Makes the receiver the first responder. (The actual first responder will likely be a view
/// managed by the editor.)
- (void)becomeFirstResponder;

@end
