// -*- coding: utf-8; -*-
//
// © Reaction Software Inc., 2009
//

#import <objc/runtime.h>

#import "NSObject+QExtension.h"

@implementation NSObject (QExtension)

- (void)Q_invalidInitInvoked
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"-[%@ %@] not supported", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
