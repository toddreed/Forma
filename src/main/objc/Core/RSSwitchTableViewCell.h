//
//  RSSwitchTableViewCell.h
//  Object Editor
//
//  Created by Todd Reed on 2019-04-17.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../PropertyEditors/RSPropertyEditor.h"
#import "RSBaseTableViewCell.h"


@interface RSSwitchTableViewCell : RSBaseTableViewCell <RSPropertyEditorView>

@property (nonatomic, strong, readonly, nonnull) UISwitch *toggle;

@end
