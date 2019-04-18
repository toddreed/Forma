//
//  RSSwitchTableViewCell.h
//  Object Editor
//
//  Created by Todd Reed on 2019-04-17.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../PropertyEditors/RSPropertyEditor.h"


@interface RSSwitchTableViewCell : UITableViewCell <RSPropertyEditorView>

@property (nonatomic, strong, readonly, nonnull) UILabel *helpLabel;
@property (nonatomic, strong, readonly, nonnull) UISwitch *toggle;

@end
