//
//  ModelObject.m
//  Object Editor
//
//  Created by Todd Reed on 2015-09-25.
//  Copyright © 2015 Reaction Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelObject.h"
#import "RSFormViewController.h"
#import "RSFormItem.h"
#import "RSTextInputPropertyEditor.h"
#import "RSArrayAutocompleteSource.h"
#import "RSFormSection.h"
#import "RSFloatPropertyEditor.h"
#import "RSFormNavigation.h"
#import "RSBooleanPropertyEditor.h"
#import "RSFormButton.h"
#import "RSPropertyViewer.h"


@implementation Account

- (BOOL)validatePassword:(inout id  _Nullable __autoreleasing *)ioPassword error:(out NSError * _Nullable __autoreleasing *)error
{
    NSString *password = *ioPassword;
    if (password.length <= 6)
    {
        if (error != NULL)
        {
            NSString *description = NSLocalizedString(@"The password must be at least 7 characters long, and have high entropy.", @"error message");
            *error = [NSError errorWithDomain:RSTextInputPropertyValidationErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: description}];
        }
        return NO;
    }
    return YES;
}

#pragma mark RSForm

- (nonnull RSTextInputPropertyEditor *)firstNamePropertyEditor
{
    RSTextInputPropertyEditor *editor = [[RSTextInputPropertyEditor alloc] initWithKey:@"firstName" ofObject:self title:NSLocalizedString(@"First Name", @"label")];
    editor.autocapitalizationType = UITextAutocapitalizationTypeWords;
    editor.placeholder = NSLocalizedString(@"First Name", @"text field placeholder");

    RSArrayAutocompleteSource *autocompleteSource = [[RSArrayAutocompleteSource alloc] initWithArray:@[@"Todd", @"Tom", @"Bill", @"Bob", @"Robert", @"Jerry"]];
    editor.autocompleteSource = autocompleteSource;

    return editor;
}

- (nonnull RSTextInputPropertyEditor *)lastNamePropertyEditor
{
    RSTextInputPropertyEditor *editor = [[RSTextInputPropertyEditor alloc] initWithKey:@"lastName" ofObject:self title:NSLocalizedString(@"Last Name", @"label")];
    editor.autocapitalizationType = UITextAutocapitalizationTypeWords;
    editor.placeholder = NSLocalizedString(@"Last Name", @"text field placeholder");
    return editor;
}

- (nonnull RSTextInputPropertyEditor *)passwordPropertyEditor
{
    RSTextInputPropertyEditor *editor = [[RSTextInputPropertyEditor alloc] initWithKey:@"password" ofObject:self title:NSLocalizedString(@"Password", @"label")];
    editor.autocapitalizationType = UITextAutocapitalizationTypeNone;
    editor.spellCheckingType = UITextSpellCheckingTypeNo;
    editor.secureTextEntry = YES;
    editor.placeholder = NSLocalizedString(@"Password", @"text field placeholder");

    return editor;
}

- (nonnull NSArray *)formSections
{
    RSFormButton *buttonPropertyEditor = [[RSFormButton alloc] initWithTitle:@"Sign In" action:nil];
    buttonPropertyEditor.action = ^(UIViewController<RSFormContainer> *_Nonnull viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    };
    NSArray *editors = @[[self firstNamePropertyEditor],
                         [self lastNamePropertyEditor],
                         [self passwordPropertyEditor]];
    RSFormSection *formSection = [[RSFormSection alloc] initWithTitle:@"Account" formItemArray:editors];
    RSFormSection *button = [[RSFormSection alloc] initWithTitle:nil formItem:buttonPropertyEditor];
    return @[formSection, button];
}

@end

@implementation ModelObject

- (nonnull instancetype)init
{
    self = [super init];
    _bytesAvailable = 111234567890;
    _account = [[Account alloc] init];
    _volume = 0.6;
    _equalizer = YES;
    return self;
}


- (nonnull RSPropertyViewer *)bytesAvailablePropertyEditor
{
    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
    RSPropertyViewer *editor = [[RSPropertyViewer alloc] initWithKey:@"bytesAvailable" ofObject:self title:@"Bytes Available" formatter:formatter];
    return editor;
}

- (nonnull RSFormNavigation *)accountPropertyEditor
{
    RSFormNavigation *editor = [[RSFormNavigation alloc] initWithTitle:@"Account" object:_account];
    return editor;
}

- (nonnull RSFloatPropertyEditor *)volumePropertyEditor
{
    RSFloatPropertyEditor *editor = [[RSFloatPropertyEditor alloc] initWithKey:@"volume" ofObject:self title:NSLocalizedString(@"Volume", @"label")];
    editor.minimumValueImage = [UIImage imageNamed:@"MinimumVolume"];
    editor.maximumValueImage = [UIImage imageNamed:@"MaximumVolume"];
    return editor;
}

- (nonnull RSBooleanPropertyEditor *)equalizerPropertyEditor
{
    RSBooleanPropertyEditor *editor = [[RSBooleanPropertyEditor alloc] initWithKey:@"equalizer" ofObject:self title:@"Equalizer"];
    return editor;
}

- (nonnull NSArray *)formSections
{
    NSArray *editors = @[[self bytesAvailablePropertyEditor],
                         [self accountPropertyEditor],
                         [self volumePropertyEditor],
                         [self equalizerPropertyEditor]];
    RSFormSection *formSection = [[RSFormSection alloc] initWithTitle:@"Settings" formItemArray:editors];

    return @[formSection];
}

@end
