//
//  IBView.h
//  ExtremeVPN
//
//  Created by 蒋甜 on 2017/6/20.
//  Copyright © 2017年 Musjoy. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface IBView : UIView

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@property (nonatomic, assign) IBInspectable BOOL semicircle;///< 始终一般高度的圆角
@end
