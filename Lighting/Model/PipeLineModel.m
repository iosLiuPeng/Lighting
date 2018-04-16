//
//  PipeLineModel.m
//  Lighting
//
//  Created by 刘鹏 on 2018/2/26.
//  Copyright © 2018年 musjoy. All rights reserved.
//

#import "PipeLineModel.h"

@interface PipeLineModel ()

@end

@implementation PipeLineModel
#pragma mark - Life Circle
/**
 初始化管道model
 */
- (instancetype)initWithType:(PipeLineType)type
{
    return [self initWithType:type rotateCount:0];
}

/**
 初始化管道model
 
 @param type 管道类型
 @param rotateCount 当前旋转次数
 @return 实例
 */
- (instancetype)initWithType:(PipeLineType)type rotateCount:(NSInteger)rotateCount
{
    self = [super init];
    if (self) {
        _type = type;
        _rotateCount = rotateCount;
        
        [self dataConfig];
    }
    return self;
}

#pragma mark - Subjoin
// 初始化数据
- (void)dataConfig
{
    // 各方向边的闭合状态数组
    switch (_type) {
        case PipeLineType_Power:// 电源
        case PipeLineType_SinglePoint:// 单点管道
            _arrSwitchState = [NSMutableArray arrayWithArray:@[@(YES), @(NO), @(NO), @(NO)]];
            break;
        case PipeLineType_Straight:// 直线管道
            _arrSwitchState = [NSMutableArray arrayWithArray:@[@(NO), @(YES), @(NO), @(YES)]];
            break;
        case PipeLineType_Bending:// 弯折管道
            _arrSwitchState = [NSMutableArray arrayWithArray:@[@(YES), @(YES), @(NO), @(NO)]];
            break;
        case PipeLineType_ThreeStrip:// 三线管道
            _arrSwitchState = [NSMutableArray arrayWithArray:@[@(YES), @(YES), @(NO), @(YES)]];
            break;
        default:
            break;
    }
}

#pragma mark - Public
/// 旋转管道
- (void)rotate
{
    // 修改旋转次数
    _rotateCount = (_rotateCount + 1) % 4;
    
    // 修改各方向闭合状态
    [_arrSwitchState insertObject:_arrSwitchState.lastObject atIndex:0];
    [_arrSwitchState removeLastObject];    
}

/// 批量初始化管道model
+ (NSArray<PipeLineModel *> *)pipeArrayWithTypeArray:(NSArray<NSNumber *> *)arrTypes
{
    NSMutableArray *arrPipes = [NSMutableArray arrayWithCapacity:arrTypes.count];
    
    for (NSNumber *type in arrTypes) {
        PipeLineModel *pipeLine = [[PipeLineModel alloc] initWithType:[type integerValue]];
        [arrPipes addObject:pipeLine];
    }
    
    return [arrPipes copy];
}

#pragma mark - Private

@end
