//
//  RSSwitchTableViewCell.h
//  Object Editor
//
//  Created by Todd Reed on 2019-04-17.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../PropertyEditors/RSFormItem.h"
#import "RSBaseTableViewCell.h"


@interface RSSwitchTableViewCell : RSBaseTableViewCell <RSFormItemView>

@property (nonatomic, strong, readonly, nonnull) UISwitch *toggle;

@end
