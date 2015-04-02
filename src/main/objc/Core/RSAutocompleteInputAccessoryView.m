//
//  RSAutocompleteInputAccessoryView.m
//  Object Editor
//
//  Created by Todd Reed on 2013-07-10.
//  Copyright (c) 2013 Reaction Software Inc. All rights reserved.
//

#import "UITheme/TRUITheme.h"

#import "RSAutocompleteInputAccessoryView.h"
#import "RSAutocompleteCell.h"


NSString *const RSAutocompleteCellReuseIdentifier = @"RSAutocompleteCellReuseIdentifier";

@interface RSAutocompleteInputAccessoryView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation RSAutocompleteInputAccessoryView
{
    NSArray *_suggestions;
}

#pragma mark - NSObject

- (id)init
{
    CGRect frame = CGRectMake(0, 0, 320, 38);
    return [self initWithFrame:frame collectionViewLayout:[[self class] defaultLayout]];
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame collectionViewLayout:[[self class] defaultLayout]];
}

#pragma mark - UICollectionView

+ (UICollectionViewLayout *)defaultLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(7, 7, 7, 7);
    return layout;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        id<TRUITheme> theme = [TRUITheme currentTheme];

        self.backgroundColor = [theme backgroundColorWithAlpha:1.0f];

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self registerClass:[RSAutocompleteCell class] forCellWithReuseIdentifier:RSAutocompleteCellReuseIdentifier];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)setTextField:(UITextField *)textField
{
    if (_textField != textField)
    {
        if (_textField)
        {
            [_textField removeTarget:self action:@selector(autocompleteTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            if (_textField.inputAccessoryView == self)
                _textField.inputAccessoryView = nil;
        }
        
        _textField = textField;

        [_textField addTarget:self action:@selector(autocompleteTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField.inputAccessoryView = self;
    }
}

- (void)autocompleteTextFieldChanged:(UITextField *)textField
{
    _suggestions = [_autocompleteSource autocompleteSuggestionsForPrefix:textField.text];
    [self reloadData];
}

#pragma mark - RSAutocompleteInputAccessoryView

#pragma mark UIInputViewAudioFeedback

- (BOOL) enableInputClicksWhenVisible
{
    return YES;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_suggestions count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RSAutocompleteCell *cell = [self dequeueReusableCellWithReuseIdentifier:RSAutocompleteCellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _suggestions[indexPath.row];
    [cell setNeedsLayout];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIDevice currentDevice] playInputClick];
    NSString *suggestion = _suggestions[indexPath.row];
    _textField.text = suggestion;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *suggestion = _suggestions[indexPath.row];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets inset = layout.sectionInset;
    CGFloat maxWidth = collectionView.bounds.size.width-inset.left-inset.right;
    CGSize size = [RSAutocompleteCell preferredSizeForString:suggestion];
    if (size.width > maxWidth)
        size.width = maxWidth;
    return size;
}

@end
