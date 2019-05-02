//
//  RSForm.h
//  Object Editor
//
//  Created by Todd Reed on 2019-05-02.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "../FormItems/RSFormItem.h"
#import "RSFormSection.h"


@interface RSForm : NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *title;
@property (nonatomic, copy, nonnull) NSArray<RSFormSection *> *sections;

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title;
- (void)addSection:(nonnull RSFormSection *)section;

@end
