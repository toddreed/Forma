// -*- coding: utf-8; -*-
//
// © Reaction Software Inc., 2010
//


#import "NSString+QCamelCase.h"


@implementation NSString (QCamelCase)

- (NSString *)Q_stringByConvertingCamelCaseToTitleCase
{
    NSMutableString *string = [NSMutableString string];
    NSUInteger length = [self length];
    
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet] options:NSLiteralSearch range:NSMakeRange(0, length)];
    if (range.location != NSNotFound)
    {
        if (range.location > 0)
        {
            [string appendString:[[self substringWithRange:NSMakeRange(0, range.location)] capitalizedString]];
            [string appendString:@" "];
        }

        NSUInteger index = range.location;
        
        while (index < length)
        {
            range = [self rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet] options:NSLiteralSearch range:NSMakeRange(index+1, length-index-1)];
            if (range.location != NSNotFound)
            {
                [string appendString:[self substringWithRange:NSMakeRange(index, range.location-index)]];
                [string appendFormat:@" "];
                index = range.location;
            }
            else
            {
                [string appendString:[self substringFromIndex:index]];
                break;
            }
        }
    }
    else
    {
        return [self capitalizedString];
    }
   return string;
}

@end
