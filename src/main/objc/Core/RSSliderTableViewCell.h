//
// RSSliderTableViewCell.h
//
// © Reaction Software Inc., 2013
//


#import <UIKit/UIKit.h>

#import "../PropertyEditors/RSPropertyEditor.h"


@interface RSSliderTableViewCell : UITableViewCell <RSPropertyEditorView>

@property (nonatomic, strong, readonly, nonnull) UISlider *slider;

@end
