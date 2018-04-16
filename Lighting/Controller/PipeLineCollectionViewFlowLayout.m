//
//  PipeLineCollectionViewFlowLayout.m
//  Lighting
//
//  Created by 刘鹏 on 2018/2/27.
//  Copyright © 2018年 musjoy. All rights reserved.
//

#import "PipeLineCollectionViewFlowLayout.h"

@interface PipeLineCollectionViewFlowLayout ()
@property (nonatomic, strong) NSArray *arrAttributes;
@property (nonatomic, assign) NSInteger section;    // 组数
@property (nonatomic, assign) NSInteger row;
@end

@implementation PipeLineCollectionViewFlowLayout
//布局准备。提前算好，避免多次计算
-(void)prepareLayout {
    // 组数
    _section = self.collectionView.numberOfSections;
    // 行数
    _row = [self.collectionView numberOfItemsInSection:0];

    
    CGFloat totalWidth = self.collectionView.bounds.size.width;
    CGFloat totalHeight = self.collectionView.bounds.size.height;
    
    // cell大小
    CGFloat itemWidth = floor(totalWidth / _row);
    CGFloat itemHeight = floor(totalHeight / _section);
    CGFloat minSize = MIN(itemWidth, itemHeight);
    self.itemSize = CGSizeMake(minSize, minSize);

    //计算所有cell布局
    [self creatAttributes];
}

-(void)creatAttributes{
    NSMutableArray *muarrAttr = [NSMutableArray arrayWithCapacity:_section * _row];
    for (int y = 0; y < _section; y++) {
        for (int x = 0; x < _row; x++) {
            //创建UICollectionViewLayoutAttributes
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:x inSection:y];
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [muarrAttr addObject:attrs];
        }
    }
    _arrAttributes = [muarrAttr copy];
}

//确定内容大小
- (CGSize)collectionViewContentSize {
    CGSize size = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    return size;
}

//返回范围内的所有布局属性
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.arrAttributes;
}

//计算每个cell的布局
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    //计算位置
    CGFloat xPotion = self.itemSize.width * indexPath.row;
    CGFloat yPotion = self.itemSize.height * indexPath.section;
    
    attrs.frame = CGRectMake(xPotion, yPotion, self.itemSize.width, self.itemSize.height);
    return attrs;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (self.collectionView.bounds.size.width != newBounds.size.width ||
        self.collectionView.bounds.size.height != newBounds.size.height) {
        return YES;
    } else {
        return NO;
    }
}

//边框大小改变
- (void)finalizeAnimatedBoundsChange {
}
@end
