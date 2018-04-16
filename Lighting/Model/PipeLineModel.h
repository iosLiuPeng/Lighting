//
//  PipeLineModel.h
//  Lighting
//
//  Created by 刘鹏 on 2018/2/26.
//  Copyright © 2018年 musjoy. All rights reserved.
//  管道model

#import <Foundation/Foundation.h>

// 管道类型
typedef NS_ENUM(NSUInteger, PipeLineType) {
    PipeLineType_Power,        ///< 电源
    PipeLineType_SinglePoint,  ///< 单点管道
    PipeLineType_Straight,     ///< 直线管道
    PipeLineType_Bending,      ///< 弯折管道
    PipeLineType_ThreeStrip,   ///< 三线管道
};

@interface PipeLineModel : NSObject
@property (nonatomic, assign) PipeLineType type;                ///< 管道类型
@property (nonatomic, strong) NSMutableArray *arrSwitchState;   ///< 各方向边的闭合状态(数组顺序：“上“、”右“、”下“、”左“)
@property (nonatomic, assign) NSInteger rotateCount;            ///< 旋转次数（0-3，对应“上“、”右“、”下“、”左“）

@property (nonatomic, assign) BOOL isConnected;     ///< 是否连通
@property (nonatomic, assign) BOOL powerOn;         ///< 是否通电

/**
 初始化管道model
 
 @param type 管道类型
 @param rotateCount 当前旋转次数
 @return 实例
 */
- (instancetype)initWithType:(PipeLineType)type rotateCount:(NSInteger)rotateCount;
- (instancetype)initWithType:(PipeLineType)type;

/// 批量初始化管道mode
+ (NSArray<PipeLineModel *> *)pipeArrayWithTypeArray:(NSArray<NSNumber *> *)arrTypes;

/// 旋转管道
- (void)rotate;

@end
