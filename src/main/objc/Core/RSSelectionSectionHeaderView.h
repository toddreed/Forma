//
// Forma
// RSSelectionSectionHeaderView.h
//
// © Reaction Software Inc. and Todd Reed, 2022
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>


/// RSSelectionSectionHeaderView is table section header view used by RSSelectionViewController.
@interface RSSelectionSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, readonly, nonnull) UILabel *label;
@property (nonatomic, readonly, nonnull) UIImageView *imageView;

@end
