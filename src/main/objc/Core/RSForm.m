//
//  RSForm.m
//  Forma
//
//  Created by Todd Reed on 2019-05-02.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import "RSForm.h"
#import "RSFormSection+Private.h"
#import "../FormItems/RSTextInputPropertyEditor.h"


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
    _autoTextFieldNavigation = YES;
    _lastTextFieldReturnKeyType = UIReturnKeyDone;
    return self;
}

- (void)addSection:(nonnull RSFormSection *)section
{
    NSParameterAssert(section != nil);
    [_sections addObject:section];
    section.form = self;
}

- (void)setSections:(NSArray<RSFormSection *> * _Nonnull)sections
{
    for (RSFormSection *section in _sections)
        section.form = nil;

    [_sections removeAllObjects];
    
    for (RSFormSection *section in sections)
        [self addSection:section];
}

- (NSArray<RSFormSection *> *)sections
{
    return [_sections copy];
}

- (nonnull RSFormItem *)formItemForIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSFormSection *formSection = _sections[indexPath.section];
    RSFormItem *formItem = formSection.formItems[indexPath.row];
    return formItem;
}

- (nullable NSIndexPath *)findNextTextInputAfterFormItem:(nonnull RSFormItem *)targetFormItem
{
    NSUInteger sections = _sections.count;
    BOOL textInputEditorFound = NO;

    for (NSUInteger section = 0; section < sections; ++section)
    {
        RSFormSection *formSection = _sections[section];
        NSUInteger rows = formSection.formItems.count;

        for (NSUInteger row = 0; row < rows; ++row)
        {
            RSFormItem *formItem = formSection.formItems[row];

            if (textInputEditorFound)
            {
                if ([formItem isKindOfClass:[RSTextInputPropertyEditor class]])
                    return [NSIndexPath indexPathForRow:row inSection:section];
            }
            else if (formItem == targetFormItem)
                textInputEditorFound = YES;
        }
    }
    return nil;
}

- (nullable RSTextInputPropertyEditor *)lastTextInputPropertyEditor
{
    NSArray<RSFormSection *> *sections = _sections;

    for (NSInteger section = sections.count-1; section >= 0; --section)
    {
        RSFormSection *formSection = sections[section];

        for (NSInteger row = formSection.formItems.count-1; row >= 0; --row)
        {
            RSFormItem *formItem = formSection.formItems[row];

            if ([formItem isKindOfClass:[RSTextInputPropertyEditor class]])
                return (RSTextInputPropertyEditor *)formItem;
        }
    }
    return nil;
}

@end
