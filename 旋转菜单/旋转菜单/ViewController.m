//
//  ViewController.m
//  旋转菜单
//
//  Created by AlexChang on 16/7/28.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "ViewController.h"
#import "ADRotateView.h"
#import "ADItem.h"

@interface ViewController ()<ADRotateViewDelegate>
{
    NSArray *titleArr;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    [view setImage:[UIImage imageNamed:@"zhuanpan_theme5"]];
    
    [self.view addSubview:view];
    NSLog(@"%f",view.frame.size.height);
    titleArr = @[@"投资理财",@"特色服务",@"e账户",@"快贷",@"我的账户",@"转账汇款"];
    NSArray *imgArr = @[@"tzlc_logo_theme5",
          @"tsfw_logo_theme5",
          @"eAcc_logo_theme5",
          @"kuaiedai_logo_theme5",
          @"wdzh_logo_theme5",
          @"zhhk_logo_theme5"];
    
    ADRotateView *rotateView = [[ADRotateView alloc]initWithFrame:CGRectMake(98.5, 100, view.frame.size.height, view.frame.size.height) andImage:nil];
    [rotateView addSubviewWithTitles:titleArr andImages:imgArr andSize:CGSizeMake(60, 60) andCenterImg:@"left_login"];
    rotateView.delegate = self;
    [self.view addSubview:rotateView];
    

}

-(void)ADRotateView:(ADRotateView *)rotateView didSelectedItem:(UIButton *)item{
    if (item.tag ==107) {
        NSLog(@"中间登录按钮被点击了");
    }else{
        NSLog(@"%@按钮被点击了",titleArr[(item.tag-100)]);
    }
}


@end
