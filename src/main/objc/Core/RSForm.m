//
//  RSForm.m
//  Object Editor
//
//  Created by Todd Reed on 2019-05-02.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import "RSForm.h"


@implementation RSForm
{
    NSMutableArray<RSFormSection *> *_sections;
}

#pragma mark - NSObject

#pragma mark - RSForm

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title
{
    NSParameterAssert(title != nil);

    self = [super init];
    _title = [title copy];
    _sections = [[NSMutableArray alloc] init];
    return self;
}

- (void)addSection:(nonnull RSFormSection *)section
{
    NSParameterAssert(section != nil);
    [_sections addObject:section];
}

- (void)setSections:(NSArray<RSFormSection *> * _Nonnull)sections
{
    _sections = [sections mutableCopy];
}

- (NSArray<RSFormSection *> *)sections
{
    return [_sections copy];
}

@end
