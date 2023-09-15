//
//  ZKCustomLayout.h
//  collectionView
//
//  Created by Apple on 2022/6/29.
//  Copyright © 2022年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZKCustomLayout;

@protocol HTCustomLayoutDelegate <NSObject>

@required
// cell 高
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(ZKCustomLayout *)collectionViewLayout heightForRowAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth ;

@optional
// headersize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(ZKCustomLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

// footer 的 size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(ZKCustomLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

// 每个区的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(ZKCustomLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

// 每个区多少列
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZKCustomLayout *)collectionViewLayout columnNumberAtSection:(NSInteger )section;


// 每个区多少中行距
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZKCustomLayout *)collectionViewLayout andLineSpacingForSectionAtIndex:(NSInteger)section;

// 每个 item 之间的左右间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(ZKCustomLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section;

// 本区区头和上个区区尾的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(ZKCustomLayout*)collectionViewLayout spacingWithLastSectionForSectionAtIndex:(NSInteger)section;

@end


@interface ZKCustomLayout : UICollectionViewLayout


@property (nonatomic, weak) id<HTCustomLayoutDelegate> delegate;

@property (nonatomic,assign) UIEdgeInsets var_sectionInsets;

@property (nonatomic,assign) NSInteger var_columnCount;

@property (nonatomic,assign) CGFloat lineSpacing;

@property (nonatomic,assign) CGFloat interitemSpacing;

@property (nonatomic,assign) CGSize headerReferenceSize;

@property (nonatomic,assign) CGSize footerReferenceSize;



@end
