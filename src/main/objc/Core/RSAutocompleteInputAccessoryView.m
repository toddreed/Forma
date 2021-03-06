//
// Forma
// RSAutocompleteInputAccessoryView.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSAutocompleteInputAccessoryView.h"
#import "RSAutocompleteCell.h"


NSString *const RSAutocompleteCellReuseIdentifier = @"RSAutocompleteCellReuseIdentifier";

@interface RSAutocompleteInputAccessoryView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation RSAutocompleteInputAccessoryView
{
    NSArray<NSString *> *_suggestions;
}

#pragma mark - NSObject

- (nonnull instancetype)init
{
    CGRect frame = CGRectMake(0, 0, 320, 44);
    return [self initWithFrame:frame collectionViewLayout:[[self class] defaultLayout]];
}

#pragma mark - UIView

- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame collectionViewLayout:[[self class] defaultLayout]];
}

#pragma mark - UICollectionView

+ (nonnull UICollectionViewLayout *)defaultLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(7, 7, 7, 7);
    layout.minimumInteritemSpacing = 20;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}

- (nonnull instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];

    _suggestions = @[];
    self.backgroundColor = [UIColor colorWithRed:.815686275f green:.82745098f blue:.854901961f alpha:1.0f];

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self registerClass:[RSAutocompleteCell class] forCellWithReuseIdentifier:RSAutocompleteCellReuseIdentifier];
    self.dataSource = self;
    self.delegate = self;

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

- (void)autocompleteTextFieldChanged:(nonnull UITextField *)textField
{
    NSArray<NSString *> *suggestions = _autocompleteSource == nil ? @[] : [_autocompleteSource autocompleteSuggestionsForPrefix:textField.text];
    if (![suggestions isEqualToArray:_suggestions])
    {
        _suggestions = suggestions;
        [self reloadData];
    }
}

#pragma mark - RSAutocompleteInputAccessoryView

#pragma mark UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _suggestions.count;
}

- (nonnull UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RSAutocompleteCell *cell = [self dequeueReusableCellWithReuseIdentifier:RSAutocompleteCellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _suggestions[indexPath.row];
    [cell setNeedsLayout];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return NO;
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [[UIDevice currentDevice] playInputClick];
    NSString *suggestion = _suggestions[indexPath.row];
    _textField.text = suggestion;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
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
