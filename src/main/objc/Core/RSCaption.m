//
//  RSCaption.m
//  Forma
//
//  Created by Todd Reed on 2022-02-18.
//  Copyright © 2022 Reaction Software Inc. All rights reserved.
//

#import "RSCaption.h"


@implementation RSCaption

- (nonnull instancetype)initWithText:(nonnull NSString *)text type:(RSCaptionType)type
{
    NSParameterAssert(text != nil);

    self = [super init];
    _text = [text copy];
    _type = type;
    return self;
}

@end
