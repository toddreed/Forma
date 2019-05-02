//
// RSFormSection.h
//
// © Reaction Software Inc., 2013
//


#import <Foundation/Foundation.h>

@class RSFormItem;

@interface RSFormSection : NSObject

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString  *footer;
@property (nonatomic, readonly, nonnull) NSArray<RSFormItem *> *formItems;

- (nonnull instancetype)initWithTitle:(nullable NSString *)title formItemArray:(nonnull NSArray<RSFormItem *> *)formItems NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithTitle:(nullable NSString *)title formItems:(nonnull RSFormItem *)firstFormItem, ... NS_REQUIRES_NIL_TERMINATION;
- (nonnull instancetype)initWithTitle:(nullable NSString *)title formItem:(nonnull RSFormItem *)formItem;
- (nonnull instancetype)initWithTitle:(nullable NSString *)title;

@end
