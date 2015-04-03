//
// RSPropertyGroup.h
//
// © Reaction Software Inc., 2013
//


#import <Foundation/Foundation.h>

@class RSPropertyEditor;

@interface RSPropertyGroup : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString  *footer;
@property (nonatomic, readonly) NSArray *propertyEditors;

/// Designate initializer
- (id)initWithTitle:(NSString *)title propertyEditorArray:(NSArray *)somePropertyEditors;
- (id)initWithTitle:(NSString *)title propertyEditors:(RSPropertyEditor *)firstPropertyEditor, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithTitle:(NSString *)title propertyEditor:(RSPropertyEditor *)propertyEditor;
- (id)initWithTitle:(NSString *)title;

@end
