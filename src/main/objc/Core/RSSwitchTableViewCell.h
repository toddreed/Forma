//
// Forma
// RSSwitchTableViewCell.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>

#import "../FormItems/RSFormItem.h"
#import "RSBaseTableViewCell.h"


@interface RSSwitchTableViewCell : RSBaseTableViewCell <RSFormItemView>

@property (nonatomic, strong, readonly, nonnull) UISwitch *toggle;

@end
