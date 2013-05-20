//
//  NSManagedObject+QEditor.h
//  Pack
//
//  Created by Todd Reed on 2012-10-27.
//  Copyright (c) 2012 Reaction Software Inc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "QPropertyEditor.h"

@interface NSManagedObject (QEditor)

- (QPropertyEditor *)propertyEditorForKey:(NSString *)key;
- (NSArray *)propertyGroups;

@end
