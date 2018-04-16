//
//  SingleBoardGame.h
//  Lighting
//
//  Created by 刘鹏 on 2018/2/27.
//  Copyright © 2018年 musjoy. All rights reserved.
//  单局游戏管理

#import <Foundation/Foundation.h>
@class PipeLineModel;

/// 方向枚举，按顺时针
typedef NS_ENUM(NSUInteger, Direction) {
    Direction_Top,      ///< 上
    Direction_Right,    ///< 右
    Direction_Bottom,   ///< 下
    Direction_Left,     ///< 左
};

@interface SingleBoardGame : NSObject
@property (nonatomic, assign) NSInteger checkWith;      ///< 棋盘宽
@property (nonatomic, assign) NSInteger checkHeight;    ///< 棋盘高
@property (nonatomic, strong) NSArray<PipeLineModel *> *arrAllPipes;           ///< 所有管道
@property (nonatomic, strong) NSMutableSet<PipeLineModel *> *arrPowerOnPipes;  ///< 已通电的管道

/// 初始化指定地图的单局游戏
- (instancetype)initWithMapName:(NSString *)mapName;

/// 取对应坐标的管道model
- (PipeLineModel *)pipeLineModelWithIndexPath:(NSIndexPath *)indexPath;

/// 旋转管道
- (void)rotatePipeLine:(PipeLineModel *)pipeLine;

/// 是否胜利
- (BOOL)isWin;
@end
