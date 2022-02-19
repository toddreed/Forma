//
//  RSCaption.h
//  Forma
//
//  Created by Todd Reed on 2022-02-18.
//  Copyright © 2022 Reaction Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, RSCaptionType)
{
    RSCaptionTypePlain,
    RSCaptionTypeInstructional,
    RSCaptionTypeInformational,
    RSCaptionTypeWarning,
    RSCaptionTypeError
};


/// RSCaption is a model/data object representing a caption. Captions can be applied to (some)
/// form items.
@interface RSCaption : NSObject

@property (nonatomic, readonly, copy, nonnull) NSString *text;
@property (nonatomic, readonly) RSCaptionType type;

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithText:(nonnull NSString *)text type:(RSCaptionType)type NS_DESIGNATED_INITIALIZER;

@end
