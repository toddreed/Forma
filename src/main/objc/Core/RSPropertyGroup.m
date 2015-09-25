//
// RSPropertyGroup.m
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyGroup.h"


@implementation RSPropertyGroup

#pragma mark NSObject

- (nonnull instancetype)init
{
    return [self initWithTitle:nil];
}

#pragma mark RSPropertyGroup

- (nonnull instancetype)initWithTitle:(nullable NSString *)title propertyEditorArray:(nonnull NSArray<RSPropertyEditor *> *)somePropertyEditors
{
    NSParameterAssert(somePropertyEditors != nil);
    
    self = [super init];
    NSParameterAssert(self != nil);

    _title = [title copy];
    _propertyEditors = [[NSMutableArray alloc] initWithArray:somePropertyEditors];

    return self;
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title propertyEditors:(nonnull RSPropertyEditor *)firstPropertyEditor, ...
{
    NSMutableArray<RSPropertyEditor *> *editors = [[NSMutableArray alloc] init];
    
    if (firstPropertyEditor != nil)
    {
        [editors addObject:firstPropertyEditor];
        
        va_list editorVarArgs;
        va_start(editorVarArgs, firstPropertyEditor);
        RSPropertyEditor *editor;
        while ((editor = va_arg(editorVarArgs, RSPropertyEditor *)) != nil)
            [editors addObject:editor];
        va_end(editorVarArgs);
    }
    return [self initWithTitle:title propertyEditorArray:editors];
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title propertyEditor:(nonnull RSPropertyEditor *)propertyEditor
{
    NSArray *editors = @[propertyEditor];
    return [self initWithTitle:title propertyEditorArray:editors];
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
{
    return [self initWithTitle:title propertyEditorArray:@[]];
}

@end
