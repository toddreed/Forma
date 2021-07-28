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
    UIButton *button = [[self class] makeButton];
    [button setTitle:@"Submit" forState:UIControlStateNormal];
    viewController.submitButton = button;
    viewController.headerImage = [UIImage systemImageNamed:@"text.bubble.fill" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:48]];
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

+ (UIButton *)makeButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    const CGFloat cornerRadius = 10;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius);
    CGRect frame = CGRectMake(0, 0, cornerRadius*2+1, cornerRadius*2+1);
    UIImage *buttonBackgroundImage = [self imageOfButtonBackgroundWithFrame:frame color:UIColor.systemBlueColor cornerRadius:cornerRadius];
    button.contentEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5);
    [button setBackgroundImage:[buttonBackgroundImage resizableImageWithCapInsets:edgeInsets] forState:UIControlStateNormal];
    [button setTitleColor:UIColor.systemBackgroundColor forState:UIControlStateFocused];
    return button;
}

+ (nonnull UIImage*)imageOfButtonBackgroundWithFrame:(CGRect)frame color:(nonnull UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    NSParameterAssert(color != nil);

    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0f);

    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame)) cornerRadius: cornerRadius];
    [color setFill];
    [rectanglePath fill];

    UIImage* imageOfButtonBackground = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfButtonBackground;
}

@end
