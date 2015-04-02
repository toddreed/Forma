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

@synthesize title;
@synthesize footer;
@synthesize propertyEditors;

- (id)initWithTitle:(NSString *)aTitle propertyEditorArray:(NSArray *)somePropertyEditors
{
    NSParameterAssert(somePropertyEditors != nil);
    
    if ((self = [super init]))
    {
        title = [aTitle copy];
        propertyEditors = [[NSMutableArray alloc] initWithArray:somePropertyEditors];
    }
    return self;
}

- (id)initWithTitle:(NSString *)aTitle propertyEditors:(RSPropertyEditor *)firstPropertyEditor, ...
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
    return [self initWithTitle:aTitle propertyEditorArray:editors];
}

- (id)initWithTitle:(NSString *)aTitle propertyEditor:(RSPropertyEditor *)propertyEditor
{
    NSArray *editors = @[propertyEditor];
    return [self initWithTitle:aTitle propertyEditorArray:editors];
}

- (id)initWithTitle:(NSString *)aTitle
{
    return [self initWithTitle:aTitle propertyEditorArray:@[]];
}

@end
