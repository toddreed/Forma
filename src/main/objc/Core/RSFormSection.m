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

    NSMutableArray<NSObject<RSValidatable> *> *validatables = [[NSMutableArray alloc] initWithCapacity:formItems.count];
    for (RSFormItem *item in formItems)
    {
        if ([item conformsToProtocol:@protocol(RSValidatable)])
            [validatables addObject:(NSObject<RSValidatable> *)item];
    }

    self = [super initWithValidatables:validatables];
    NSParameterAssert(self != nil);

    _enabled = YES;
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

- (void)setFooterText:(NSString *)footerText
{
    _footerText = [footerText copy];
    _footerAttributedText = nil;
}

- (void)setFooterAttributedText:(NSAttributedString *)footerAttributedText
{
    _footerAttributedText = [footerAttributedText copy];
    _footerText = nil;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    for (RSFormItem *item in _formItems)
        item.enabled = enabled;
}

@end
