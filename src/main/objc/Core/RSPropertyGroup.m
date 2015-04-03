//
// RSPropertyGroup.m
//
// © Reaction Software Inc., 2013
//


#import "RSPropertyGroup.h"


@implementation RSPropertyGroup

#pragma mark NSObject

- (id)init
{
    return [self initWithTitle:nil];
}

#pragma mark RSPropertyGroup

- (id)initWithTitle:(NSString *)title propertyEditorArray:(NSArray *)somePropertyEditors
{
    NSParameterAssert(somePropertyEditors != nil);
    
    if ((self = [super init]))
    {
        _title = [title copy];
        _propertyEditors = [[NSMutableArray alloc] initWithArray:somePropertyEditors];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title propertyEditors:(RSPropertyEditor *)firstPropertyEditor, ...
{
    NSMutableArray *editors = [[NSMutableArray alloc] init];
    
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

- (id)initWithTitle:(NSString *)title propertyEditor:(RSPropertyEditor *)propertyEditor
{
    NSArray *editors = @[propertyEditor];
    return [self initWithTitle:title propertyEditorArray:editors];
}

- (id)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title propertyEditorArray:@[]];
}

@end
