//
// Forma
// RSLabelTableViewCell.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>

#import "../Core/RSFormItemView.h"


/// RSLabelTableViewCell is a table view cell with a (multiline) title label on left side and a
/// single line value label on the right side. It’s intend to display a readonly property value
/// that can be represented by text.
@interface RSLabelTableViewCell : UITableViewCell <RSFormItemView>

@property (nonatomic, strong, readonly, nonnull) UILabel *valueLabel;

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder NS_DESIGNATED_INITIALIZER;

@end

