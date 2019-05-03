//
//  RSFormItemView.h
//  Forma
//
//  Created by Todd Reed on 2019-05-01.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RSFormItemView <NSObject>

@property (nonatomic, strong, readonly, nullable) UILabel *titleLabel;

@end
