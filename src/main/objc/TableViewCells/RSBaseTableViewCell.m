//
// Forma
// RSBaseTableViewCell.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSBaseTableViewCell.h"


@interface RSBaseTableViewCell ()

@property (nonatomic, strong, nonnull) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation RSBaseTableViewCell

#pragma mark - NSObject

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIView *contentView = self.contentView;

    CGFloat minimumHeight = [self class].minimumHeight;
    _heightConstraint = [contentView.heightAnchor constraintGreaterThanOrEqualToConstant:minimumHeight];

    // We add a height constraint to reproduce a default behaviour in iOS: the height of
    // table view cells, regardless of the user’s selected type, is never smaller than 44pts.
    // This height constrain reproduces this behaviour, and almost exactly reproduces the
    // height of basic table view cells at other font sizes.

    // We need to set the priority of _heightConstraint to < 1000, otherwise we get this
    // warning below in the console. The warning is nonsensical, because the constrains
    // actually can be simultaneously satisfied. Maybe this is a bug in iOS. This was
    // observed in iOS 12.2.

    /*
     2019-04-19 11:51:16.068344-0600 Demo[31228:3297068] [LayoutConstraints] Unable to simultaneously satisfy constraints.
     Probably at least one of the constraints in the following list is one you don't want.
     Try this:
     (1) look at each constraint and try to figure out which you don't expect;
     (2) find the code that added the unwanted constraint or constraints and fix it.
     (
     "<NSLayoutConstraint:0x6000015086e0 UITableViewCellContentView:0x7ff5dc433300.height >= 48   (active)>",
     "<NSLayoutConstraint:0x600001509130 'UIView-Encapsulated-Layout-Height' UITableViewCellContentView:0x7ff5dc433300.height == 48   (active)>"
     )

     Will attempt to recover by breaking constraint
     <NSLayoutConstraint:0x6000015086e0 UITableViewCellContentView:0x7ff5dc433300.height >= 48   (active)>

     */
    _heightConstraint.priority = UILayoutPriorityDefaultHigh;
    _heightConstraint.active = YES;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(contentSizeCategoryDidChangeNotification:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

+ (CGFloat)minimumHeight
{
    const CGFloat standardHeight = 44;
    CGFloat minimumHeight = ceil(MAX(standardHeight, [UIFontMetrics.defaultMetrics scaledValueForValue:standardHeight]));
    return minimumHeight;
}

- (void)updateHeightConstraint
{
    _heightConstraint.constant = [self class].minimumHeight;
}

- (void)contentSizeCategoryDidChangeNotification:(NSNotification *)notification
{
    [self updateHeightConstraint];
}

@end
