//
// Forma
// RSForm.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSForm.h"
#import "RSFormSection+Private.h"
#import "RSCompoundValidatable.h"
#import "../FormItems/RSTextInputPropertyEditor.h"


@interface RSForm () <RSValidatableDelegate>

@end


@implementation RSForm
{
    NSMutableArray<RSFormSection *> *_sections;
    RSCompoundValidatable *_sectionsCompoundValidable;
    NSUInteger _changeCount;
    _Bool _valid;
}

#pragma mark - NSObject

#pragma mark - RSForm

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title
{
    NSParameterAssert(title != nil);

    self = [super init];
    _enabled = YES;
    _title = [title copy];
    _sections = [[NSMutableArray alloc] init];
    _autoTextFieldNavigation = YES;
    _lastTextFieldReturnKeyType = UIReturnKeyDone;
    _sectionsCompoundValidable = [[RSCompoundValidatable alloc] init];
    _sectionsCompoundValidable.validatableDelegate = self;
    _valid = YES;
    return self;
}

- (void)updateValid
{
    _Bool valid = (_delegate == nil || ([_delegate respondsToSelector:@selector(isFormValid:)] && [_delegate isFormValid:self])) && _sectionsCompoundValidable.valid;
    [self setValid:valid];
}

- (void)setValid:(_Bool)f
{
    if (_valid != f)
    {
        [self willChangeValueForKey:@"valid"];
        _valid = f;
        [self didChangeValueForKey:@"valid"];
        [_validatableDelegate validatableChanged:self];
    }
}

- (void)setDelegate:(id<RSFormDelegate>)delegate
{
    if (delegate == nil)
        [self setValid:_sectionsCompoundValidable.valid];
    else
    {
        BOOL valid = [_delegate respondsToSelector:@selector(isFormValid:)] && [_delegate isFormValid:self];
        [self setValid:valid && _sectionsCompoundValidable.valid];
    }
    _delegate = delegate;
}

- (BOOL)isModified
{
    return _changeCount != 0;
}

- (void)updateChangeCount
{
    _changeCount += 1;
    [self updateValid];
    [_formContainer formWasUpdated];
    if ([_delegate respondsToSelector:@selector(formDidChange:changeCount:)])
        [_delegate formDidChange:self changeCount:_changeCount];
}

- (void)resetChangeCount
{
    _changeCount = 0;
    if ([_delegate respondsToSelector:@selector(formDidResetChangeCount:)])
        [_delegate formDidResetChangeCount:self];
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    for (RSFormSection *section in _sections)
        section.enabled = enabled;
}

- (void)addSection:(nonnull RSFormSection *)section
{
    NSParameterAssert(section != nil);
    [_sections addObject:section];
    [_sectionsCompoundValidable addValidatable:section];
    [self updateValid];
    section.form = self;
}

- (void)setSections:(NSArray<RSFormSection *> * _Nonnull)sections
{
    for (RSFormSection *section in _sections)
        section.form = nil;

    [_sections removeAllObjects];
    [_sectionsCompoundValidable removeAll];

    for (RSFormSection *section in sections)
        [self addSection:section];
    [self updateValid];
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

- (nullable RSFormItem *)formItemForKey:(nonnull NSString *)key
{
    NSParameterAssert(key != nil);

    for (RSFormSection *section in _sections)
    {
        for (RSFormItem *item in section.formItems)
        {
            if ([item isKindOfClass:[RSPropertyFormItem class]])
            {
                RSPropertyFormItem *propertyItem = (RSPropertyFormItem *)item;
                if ([propertyItem.key isEqualToString:key])
                    return propertyItem;
            }
        }
    }
    return nil;
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

#pragma mark RSValidatableDelegate

//@synthesize valid = _valid;

@synthesize validatableDelegate = _validatableDelegate;

- (BOOL)isValid
{
    return _valid;
}

- (void)validatableChanged:(id<RSValidatable>)validatable
{
    [self updateValid];
}

@end
