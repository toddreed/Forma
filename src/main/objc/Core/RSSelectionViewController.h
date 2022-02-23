//
// Forma
// RSSelectionViewController.h
//
// © Reaction Software Inc. and Todd Reed, 2022
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>

#include "RSSelection.h"


@class RSSelectionViewController;


@protocol RSSelectionViewControllerDelegate <NSObject>

- (void)selectionViewController:(nonnull RSSelectionViewController *)viewController didSelectOptionAtIndex:(NSUInteger)optionIndex;

@end


@interface RSSelectionViewController : UITableViewController

@property (nonatomic, weak, nullable) id<RSSelectionViewControllerDelegate> delegate;

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithCoder:(nonnull NSCoder *)coder UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithSelection:(nonnull RSSelection *)selection selectedIndex:(NSUInteger)index NS_DESIGNATED_INITIALIZER;

@end

