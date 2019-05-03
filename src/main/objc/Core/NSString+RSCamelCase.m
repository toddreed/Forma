//
// Forma
// NSString+RSCamelCase.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "NSString+RSCamelCase.h"


@implementation NSString (RSCamelCase)

- (nonnull NSString *)rs_stringByConvertingCamelCaseToTitleCase
{
    NSMutableString *string = [NSMutableString string];
    NSUInteger length = self.length;
    
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet] options:NSLiteralSearch range:NSMakeRange(0, length)];
    if (range.location != NSNotFound)
    {
        if (range.location > 0)
        {
            [string appendString:[self substringWithRange:NSMakeRange(0, range.location)].capitalizedString];
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
        return self.capitalizedString;
    }
   return string;
}

@end
