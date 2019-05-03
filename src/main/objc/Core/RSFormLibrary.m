//
//  RSFormLibrary.m
//  Forma
//
//  Created by Todd Reed on 2019-04-19.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import "RSFormLibrary.h"

@implementation RSFormLibrary

+ (nonnull NSBundle *)bundle
{
    NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleURL = [podBundle URLForResource:@"Forma" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    NSAssert(bundle != nil, @"Failed to find Forma bundle.");
    return bundle;
}

@end
