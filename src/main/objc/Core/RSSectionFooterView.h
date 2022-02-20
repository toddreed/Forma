//
//  RSSectionFooterView.h
//  Forma
//
//  Created by Todd Reed on 2022-02-18.
//  Copyright © 2022 Reaction Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


/// A custom section footer view. The original raison d’être for this class was to allow the
/// footer to be customized with an attributed string.
@interface RSSectionFooterView : UITableViewHeaderFooterView

@property (nonatomic, readonly, nonnull) UILabel *label;

@end

