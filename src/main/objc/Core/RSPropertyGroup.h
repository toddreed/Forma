//
// RSPropertyGroup.h
//
// © Reaction Software Inc., 2013
//


#import <Foundation/Foundation.h>

@class RSPropertyEditor;

@interface RSPropertyGroup : NSObject

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString  *footer;
@property (nonatomic, readonly, nonnull) NSArray<RSPropertyEditor *> *propertyEditors;

- (nonnull instancetype)initWithTitle:(nullable NSString *)title propertyEditorArray:(nonnull NSArray<RSPropertyEditor *> *)somePropertyEditors NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithTitle:(nullable NSString *)title propertyEditors:(nonnull RSPropertyEditor *)firstPropertyEditor, ... NS_REQUIRES_NIL_TERMINATION;
- (nonnull instancetype)initWithTitle:(nullable NSString *)title propertyEditor:(nonnull RSPropertyEditor *)propertyEditor;
- (nonnull instancetype)initWithTitle:(nullable NSString *)title;

@end
