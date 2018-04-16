//
//  PipeLineCell.m
//  Lighting
//
//  Created by 刘鹏 on 2018/2/26.
//  Copyright © 2018年 musjoy. All rights reserved.
//

#import "PipeLineCell.h"
#import "PipeLineModel.h" //  管道model

@interface PipeLineCell ()
@property (weak, nonatomic) IBOutlet UIView *viewBackground;    ///< 背景视图
@property (weak, nonatomic) IBOutlet UIView *viewCover;         ///< 遮罩视图

@property (weak, nonatomic) IBOutlet UIView *viewTopLine;       ///< 向上的管
@property (weak, nonatomic) IBOutlet UIView *viewRightLine;     ///< 向右的管
@property (weak, nonatomic) IBOutlet UIView *viewBottomLine;    ///< 向下的管
@property (weak, nonatomic) IBOutlet UIView *viewLeftLine;      ///< 向左的管
@property (weak, nonatomic) IBOutlet UIView *viewCenter;        ///< 中心的圆
@end

@implementation PipeLineCell
/// 配置cell
- (void)configWithPipeLineModel:(PipeLineModel *)pipeLine
{
    // 管道类型
    switch (pipeLine.type) {
        case PipeLineType_Power:
        case PipeLineType_SinglePoint:
            _viewTopLine.hidden = NO;
            _viewRightLine.hidden = YES;
            _viewBottomLine.hidden = YES;
            _viewLeftLine.hidden = YES;
            _viewCenter.hidden = NO;
            break;
        case PipeLineType_Straight:
            _viewTopLine.hidden = YES;
            _viewRightLine.hidden = NO;
            _viewBottomLine.hidden = YES;
            _viewLeftLine.hidden = NO;
            _viewCenter.hidden = YES;
            break;
        case PipeLineType_Bending:
            _viewTopLine.hidden = NO;
            _viewRightLine.hidden = NO;
            _viewBottomLine.hidden = YES;
            _viewLeftLine.hidden = YES;
            _viewCenter.hidden = YES;
            break;
        case PipeLineType_ThreeStrip:
            _viewTopLine.hidden = NO;
            _viewRightLine.hidden = NO;
            _viewBottomLine.hidden = YES;
            _viewLeftLine.hidden = NO;
            _viewCenter.hidden = YES;
            break;
        default:
            break;
    }
    
    // 管道颜色
    NSArray *arrViewPipes = @[_viewTopLine, _viewRightLine, _viewBottomLine, _viewLeftLine, _viewCenter];
    for (UIView *viewPipe in arrViewPipes) {
        if (pipeLine.type == PipeLineType_Power) {
            viewPipe.backgroundColor = [UIColor redColor];
        } else {
            viewPipe.backgroundColor = [UIColor whiteColor];
        }
    }
    
    // 底色
    if (pipeLine.powerOn) {
        _viewBackground.backgroundColor = [UIColor greenColor];
    }  else {
        _viewBackground.backgroundColor = [UIColor grayColor];
    }
    
    // 遮罩
    if (pipeLine.isConnected != pipeLine.powerOn) {
        _viewCover.hidden = NO;
    } else {
        _viewCover.hidden = YES;
    }
    
    // 旋转
    _viewContent.transform = CGAffineTransformMakeRotation(M_PI_2 * pipeLine.rotateCount);
}


@end
