//
// Forma
// RSEnumPropertyEditor.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSEnumPropertyEditor.h"
#import "../TableViewCells/RSSegmentedControlTableViewCell.h"


@implementation RSEnumPropertyEditor
{
    RSEnumDescriptor *_enumDescriptor;
}

#pragma mark RSFormItem

- (nonnull __kindof UITableViewCell<RSFormItemView> *)newTableViewCell
{
    return [[self class] instantiateTableViewCellFromNibOfClass:[RSSegmentedControlTableViewCell class]];
}

- (void)configureTableViewCell
{
    RSSegmentedControlTableViewCell *cell = self.tableViewCell;
    UISegmentedControl *segmentedControl = cell.segmentedControl;

    [segmentedControl removeAllSegments];

    NSInteger index = 0;
    for (NSString *label in _enumDescriptor.labels)
    {
        [segmentedControl insertSegmentWithTitle:label atIndex:index animated:NO];
        ++index;
    }

    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];

    [super configureTableViewCell];
}

#pragma mark - RSPropertyFormItem

- (void)propertyChangedToValue:(nullable id)newValue
{
    RSSegmentedControlTableViewCell *cell = self.tableViewCell;
    UISegmentedControl *segmentedControl = cell.segmentedControl;

    NSInteger value = [newValue integerValue];
    NSInteger index = [_enumDescriptor indexOfValue:value];
    segmentedControl.selectedSegmentIndex = index;
}

#pragma mark - RSEnumPropertyEditor

- (nonnull instancetype)initWithKey:(nonnull NSString *)key
      ofObject:(nonnull id)object
         title:(nonnull NSString *)title
enumDescriptor:(nonnull RSEnumDescriptor *)enumDescriptor
{
    self = [super initWithKey:key ofObject:object title:title];
    _enumDescriptor = enumDescriptor;
    return self;
}

- (void)segmentedControlChangedValue:(nonnull UISegmentedControl *)segmentedControl
{
    // If there's no selected segment, there's really nothing to update.
    if (segmentedControl.selectedSegmentIndex != UISegmentedControlNoSegment)
    {
        NSInteger value = [_enumDescriptor valueForIndex:segmentedControl.selectedSegmentIndex];
        [self.object setValue:@(value) forKey:self.key];
    }
}

@end
