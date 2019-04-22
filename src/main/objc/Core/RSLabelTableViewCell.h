//
//  RSLabelTableViewCell.h
//  Object Editor
//
//  Created by Todd Reed on 2019-04-17.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../PropertyEditors/RSPropertyEditor.h"


/// RSLabelTableViewCell is a table view cell with a (multiline) title label on left side and a
/// single line value label on the right side. It’s intend to display a readonly property value
/// that can be represented by text.
@interface RSLabelTableViewCell : UITableViewCell <RSPropertyEditorView>

@property (nonatomic, strong, readonly, nonnull) UILabel *valueLabel;

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder NS_DESIGNATED_INITIALIZER;

@end

