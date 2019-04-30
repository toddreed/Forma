//
//  ViewController.m
//  Demo
//
//  Created by Todd Reed on 2015-09-25.
//  Copyright © 2015 Reaction Software Inc. All rights reserved.
//

#import "ViewController.h"
#import "RSObjectEditorViewController.h"
#import "ModelObject.h"

@interface ViewController ()

@end

@implementation ViewController
{
    ModelObject *_modelObject;
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self)
    {
        _modelObject = [[ModelObject alloc] init];
    }
    return self;
}

- (IBAction)editButtonPressed:(id)sender
{

    RSObjectEditorViewController *viewController = [[RSObjectEditorViewController alloc] initWithObject:_modelObject];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBar.prefersLargeTitles = YES;
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
