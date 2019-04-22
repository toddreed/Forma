//
//  RSObjectEditor.m
//  Object Editor
//
//  Created by Todd Reed on 2019-04-19.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import "RSObjectEditor.h"

@implementation RSObjectEditor

+ (nonnull NSBundle *)bundle
{
    NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleURL = [podBundle URLForResource:@"ObjectEditor" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    NSAssert(bundle != nil, @"Failed to find ObjectEditor bundle.");
    return bundle;
}

@end
