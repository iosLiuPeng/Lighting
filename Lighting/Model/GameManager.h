//
//  GameManager.h
//  Lighting
//
//  Created by 刘鹏 on 2018/2/26.
//  Copyright © 2018年 musjoy. All rights reserved.
//  游戏管理

#import <Foundation/Foundation.h>
@class SingleBoardGame;

@interface GameManager : NSObject
@property (nonatomic, strong) SingleBoardGame *aBoardGame;  ///< 一局游戏

/// 实例化
+ (instancetype)sharedInstance;
@end
