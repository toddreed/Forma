//
// QPropertyGroup.m
//
// © Reaction Software Inc., 2013
//


#import "QPropertyGroup.h"


@implementation QPropertyGroup

#pragma mark NSObject

- (id)init
{
    return [self initWithTitle:nil];
}

#pragma mark QPropertyGroup

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

- (id)initWithTitle:(NSString *)aTitle propertyEditors:(QPropertyEditor *)firstPropertyEditor, ...
{
    NSMutableArray *editors = [[NSMutableArray alloc] init];
    
    if (firstPropertyEditor != nil)
    {
        [editors addObject:firstPropertyEditor];
        
        va_list editorVarArgs;
        va_start(editorVarArgs, firstPropertyEditor);
        QPropertyEditor *editor;
        while ((editor = va_arg(editorVarArgs, QPropertyEditor *)) != nil)
            [editors addObject:editor];
        va_end(editorVarArgs);
    }
    return [self initWithTitle:aTitle propertyEditorArray:editors];
}

- (id)initWithTitle:(NSString *)aTitle propertyEditor:(QPropertyEditor *)propertyEditor
{
    NSArray *editors = @[propertyEditor];
    return [self initWithTitle:aTitle propertyEditorArray:editors];
}

- (id)initWithTitle:(NSString *)aTitle
{
    return [self initWithTitle:aTitle propertyEditorArray:@[]];
}

@end
