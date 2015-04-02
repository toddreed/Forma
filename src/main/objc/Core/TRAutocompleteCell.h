//
// TRAutocompleteCell.h
//
// © Reaction Software Inc., 2013
//

#import <UIKit/UIKit.h>

@interface TRAutocompleteCell : UICollectionViewCell

+ (CGSize)preferredSizeForString:(NSString *)string;
+ (UIFont *)font;

@property (nonatomic, strong) UILabel *textLabel;

@end
