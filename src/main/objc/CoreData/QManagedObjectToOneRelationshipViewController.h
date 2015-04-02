//
// QManagedObjectToOneRelationshipViewController.h
//
// © Reaction Software Inc., 2013
//


#import "QCoreDataTableViewController.h"
#import "QObjectEditorViewController.h"

@interface QManagedObjectToOneRelationshipViewController : QCoreDataTableViewController <QObjectEditorViewControllerDelegate>

- (id)initWithTitle:(NSString *)aTitle object:(NSManagedObject *)object relationshipName:(NSString *)relationshipName;

@end
