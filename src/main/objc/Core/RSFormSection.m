//
// RSFormSection.m
//
// © Reaction Software Inc., 2013
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

- (nonnull instancetype)initWithTitle:(nullable NSString *)title formItemArray:(nonnull NSArray<RSFormItem *> *)formItems
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

- (nonnull instancetype)initWithTitle:(nullable NSString *)title formItems:(nonnull RSFormItem *)firstFormItem, ...
{
    NSMutableArray<RSFormItem *> *editors = [[NSMutableArray alloc] init];
    
    if (firstFormItem != nil)
    {
        [editors addObject:firstFormItem];
        
        va_list editorVarArgs;
        va_start(editorVarArgs, firstFormItem);
        RSFormItem *editor;
        while ((editor = va_arg(editorVarArgs, RSFormItem *)) != nil)
            [editors addObject:editor];
        va_end(editorVarArgs);
    }
    return [self initWithTitle:title formItemArray:editors];
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title formItem:(nonnull RSFormItem *)formItem
{
    NSArray *editors = @[formItem];
    return [self initWithTitle:title formItemArray:editors];
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
{
    return [self initWithTitle:title formItemArray:@[]];
}

@end
