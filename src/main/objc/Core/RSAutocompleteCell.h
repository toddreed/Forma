//
// RSAutocompleteCell.h
//
// © Reaction Software Inc., 2013
//

#import <UIKit/UIKit.h>

@interface RSAutocompleteCell : UICollectionViewCell

+ (CGSize)preferredSizeForString:(nonnull NSString *)string;
+ (nonnull UIFont *)font;

@property (nonatomic, strong, nonnull) UILabel *textLabel;

@end
