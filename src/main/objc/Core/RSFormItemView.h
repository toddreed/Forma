//
// Forma
// RSFormItemView.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>


@protocol RSFormItemView <NSObject>

@property (nonatomic, strong, readonly, nullable) UILabel *titleLabel;

@end
