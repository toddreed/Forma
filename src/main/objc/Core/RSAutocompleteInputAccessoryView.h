//
// Forma
// RSAutocompleteInputAccessoryView.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>
#import "RSAutocompleteSource.h"

@interface RSAutocompleteInputAccessoryView : UICollectionView <UIInputViewAudioFeedback>

@property (nonatomic, strong, nullable) id<RSAutocompleteSource> autocompleteSource;
@property (nonatomic, weak, nullable) UITextField *textField;

@end
