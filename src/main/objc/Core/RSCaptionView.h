//
//  RSCaptionView.h
//  Forma
//
//  Created by Todd Reed on 2022-02-18.
//  Copyright © 2022 Reaction Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RSCaption;

@interface RSCaptionView : UIView

- (nonnull instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithCaption:(nonnull RSCaption *)caption NS_DESIGNATED_INITIALIZER;

@end

