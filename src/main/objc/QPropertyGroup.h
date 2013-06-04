//
// QPropertyGroup.h
//
// © Reaction Software Inc., 2013
//


#import <Foundation/Foundation.h>

@class QPropertyEditor;

@interface QPropertyGroup : NSObject
{
    NSString *title;
    NSString *footer;
    NSMutableArray *propertyEditors;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString  *footer;
@property (nonatomic, readonly) NSArray *propertyEditors;

/// Designate initializer
- (id)initWithTitle:(NSString *)aTitle propertyEditorArray:(NSArray *)somePropertyEditors;
- (id)initWithTitle:(NSString *)aTitle propertyEditors:(QPropertyEditor *)firstPropertyEditor, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithTitle:(NSString *)aTitle propertyEditor:(QPropertyEditor *)propertyEditor;
- (id)initWithTitle:(NSString *)aTitle;

@end
