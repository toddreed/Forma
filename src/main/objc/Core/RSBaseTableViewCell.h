//
//  RSBaseTableViewCell.h
//  Forma
//
//  Created by Todd Reed on 2019-04-19.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RSBaseTableViewCell : UITableViewCell

/// Returns the minimum height of cells based on the current Dynamic Type settings.
@property (class, nonatomic, readonly) CGFloat minimumHeight;

@end
