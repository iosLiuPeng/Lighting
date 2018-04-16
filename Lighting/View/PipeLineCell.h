//
//  PipeLineCell.h
//  Lighting
//
//  Created by 刘鹏 on 2018/2/26.
//  Copyright © 2018年 musjoy. All rights reserved.
//  管道cell

#import <UIKit/UIKit.h>
@class PipeLineModel;

@interface PipeLineCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;       ///< 内容视图

/// 配置cell
- (void)configWithPipeLineModel:(PipeLineModel *)pipeLine;
@end
