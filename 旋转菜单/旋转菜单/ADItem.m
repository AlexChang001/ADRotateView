//
//  ADItem.m
//  旋转菜单
//
//  Created by AlexChang on 16/7/28.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "ADItem.h"

@implementation ADItem

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width-60)/2, 2, 60, 60);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 55, contentRect.size.width, 20);
}
@end
