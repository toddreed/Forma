//
// Forma
// RSBaseTableViewCell.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>


@interface RSBaseTableViewCell : UITableViewCell

/// Returns the minimum height of cells based on the current Dynamic Type settings.
@property (class, nonatomic, readonly) CGFloat minimumHeight;

@end
