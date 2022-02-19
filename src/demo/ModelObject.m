//
//  ModelObject.m
//  Forma
//
//  Created by Todd Reed on 2015-09-25.
//  Copyright © 2015 Reaction Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelObject.h"
#import "RSFormItem.h"
#import "RSTextInputPropertyEditor.h"
#import "RSArrayAutocompleteSource.h"
#import "RSFormSection.h"
#import "RSFloatPropertyEditor.h"
#import "RSDiscreteNumericPropertyEditor.h"
#import "RSFormNavigation.h"
#import "RSBooleanPropertyEditor.h"
#import "RSEnumPropertyEditor.h"
#import "RSFormButton.h"
#import "RSPropertyViewer.h"


@interface DistanceFormatter: NSFormatter
@end


@implementation DistanceFormatter
{
    NSMeasurementFormatter *_measurementFormatter;
}

- (instancetype)init
{
    self = [super init];

    _measurementFormatter = [[NSMeasurementFormatter alloc] init];
    NSNumberFormatter *numberFormatter = _measurementFormatter.numberFormatter;
    numberFormatter.minimumIntegerDigits = 1;
    numberFormatter.minimumFractionDigits = 1;
    numberFormatter.maximumFractionDigits = 1;

    return self;
}

- (NSString *)stringForObjectValue:(id)obj
{
    NSMeasurement *measurement = [[NSMeasurement alloc] initWithDoubleValue:[obj doubleValue] unit:NSUnitLength.kilometers];
    return [_measurementFormatter stringFromMeasurement:measurement];
}

@end


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
    RSTextInputPropertyEditor *editor = [[RSTextInputPropertyEditor alloc] initWithKey:@"firstName" ofObject:self title:NSLocalizedString(@"First Name", @"label") style:RSTextInputPropertyEditorStyleForm];
    editor.autocapitalizationType = UITextAutocapitalizationTypeWords;
    editor.placeholder = NSLocalizedString(@"First Name", @"text field placeholder");

    RSArrayAutocompleteSource *autocompleteSource = [[RSArrayAutocompleteSource alloc] initWithArray:@[@"Todd", @"Tom", @"Bill", @"Bob", @"Robert", @"Jerry"]];
    editor.autocompleteSource = autocompleteSource;

    return editor;
}

- (nonnull RSTextInputPropertyEditor *)lastNamePropertyEditor
{
    RSTextInputPropertyEditor *editor = [[RSTextInputPropertyEditor alloc] initWithKey:@"lastName" ofObject:self title:NSLocalizedString(@"Last Name", @"label") style:RSTextInputPropertyEditorStyleForm];
    editor.autocapitalizationType = UITextAutocapitalizationTypeWords;
    editor.placeholder = NSLocalizedString(@"Last Name", @"text field placeholder");
    return editor;
}

- (nonnull RSTextInputPropertyEditor *)passwordPropertyEditor
{
    RSTextInputPropertyEditor *editor = [[RSTextInputPropertyEditor alloc] initWithKey:@"password" ofObject:self title:NSLocalizedString(@"Password", @"label") style:RSTextInputPropertyEditorStyleForm];
    editor.autocapitalizationType = UITextAutocapitalizationTypeNone;
    editor.spellCheckingType = UITextSpellCheckingTypeNo;
    editor.secureTextEntry = YES;
    editor.conditionalSecureTextEntry = YES;
    editor.placeholder = NSLocalizedString(@"Password", @"text field placeholder");

    RSCaption *instructionalCaption = [[RSCaption alloc] initWithText:NSLocalizedString(@"Passwords should be at least 7 characters.", "label") type:RSCaptionTypeInstructional];
    [editor addCaption:instructionalCaption];

    RSCaption *warningCaption = [[RSCaption alloc] initWithText:NSLocalizedString(@"Don’t reuse passwords.", "label") type:RSCaptionTypeWarning];
    [editor addCaption:warningCaption];

    return editor;
}

- (nonnull NSArray *)formSections
{
    RSFormButton *buttonPropertyEditor = [[RSFormButton alloc] initWithTitle:@"Sign In" action:nil];
    buttonPropertyEditor.action = ^(UIViewController<RSFormContainer> *_Nonnull viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    };
    NSArray *editors = @[
        [self firstNamePropertyEditor],
        [self lastNamePropertyEditor],
        [self passwordPropertyEditor]
    ];
    RSFormSection *formSection = [[RSFormSection alloc] initWithTitle:@"Account" formItems:editors];
    RSFormSection *button = [[RSFormSection alloc] initWithTitle:nil formItem:buttonPropertyEditor];
    return @[formSection, button];
}

@end

@implementation ModelObject

- (nonnull instancetype)init
{
    self = [super init];
    _bytesAvailable = 111234567890;
    _name = @"John";
    _account = [[Account alloc] init];
    _volume = 0.6;
    _distance = 7.5;
    _equalizer = YES;
    _size = TShirtSizeMedium;
    return self;
}

- (nonnull RSPropertyViewer *)bytesAvailablePropertyEditor
{
    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
    RSPropertyViewer *editor = [[RSPropertyViewer alloc] initWithKey:@"bytesAvailable" ofObject:self title:@"Bytes Available" formatter:formatter];
    return editor;
}

- (nonnull RSTextInputPropertyEditor *)namePropertyEditor
{
    RSTextInputPropertyEditor *editor = [[RSTextInputPropertyEditor alloc] initWithKey:@"name" ofObject:self title:NSLocalizedString(@"Name", @"label")];
    editor.autocapitalizationType = UITextAutocapitalizationTypeWords;
    editor.spellCheckingType = UITextSpellCheckingTypeNo;
    editor.textContentType = UITextContentTypeName;
    editor.placeholder = NSLocalizedString(@"Name", @"text field placeholder");

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

- (nonnull RSDiscreteNumericPropertyEditor *)distancePropertyEditor
{
    RSDiscreteNumericPropertyEditor *editor = [[RSDiscreteNumericPropertyEditor alloc] initWithKey:@"distance" ofObject:self title:NSLocalizedString(@"Distance", @"label")];
    editor.minimumValue = 1.0;
    editor.maximumValue = 10.0;
    editor.stepValue = 0.5;

    editor.valueFormatter = [[DistanceFormatter alloc] init];
    return editor;
}

- (nonnull RSBooleanPropertyEditor *)equalizerPropertyEditor
{
    RSBooleanPropertyEditor *editor = [[RSBooleanPropertyEditor alloc] initWithKey:@"equalizer" ofObject:self title:@"Equalizer"];
    return editor;
}

- (nonnull RSBooleanPropertyEditor *)enabledPropertyEditor
{
    RSBooleanPropertyEditor *editor = [[RSBooleanPropertyEditor alloc] initWithKey:@"enabled" ofObject:self title:@"Enabled"];
    return editor;
}

- (nonnull RSEnumPropertyEditor *)sizePropertyEditor
{
    NSArray<NSNumber *> *values = @[@(TShirtSizeSmall), @(TShirtSizeMedium), @(TShirtSizeLarge)];
    RSEnumDescriptor *descriptor = [[RSEnumDescriptor alloc] initWithEnumValues:values labels:@[@"Small", @"Medium", @"Large"]];
    RSEnumPropertyEditor *editor = [[RSEnumPropertyEditor alloc] initWithKey:@"size" ofObject:self title:@"T-Shirt Size" enumDescriptor:descriptor];
    return editor;
}

- (nonnull RSTextInputPropertyEditor *)addressPropertyEditor
{
    RSTextInputPropertyEditor *editor = [[RSTextInputPropertyEditor alloc] initWithKey:@"address" ofObject:self title:NSLocalizedString(@"Address", @"label") style:RSTextInputPropertyEditorStyleForm];
    editor.autocapitalizationType = UITextAutocapitalizationTypeNone;
    editor.spellCheckingType = UITextSpellCheckingTypeNo;
    editor.placeholder = NSLocalizedString(@"Address", @"text field placeholder");
    editor.textContentType = UITextContentTypeFullStreetAddress;
    return editor;
}

- (nonnull NSArray *)formSections
{
    NSArray *editors = @[
        [self bytesAvailablePropertyEditor],
        [self namePropertyEditor],
        [self accountPropertyEditor],
        [self volumePropertyEditor],
        [self distancePropertyEditor],
        [self equalizerPropertyEditor],
        [self enabledPropertyEditor],
        [self sizePropertyEditor],
        [self addressPropertyEditor]
    ];
    RSFormSection *formSection = [[RSFormSection alloc] initWithTitle:@"Settings" formItems:editors];

    return @[formSection];
}

- (BOOL)validateName:(inout id  _Nullable __autoreleasing *)ioName error:(out NSError * _Nullable __autoreleasing *)error
{
    NSString *name = *ioName;
    if (![name isEqualToString:@"John"])
    {
        if (error != NULL)
        {
            NSString *description = NSLocalizedString(@"The name must be “John”.", @"error message");
            *error = [NSError errorWithDomain:RSTextInputPropertyValidationErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: description}];
        }
        return NO;
    }
    return YES;
}

#pragma mark RSFormDelegate

- (BOOL)isFormValid:(nonnull RSForm *)form
{
    return _name != nil && [_name isEqualToString:@"John"] && _volume > 0.5;
}

@end
