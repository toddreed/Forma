//
//  QManagedObjectToOneRelationshipViewController.h
//  Pack
//
//  Created by Todd Reed on 2012-11-24.
//  Copyright (c) 2012 Reaction Software Inc. All rights reserved.
//

#import "QCoreDataTableViewController.h"
#import "QObjectEditorViewController.h"

@interface QManagedObjectToOneRelationshipViewController : QCoreDataTableViewController <QObjectEditorViewControllerDelegate>

- (id)initWithTitle:(NSString *)aTitle object:(NSManagedObject *)object relationshipName:(NSString *)relationshipName;

@end
