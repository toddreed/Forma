//
//  QRelationshipPropertyEditor.m
//  Pack
//
//  Created by Todd Reed on 2012-11-11.
//  Copyright (c) 2012 Reaction Software Inc. All rights reserved.
//

#import "QRelationshipPropertyEditor.h"
#import "QManagedObjectToOneRelationshipViewController.h"

@implementation QRelationshipPropertyEditor
{
    NSManagedObject *__weak _editedObject;
}

#pragma mark - QPropertyEditor

- (void)propertyChangedToValue:(id)newValue
{
    tableViewCell.detailTextLabel.text = [newValue description];
}

- (void)startObserving:(NSObject *)editedObject
{
    [super startObserving:editedObject];
    _editedObject = (NSManagedObject *)editedObject;
}

- (void)stopObserving:(NSObject *)editedObject
{
    [super stopObserving:editedObject];
    _editedObject = nil;
}

- (void)configureTableCellForValue:(id)value controller:(QObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];
    tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    tableViewCell.detailTextLabel.text = [value description];
}

- (BOOL)selectable
{
    return YES;
}

- (void)tableCellSelected:(UITableViewCell *)cell forValue:(id)value controller:(UITableViewController *)controller
{
    NSAssert(_editedObject != nil, nil);
    
    UINavigationController *navigationController = controller.navigationController;

    QManagedObjectToOneRelationshipViewController *viewController = [[QManagedObjectToOneRelationshipViewController alloc] initWithTitle:title object:_editedObject relationshipName:key];
    viewController.managedObjectContext = [_editedObject managedObjectContext];
    [navigationController pushViewController:viewController animated:YES];
}

@end
