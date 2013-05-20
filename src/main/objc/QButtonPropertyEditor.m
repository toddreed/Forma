//
//  QButtonPropertyEditor.m
//  WordHunt
//
//  Created by Todd Reed on 11-01-20.
//  Copyright 2011 Reaction Software Inc. All rights reserved.
//

#import "QButtonPropertyEditor.h"
#import "NSObject+QExtension.h"


@implementation QButtonPropertyEditor

@synthesize action;

- (id)initWithKey:(NSString *)aKey title:(NSString *)aTitle
{
    [self Q_invalidInitInvoked];
    return nil;
}

- (id)initWithTitle:(NSString *)aTitle action:(void (^)(QObjectEditorViewController *))aAction
{
    if ((self = [super initWithKey:nil title:aTitle]))
    {
        action = aAction;
    }
    return self;
}

- (void)configureTableCellForValue:(id)value controller:(QObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];
    tableViewCell.textLabel.textAlignment =  NSTextAlignmentCenter;
}

- (BOOL)selectable
{
    return action != nil;
}

- (void)tableCellSelected:(UITableViewCell *)cell forValue:(id)value controller:(UITableViewController *)controller
{
    if (action)
        action((QObjectEditorViewController *)controller);
}

@end
