//
//  GameManager.m
//  Lighting
//
//  Created by 刘鹏 on 2018/2/26.
//  Copyright © 2018年 musjoy. All rights reserved.
//

#import "GameManager.h"
#import "SingleBoardGame.h" //  单局游戏管理

static GameManager *s_gameManager = nil;

@implementation GameManager
#pragma mark - Life Cycle
/// 实例化
+ (instancetype)sharedInstance
{
    static dispatch_once_t once_patch;
    dispatch_once(&once_patch, ^() {
        s_gameManager = [[self alloc] init];
    });
    return s_gameManager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_gameManager = [super allocWithZone:zone];
    });
    
    return s_gameManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _aBoardGame = [[SingleBoardGame alloc] initWithMapName:@"defualt1"];
    }
    return self;
}

#pragma mark - Subjoin

#pragma mark - Public

#pragma mark - Private

@end
