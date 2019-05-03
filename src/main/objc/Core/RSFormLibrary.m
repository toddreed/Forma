//
// Forma
// RSFormLibrary.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
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
