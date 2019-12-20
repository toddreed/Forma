//
//  ModelObject.h
//  Forma
//
//  Created by Todd Reed on 2015-09-25.
//  Copyright © 2015 Reaction Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TShirtSize: NSUInteger
{
    TShirtSizeSmall,
    TShirtSizeMedium,
    TShirtSizeLarge
} TShirtSize;

@interface Account : NSObject

@property (nonatomic, strong, nonnull) NSString *firstName;
@property (nonatomic, strong, nonnull) NSString *lastName;
@property (nonatomic, strong, nonnull) NSString *password;

@end

@interface ModelObject : NSObject

@property (nonatomic, readonly) long long bytesAvailable;
@property (nonatomic, copy, nonnull) NSString *name;
@property (nonatomic, nonnull) Account *account;
@property (nonatomic) float volume;
@property (nonatomic) BOOL equalizer;
@property (nonatomic) BOOL enabled;
@property (nonatomic) Size size;

@end


