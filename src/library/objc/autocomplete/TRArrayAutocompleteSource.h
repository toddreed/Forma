//
//  TRArrayAutocompleteSource.h
//  Object Editor
//
//  Created by Todd Reed on 2013-07-10.
//  Copyright (c) 2013 Reaction Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRAutocompleteSource.h"

@interface TRArrayAutocompleteSource : NSObject <TRAutocompleteSource>

- (id)initWithArray:(NSArray *)array;

@end
