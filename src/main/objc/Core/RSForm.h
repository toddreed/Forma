//
// Forma
// RSForm.h
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <Foundation/Foundation.h>

#import "../FormItems/RSFormItem.h"
#import "RSFormSection.h"
#import "RSFormContainer.h"


@class RSTextInputPropertyEditor;


@interface RSForm : NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *title;
@property (nonatomic, copy, nonnull) NSArray<RSFormSection *> *sections;

/// If autoTextFieldNavigation is YES, then the return key for all the text fields, except the last,
/// is set to UIReturnKeyNext; the last text field's return key is set to the value of the
/// lastTextFieldReturnKeyType property. When the user presses the "Next" button on the keyboard,
/// the next text field becomes the first responder. If this property is NO, the return key style is
/// determined by the RSTextInputPropertyEditor returnKeyType property. The default value is YES;
@property (nonatomic) BOOL autoTextFieldNavigation;

/// The lastTextFieldReturnKeyType indicates the return key to use when the autoTextFieldNavigation
/// property is YES. If autoTextFieldNavigation is NO, this property is ignored. The default value
/// is UIReturnKeyDone.
@property (nonatomic) UIReturnKeyType lastTextFieldReturnKeyType;

/// The last RSTextInputPropertyEditor in the form, or nil if there are none.
@property (nonatomic, readonly, nullable) RSTextInputPropertyEditor *lastTextInputPropertyEditor;

@property (nonatomic, weak, nullable) id<RSFormContainer> formContainer;

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title;
- (void)addSection:(nonnull RSFormSection *)section;

- (nonnull RSFormItem *)formItemForIndexPath:(nonnull NSIndexPath *)indexPath;
- (nullable NSIndexPath *)findNextTextInputAfterFormItem:(nonnull RSFormItem *)item;

@end
