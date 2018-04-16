//
//  SingleBoardGame.m
//  Lighting
//
//  Created by 刘鹏 on 2018/2/27.
//  Copyright © 2018年 musjoy. All rights reserved.
//

#import "SingleBoardGame.h"
#import <UIKit/NSIndexPath+UIKitAdditions.h>
#import "PipeLineModel.h"   // 管道model

@interface SingleBoardGame ()
@property (nonatomic, strong) NSMutableArray<PipeLineModel *> *arrPower; ///< 电源管道数组
@end

@implementation SingleBoardGame
#pragma mark - Life Cycle
/// 初始化指定地图的单局游戏
- (instancetype)initWithMapName:(NSString *)mapName
{
    self = [super init];
    if (self) {
        _arrAllPipes = [self allPipesWithMapName:mapName];
        
        // 电源数组
        _arrPower = [[NSMutableArray alloc] init];
        for (PipeLineModel *pipeLine in _arrAllPipes) {
            if (pipeLine.type == PipeLineType_Power) {
                [_arrPower addObject:pipeLine];
            }
        }
        
        // 判断连通状态
        for (PipeLineModel *aPipeLine in _arrAllPipes) {
            aPipeLine.isConnected = [self checkPipeLineConnect:aPipeLine];
        }
        
        // 检查通电状态
        [self checkPowerOn];
    }
    return self;
}

#pragma mark - Subjoin
/// 从指定地图名称中初始化管道数组
- (NSArray *)allPipesWithMapName:(NSString *)mapName
{
    // 读取地图中信息
    NSString *path = [[NSBundle mainBundle] pathForResource:mapName ofType:@"txt"];
    NSString *strMap = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *arrSection = [strMap componentsSeparatedByString:@"\n"];
    NSArray *arrFirstRow = [arrSection.firstObject componentsSeparatedByString:@" "];
    
    // 去除多余的空行
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    for (NSString *str in arrSection) {
        if (str.length) {
            [sections addObject:str];
        }
    }
    
    // 棋盘宽
    _checkWith = arrFirstRow.count;
    // 棋盘高
    _checkHeight = sections.count;
    
    // 管道类型数组
    NSMutableArray *arrPipeType = [NSMutableArray arrayWithCapacity:_checkWith * _checkHeight];
    for (NSString *strSetion in sections) {
        NSArray *arrRow = [strSetion componentsSeparatedByString:@" "];
        
        for (NSString *strType in arrRow) {
            [arrPipeType addObject:[NSNumber numberWithInteger:[strType integerValue]]];
        }
    }
    
    // 管道数组
    NSArray *arrPipes = nil;
    if (arrPipeType.count != 0 && arrPipeType.count == _checkWith * _checkHeight) {
         arrPipes = [PipeLineModel pipeArrayWithTypeArray:arrPipeType];
    }
    return arrPipes;
}

#pragma mark - Public
/// 旋转管道
- (void)rotatePipeLine:(PipeLineModel *)pipeLine
{
    // 旋转管道
    [pipeLine rotate];
    
    // 检查连通状态
    [self checkConnectedState:pipeLine];
    
    // 检查通电状态
    [self checkPowerOn];
}

/// 检查连通状态
- (void)checkConnectedState:(PipeLineModel *)pipeLine
{
//    // 判断通电状态
//    for (PipeLineModel *aPipeLine in _arrAllPipes) {
//        aPipeLine.isConnected = [self checkPipeLineConnect:aPipeLine];
//    }

    // 判断当前管道的连通状态
    pipeLine.isConnected = [self checkPipeLineConnect:pipeLine];
    
    // 对应四个方向的管道，判断连通状态
    NSArray *arrAdjoinPipes = [self adjoinPipeLineArrayWithPipeLine:pipeLine];
    for (PipeLineModel *aPipeLine in arrAdjoinPipes) {
        if (![aPipeLine isKindOfClass:[NSNull class]]) {
            aPipeLine.isConnected = [self checkPipeLineConnect:aPipeLine];
        }
    }
}

/// 检查通电状态
- (void)checkPowerOn
{
    // 已通电的管道
    _arrPowerOnPipes = [[NSMutableSet alloc] init];
    // 重置通电状态
    for (PipeLineModel *aPipeLine in _arrAllPipes) {
        aPipeLine.powerOn = NO;
    }
    
    // 判断通电状态
    for (PipeLineModel *aPower in _arrPower) {
        [self checkPipeLinePowerOn:aPower];
        
        // 如果第一遍已经全通电，则不继续计算剩余的电源路径
        if (_arrPowerOnPipes.count == _arrAllPipes.count) {
            break;
        }
    }
}

/// 是否胜利
- (BOOL)isWin
{
    // 胜利条件：全连通
    BOOL win = YES;
    
    // 是否全连通
    for (PipeLineModel *aPipeLine in _arrAllPipes) {
        if (aPipeLine.isConnected == NO) {
            win = NO;
            break;
        }
    }

    return win;
}

/// 取对应坐标的管道model
- (PipeLineModel *)pipeLineModelWithIndexPath:(NSIndexPath *)indexPath
{
    PipeLineModel *aPipeLine = nil;
    
    NSInteger index = indexPath.section * _checkWith + indexPath.row;
    if (index >= 0 && index < _arrAllPipes.count) {
        aPipeLine = [_arrAllPipes objectAtIndex:index];
    }
    return aPipeLine;
}

#pragma mark - Private
/// 返回当前管道相邻一个方向的管道model。没有相邻的则返回nil
- (PipeLineModel *)adjoinPipeLineWithCurrentPipeLine:(PipeLineModel *)currentPipeLine direction:(Direction)direction
{
    // 当前管道坐标
    NSInteger index = [_arrAllPipes indexOfObject:currentPipeLine];
    
    // 相邻方向管道坐标
    NSInteger adjoinIndex = NSNotFound;
    switch (direction) {
        case Direction_Top:
            if (index - _checkWith >= 0) {
                adjoinIndex = index - _checkWith;
            }
            break;
        case Direction_Right:
            if ((index + 1) / _checkWith == index / _checkWith) {
                adjoinIndex = index + 1;
            }
            break;
        case Direction_Bottom:
            if (index + _checkWith < _arrAllPipes.count) {
                adjoinIndex = index + _checkWith;
            }
            break;
        case Direction_Left:
            if (index > 0 && ((index - 1) / _checkWith == index / _checkWith)) {
                adjoinIndex = index - 1;
            }
            break;
        default:
            break;
    }
    
    // 相邻管道
    PipeLineModel *adjoinPipeLine = nil;
    if (adjoinIndex != NSNotFound) {
        adjoinPipeLine = [_arrAllPipes objectAtIndex:adjoinIndex];
    }
    
    return adjoinPipeLine;
}

// 检查管道的连通状态
- (BOOL)checkPipeLineConnect:(PipeLineModel *)currentPipeLine
{
    BOOL isConnect = YES;
    
    // 对应四个方向的管道
    NSArray *arrAdjoinPipes = [self adjoinPipeLineArrayWithPipeLine:currentPipeLine];
    
    // 对应四个方向的闭合状态
    NSMutableArray *arrAdjoinSwitchState = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrAdjoinPipes.count; i++) {
        PipeLineModel *adjoinPipeLine = arrAdjoinPipes[i];
        
        if ([adjoinPipeLine isKindOfClass:[NSNull class]]) {
            [arrAdjoinSwitchState addObject:@(NO)];
        } else {
            BOOL aAdjoinState = [adjoinPipeLine.arrSwitchState[(i + 2) % 4] boolValue];
            [arrAdjoinSwitchState addObject:@(aAdjoinState)];
        }
    }
    
    // 判断连通状态
    for (NSInteger index = 0; index < 4; index ++) {
        BOOL aState = [currentPipeLine.arrSwitchState[index] boolValue];
        BOOL aAdjoinState = [arrAdjoinSwitchState[index] boolValue];
        
        // 当前管道连接状态
        if (aState == YES && aAdjoinState == NO) {
            isConnect = NO;
        }
    }
    
    return isConnect;
}

/**
 取当前四周四个方向的管道

 @param pipeLine 已当前此管道为中心点，取四个方向的相邻管道
 @return 返回的数组中顺序为上、右、下、左，这里数组中的元素是有可能为NULL的，所以使用时注意判断
 */
- (NSArray *)adjoinPipeLineArrayWithPipeLine:(PipeLineModel *)pipeLine
{
    NSMutableArray *arrPipes = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        PipeLineModel *adjoinPipeLine = [self adjoinPipeLineWithCurrentPipeLine:pipeLine direction:i];
        [arrPipes addObject:adjoinPipeLine? adjoinPipeLine: [NSNull null]];
    }
    return [arrPipes copy];
}

/// 检查管道通电状态
- (void)checkPipeLinePowerOn:(PipeLineModel *)pipeLine
{
    pipeLine.powerOn = YES;
    [_arrPowerOnPipes addObject:pipeLine];
    
    // 遍历邻接连通的管道
    for (NSInteger direction = 0; direction < 4; direction ++) {
        BOOL aState = [pipeLine.arrSwitchState[direction] boolValue];
        if (aState == YES) {
            // 取对应方向管道
            PipeLineModel *adjoinPipeLine = [self adjoinPipeLineWithCurrentPipeLine:pipeLine direction:direction];
            // 对应边的连通状态
            BOOL aAdjoinState = [adjoinPipeLine.arrSwitchState[(direction + 2) % 4] boolValue];
            // 如果有下个连通管道，且此管道没有遍历过，则继续遍历此管道
            if (aAdjoinState == YES && [_arrPowerOnPipes containsObject:adjoinPipeLine] == NO) {
                // 检查管道通电状态
                [self checkPipeLinePowerOn:adjoinPipeLine];
            }
        }
    }
}

@end
