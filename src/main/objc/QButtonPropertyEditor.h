//
//  QButtonPropertyEditor.h
//  WordHunt
//
//  Created by Todd Reed on 11-01-20.
//  Copyright 2011 Reaction Software Inc. All rights reserved.
//

#import "QPropertyEditor.h"


/// QButtonPropertyEditor is pseudo property editor that behaves like a button. When selected, an
/// action is sent to the controller class. This imposes the requirement that
/// QObjectEditorViewController must be subclassed so the appropriate method can be implemented.
/// 
/// Enhancement #120: Add target property to QButtonPropertyEditor
@interface QButtonPropertyEditor : QPropertyEditor
{
    void (^action)(QObjectEditorViewController *);
}

@property (nonatomic, strong) void (^action)(QObjectEditorViewController *);

- (id)initWithTitle:(NSString *)aTitle action:(void (^)(QObjectEditorViewController *))aAction;

@end
