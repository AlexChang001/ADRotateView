//
//  ADRotateView.h
//  旋转菜单
//
//  Created by AlexChang on 16/7/28.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADItem.h"
@class ADRotateView;

@protocol ADRotateViewDelegate <NSObject>

- (void)ADRotateView:(ADRotateView *)rotateView didSelectedItem:(UIButton *)item;

@end

@interface ADRotateView : UIView

@property (weak,nonatomic)id<ADRotateViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame andImage:(UIImage *)image;

- (void)addSubviewWithTitles:(NSArray *)titleArr andImages:(NSArray *)imgArr andSize:(CGSize)size andCenterImg:(NSString *)centetImg;
@end
