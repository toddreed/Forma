//
//  QDetailPropertyEditor.m
//  WordHunt
//
//  Created by Todd Reed on 11-01-20.
//  Copyright 2011 Reaction Software Inc. All rights reserved.
//

#import "QDetailPropertyEditor.h"
#import "NSObject+QEditor.h"
#import "NSObject+QExtension.h"


@implementation QDetailPropertyEditor

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle
{
    [self Q_invalidInitInvoked];
    return nil;
}

- (id)initWithTitle:(NSString *)aTitle object:(NSObject *)aObject
{
    if ((self = [super initWithKey:nil title:aTitle]))
    {
        editedObject = aObject;
    }
    return self;
}

- (void)configureTableCellForValue:(id)value controller:(QObjectEditorViewController *)controller
{
    [super configureTableCellForValue:editedObject controller:controller];
    tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (BOOL)selectable
{
    return YES;
}

- (void)tableCellSelected:(UITableViewCell *)cell forValue:(id)value controller:(UITableViewController *)controller
{
    UINavigationController *navigationController = controller.navigationController;
    QObjectEditorViewController *objectEditorViewController = [editedObject objectEditorViewController];
    [navigationController pushViewController:objectEditorViewController animated:YES];
}

@end

