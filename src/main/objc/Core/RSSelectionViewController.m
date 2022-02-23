//
// Forma
// RSSelectionViewController.m
//
// © Reaction Software Inc. and Todd Reed, 2022
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSSelectionViewController.h"
#import "RSSelectionSectionHeaderView.h"


@interface RSOptionTableViewCell: UITableViewCell

@end


@implementation RSOptionTableViewCell

#pragma mark - RSOptionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

@end


@interface RSSelectionViewController ()

@end


static NSString *const kOptionTableViewCellIdentifier = @"Option";
static NSString *const kSelectionSectionHeaderViewCellIdentifier = @"Header";

@implementation RSSelectionViewController
{
    RSSelection *_selection;
    NSUInteger _selectedIndex;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView *tableView = self.tableView;
    [tableView registerClass:[RSOptionTableViewCell class] forCellReuseIdentifier:kOptionTableViewCellIdentifier];
    [tableView registerClass:[RSSelectionSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kSelectionSectionHeaderViewCellIdentifier];
}

#pragma mark - UITableViewController

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selection.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOptionTableViewCellIdentifier forIndexPath:indexPath];
    NSUInteger index = indexPath.row;

    UIListContentConfiguration *content = [cell defaultContentConfiguration];
    content.text = [_selection labelForIndex:index];
    cell.contentConfiguration = content;

    if (index == _selectedIndex)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RSSelectionSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSelectionSectionHeaderViewCellIdentifier];
    header.label.text = _selection.expanatoryDescription;
    if (_selection.image == nil)
        header.imageView.hidden = YES;
    else
    {
        header.imageView.hidden = NO;
        header.imageView.image = _selection.image;
    }
    return header;
}

/*
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSOptionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell != nil)
        cell.accessoryType = UITableViewCellAccessoryNone;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSOptionTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];

    if (cell != nil)
        cell.accessoryType = UITableViewCellAccessoryNone;

    _selectedIndex = indexPath.row;

    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell != nil)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [_delegate selectionViewController:self didSelectOptionAtIndex:_selectedIndex];
}

#pragma mark - RSSelectionViewController

- (nonnull instancetype)initWithSelection:(nonnull RSSelection *)selection selectedIndex:(NSUInteger)index
{
    self = [super initWithStyle:UITableViewStyleInsetGrouped];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    _selection = selection;
    _selectedIndex = index;
    return self;
}

@end
