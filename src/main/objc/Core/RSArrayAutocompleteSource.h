//
//  RSArrayAutocompleteSource.h
//  Object Editor
//
//  Created by Todd Reed on 2013-07-10.
//  Copyright (c) 2013 Reaction Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSAutocompleteSource.h"

@interface RSArrayAutocompleteSource : NSObject <RSAutocompleteSource>

- (nonnull instancetype)init;
- (nonnull instancetype)initWithArray:(nonnull NSArray<NSString *> *)array NS_DESIGNATED_INITIALIZER;

@end
