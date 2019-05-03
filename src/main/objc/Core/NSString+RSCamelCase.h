//
// Forma
// NSString+RSCamelCase.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>


@interface NSString (RSCamelCase)

- (nonnull NSString *)rs_stringByConvertingCamelCaseToTitleCase;

@end
