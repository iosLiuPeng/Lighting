//
//  GameViewController.m
//  Lighting
//
//  Created by 刘鹏 on 2018/2/26.
//  Copyright © 2018年 musjoy. All rights reserved.
//

#import "GameViewController.h"
#import "GameManager.h"     //  游戏管理
#import "SingleBoardGame.h" //  单局游戏管理
#import "PipeLineCell.h"//  管道cell

@interface GameViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) SingleBoardGame *aBoardGame;
@end

@implementation GameViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self viewConfig];
    
    [self dataConfig];
}

#pragma mark - Subjoin
- (void)dataConfig
{
    _aBoardGame = [GameManager sharedInstance].aBoardGame;
    [_collectionView reloadData];
}

- (void)viewConfig
{
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PipeLineCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([PipeLineCell class])];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 取对应cell
    PipeLineCell *aCell = (PipeLineCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // 动画旋转
    [UIView animateWithDuration:0.1 animations:^{
        aCell.viewContent.transform = CGAffineTransformRotate(aCell.viewContent.transform, M_PI_2);
    }];
    
    // 取对应model
    PipeLineModel *aPipeLine = [_aBoardGame pipeLineModelWithIndexPath:indexPath];
    // 旋转管道
    [_aBoardGame rotatePipeLine:aPipeLine];
    
    // 刷新
    [collectionView reloadData];
    
    // 判断是否胜利✌️
    if ([_aBoardGame isWin]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"胜利✌️" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVC animated:YES completion:NULL];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _aBoardGame.checkHeight;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _aBoardGame.checkWith;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PipeLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PipeLineCell class]) forIndexPath:indexPath];
    
    // 取对应model
    PipeLineModel *aPipeLine = [_aBoardGame pipeLineModelWithIndexPath:indexPath];
    // 配置cell
    [cell configWithPipeLineModel:aPipeLine];
    return cell;
}

@end
