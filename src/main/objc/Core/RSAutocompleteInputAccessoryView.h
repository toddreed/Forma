//
//  RSAutocompleteInputAccessoryView.h
//  Object Editor
//
//  Created by Todd Reed on 2013-07-10.
//  Copyright (c) 2013 Reaction Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSAutocompleteSource.h"

@interface RSAutocompleteInputAccessoryView : UICollectionView <UIInputViewAudioFeedback>

@property (nonatomic, strong, nullable) id<RSAutocompleteSource> autocompleteSource;
@property (nonatomic, weak) UITextField *textField;

@end
