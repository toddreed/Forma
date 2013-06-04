//
//  QPropertyGroup.h
//  WordHunt
//
//  Created by Todd Reed on 11-01-20.
//  Copyright 2011 Reaction Software Inc. All rights reserved.
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
