//
//  QBooleanPropertyEditor.m
//  WordHunt
//
//  Created by Todd Reed on 11-01-20.
//  Copyright 2011 Reaction Software Inc. All rights reserved.
//

#import "QBooleanPropertyEditor.h"
#import "QObjectEditorViewController.h"


@interface QObjectEditorViewController (QBooleanPropertyEditor)

- (void)switchChangedValue:(id)sender;

@end


@implementation QObjectEditorViewController (QBooleanPropertyEditor)

- (void)switchChangedValue:(id)sender
{
    UISwitch *toggle = (UISwitch *)sender;
    QPropertyEditor *editor = [propertyEditorDictionary objectForKey:@(toggle.tag)];
    [editedObject setValue:@(toggle.on) forKey:editor.key];
}

@end


@implementation QBooleanPropertyEditor

#pragma mark QPropertyEditor

- (void)propertyChangedToValue:(id)newValue
{
    UISwitch *toggle = (UISwitch *)tableViewCell.accessoryView;
    [toggle setOn:[newValue boolValue] animated:YES];
}

- (UITableViewCell *)newTableViewCell
{
    UITableViewCell *cell = [super newTableViewCell];
    UISwitch *toggle = [[UISwitch alloc] init];
    cell.accessoryView = toggle;
    return cell;
}

- (void)configureTableCellForValue:(id)value controller:(QObjectEditorViewController *)controller
{
    [super configureTableCellForValue:value controller:controller];
    
    UISwitch *toggle = (UISwitch *)tableViewCell.accessoryView;
    
    [toggle addTarget:controller action:@selector(switchChangedValue:) forControlEvents:UIControlEventValueChanged];
    toggle.tag = tag;
    toggle.on = [value boolValue];
}

@end
