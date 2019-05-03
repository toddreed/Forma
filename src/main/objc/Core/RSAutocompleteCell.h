//
// Forma
// RSAutocompleteCell.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>

@interface RSAutocompleteCell : UICollectionViewCell

+ (CGSize)preferredSizeForString:(nonnull NSString *)string;

@property (nonatomic, strong, nonnull) UILabel *textLabel;

@end
