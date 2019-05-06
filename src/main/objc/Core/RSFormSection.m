//
// Forma
// RSFormSection.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSFormSection.h"
#import "RSFormSection+Private.h"

#import "../FormItems/RSFormItem+Private.h"


@implementation RSFormSection

#pragma mark NSObject

- (nonnull instancetype)init
{
    return [self initWithTitle:nil];
}

#pragma mark RSFormSection

- (nonnull instancetype)initWithTitle:(nullable NSString *)title formItems:(nonnull NSArray<RSFormItem *> *)formItems
{
    NSParameterAssert(formItems != nil);
    
    self = [super init];
    NSParameterAssert(self != nil);

    _title = [title copy];
    _formItems = [formItems copy];

    for (RSFormItem *item in _formItems)
        item.formSection = self;

    return self;
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title formItem:(nonnull RSFormItem *)formItem
{
    NSArray *editors = @[formItem];
    return [self initWithTitle:title formItems:editors];
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
{
    return [self initWithTitle:title formItems:@[]];
}

@end
