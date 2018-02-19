//
// NSObject+RSProperties.m
//
// © Reaction Software Inc., 2013
//


#import "NSObject+RSProperties.h"

BOOL RSTrueFilter(objc_property_t property)
{
    return YES;
}

BOOL RSMutablePropertyFilter(objc_property_t property)
{
    const char *attrs = property_getAttributes(property);
    return strstr(attrs, ",R") == NULL;
}

BOOL RSReadOnlyPropertyFilter(objc_property_t property)
{
    return !RSMutablePropertyFilter(property);
}

static void AddPropertyNames(NSMutableArray<NSString *> *_Nonnull propertyNames, const objc_property_t *_Nonnull properties, unsigned int count, RSPropertyFilter filter)
{
    for (unsigned int i = 0; i < count; ++i)
    {
        if (filter == NULL || filter(properties[i]))
        {
            const char *propertyName = property_getName(properties[i]);
            NSString *key = @(propertyName);
            [propertyNames addObject:key];
        }
    }
}

static NSRange RangeOfTypeEncoding(const char *propertyAttributes)
{
    // A property declared like this:
    // 
    // @property char charDefault;
    // 
    // will have a attribute of "Tc,VcharDefault". The leading character is always T, followed
    // by the @encode type string, followed by a comma (and other attributes)

    const char *endType = strchr(propertyAttributes, ',');
    if (endType == NULL)
        return NSMakeRange(NSNotFound, 0);
    else
        return NSMakeRange(1, endType-propertyAttributes-1);
}

static char *CopyStringRange(const char *s, NSRange range, bool autoRelease)
{
    char *buffer = malloc(sizeof(char)*(range.length+1));
    memcpy(buffer, s+range.location, range.length);
    buffer[range.length] = '\0';
    
    if (autoRelease)
        [NSData dataWithBytesNoCopy:buffer length:range.length+1 freeWhenDone:YES];
    
    return buffer;
}

static const char *GetPropertyTypeString(objc_property_t property)
{
    const char *attrs = property_getAttributes(property);

    if (attrs == NULL)
        return NULL;

    NSRange range = RangeOfTypeEncoding(attrs);
    return CopyStringRange(attrs, range, true);
}

static Class GetClass(objc_property_t property)
{
    const char *attrs = property_getAttributes(property);
    
    if (attrs == NULL)
        return nil;

    NSRange range = RangeOfTypeEncoding(attrs);
    
    // The type encoding for a typed object will be @"Foobar",...
    if (range.length > 3 && attrs[range.location] == '@')
    {
        // Modify range to just the class name
        range.location += 2;
        range.length -= 3;
        
        char *className = CopyStringRange(attrs, range, false);
        Class cls = objc_getClass(className);
        free(className);
        return cls;
    }
    return nil;
}

@implementation NSObject (RSProperties)

+ (nonnull NSArray<NSString *> *)rs_declaredPropertyNamesMatchingFilter:(RSPropertyFilter)filter
{
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    
    NSMutableArray *propertyNames = [[NSMutableArray alloc] initWithCapacity:propertyCount];
    AddPropertyNames(propertyNames, properties, propertyCount, filter);
    free(properties);
    return propertyNames;
}

+ (nonnull NSArray<NSString *> *)rs_declaredPropertyNames
{
    return [self rs_declaredPropertyNamesMatchingFilter:RSTrueFilter];
}

+ (nonnull NSArray<NSString *> *)rs_allDeclaredPropertyNames
{
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    
    Class cls = self;
    while (cls != NULL)
    {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
        AddPropertyNames(propertyNames, properties, propertyCount, RSTrueFilter);
        free(properties);
        
        cls = [cls superclass];
    }
    
    return propertyNames;
}

+ (nullable const char *)rs_objCTypeOfProperty:(nonnull NSString *)propertyName
{
    objc_property_t property = class_getProperty(self, propertyName.UTF8String);
    return property == NULL ? NULL : GetPropertyTypeString(property);
}

+ (nullable Class)rs_classOfProperty:(nonnull NSString *)propertyName
{
    objc_property_t property = class_getProperty(self, propertyName.UTF8String);
    return property == nil ? nil : GetClass(property);
}

@end
