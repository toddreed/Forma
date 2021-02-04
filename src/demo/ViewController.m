//
//  ViewController.m
//  Demo
//
//  Created by Todd Reed on 2015-09-25.
//  Copyright © 2015 Reaction Software Inc. All rights reserved.
//

#import <Forma/Core/NSObject+RSForm.h>
#import <Forma/Core/RSFormViewController.h>

#import "ViewController.h"
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
    RSFormViewController *viewController = [[RSFormViewController alloc] initWithForm:_modelObject.form];
    viewController.showDoneButton = YES;
    viewController.completionBlock = ^(RSFormViewController * _Nonnull viewController, BOOL cancelled) {
        [self editingCompleted:cancelled];
    };
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBar.prefersLargeTitles = YES;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)editingCompleted:(BOOL)cancelled
{
    NSLog(@"Form session completed; was cancelled: %d", cancelled);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
