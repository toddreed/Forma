//
//  TRAutocompleteInputAccessoryView.h
//  Object Editor
//
//  Created by Todd Reed on 2013-07-10.
//  Copyright (c) 2013 Reaction Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRAutocompleteSource.h"

@interface TRAutocompleteInputAccessoryView : UICollectionView <UIInputViewAudioFeedback>

@property (nonatomic, strong) id<TRAutocompleteSource> autocompleteSource;
@property (nonatomic, weak) UITextField *textField;

@end
