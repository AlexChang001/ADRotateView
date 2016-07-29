//
//  ADRotateView.m
//  旋转菜单
//
//  Created by AlexChang on 16/7/28.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "ADRotateView.h"

@implementation ADRotateView
{
    NSTimer *_timer;                 //减速定时器
    CGFloat _numOfSubView;           //子试图数量
    UIImageView *_circleView;        //圆形图
    NSMutableArray *_subViewArray;   //子试图数组
    CGPoint beginPoint;              //第一触碰点
    CGPoint movePoint;               //第二触碰点
    BOOL _isPlaying;                 //正在跑
    NSDate * date;                   //滑动时间
    
    NSDate *startTouchDate;
    NSInteger _decelerTime;          //减速计数
    CGSize _subViewSize;             //子试图大小
    UIPanGestureRecognizer *_pgr;
    
    double mStartAngle;   //转动的角度
    int mFlingableValue;   //转动临界速度，超过此速度便是快速滑动，手指离开仍会转动
    int mRadius;  //半径
    NSMutableArray *btnArray;
    float mTmpAngle;   //检测按下到抬起时旋转的角度
    CGRect _frame;
}

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image{
    if (self=[super initWithFrame:frame]) {
        _frame = frame;
        _decelerTime=0;
        _subViewArray=[[NSMutableArray alloc] init];
        _circleView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if(image==nil){
            _circleView.backgroundColor=[UIColor clearColor];
            _circleView.layer.cornerRadius=frame.size.width/2;
            
        }else{
            _circleView.image=image;
            _circleView.backgroundColor=[UIColor clearColor];
        }
        mRadius =frame.size.width/2;
        mStartAngle = 0;
        mFlingableValue = 300;
        _isPlaying = false;
        _circleView.userInteractionEnabled=YES;
        [self addSubview:_circleView];
    }
    return self;
}

- (void)addSubviewWithTitles:(NSArray *)titleArr andImages:(NSArray *)imgArr andSize:(CGSize)size andCenterImg:(NSString *)centetImg{
    _subViewSize=size;
    if(titleArr.count!=0){
        _numOfSubView=(CGFloat)titleArr.count;
    }
    if(imgArr.count!=0){
        _numOfSubView=(CGFloat)imgArr.count;
    }
    btnArray = [[NSMutableArray alloc]init];
    for(NSInteger i=0; i<_numOfSubView ;i++){
        
        ADItem *button=[[ADItem alloc] initWithFrame:CGRectMake(40, 40, size.width, size.height)];
        
        if(imgArr==nil){
            button.backgroundColor=[UIColor yellowColor];
            button.layer.cornerRadius=size.width/2;
        }else{
            [button setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.tag=100+i;
        [btnArray addObject:button];
        [_subViewArray addObject:button];
        [_circleView addSubview:button];
    }
    [self layoutBtn];
    
    //中间视图
    UIButton *buttonCenter=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/3.0, self.frame.size.height/3.0)];
    buttonCenter.tag=100+_numOfSubView;
    if(centetImg==nil){
        buttonCenter.layer.cornerRadius=self.frame.size.width/6.0;
        buttonCenter.backgroundColor=[UIColor redColor];
        [buttonCenter setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [buttonCenter setTitle:@"中间" forState:UIControlStateNormal];
    }else{
        [buttonCenter setImage:[UIImage imageNamed:centetImg] forState:UIControlStateNormal];
    }
    buttonCenter.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [_subViewArray addObject:buttonCenter];
    [_circleView addSubview:buttonCenter];
    //加转动手势
    _pgr=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(zhuanPgr:)];
    [_circleView addGestureRecognizer:_pgr];
    //加点击效果
    for (NSInteger i=0; i<_subViewArray.count; i++) {
        ADItem *button=_subViewArray[i];
        [button addTarget:self action:@selector(subViewOut:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutBtn{
    {
        for (NSInteger i=0; i<_numOfSubView ;i++) {// 178,245
            CGFloat yy=_frame.size.height/2+sin((i/_numOfSubView)*M_PI*2+mStartAngle)*(self.frame.size.width/2-_subViewSize.width/2-40);
            CGFloat xx=_frame.size.height/2+cos((i/_numOfSubView)*M_PI*2+mStartAngle)*(self.frame.size.width/2-_subViewSize.width/2-40);
            UIButton *button=[btnArray objectAtIndex:i];
            button.center=CGPointMake(xx, yy);
        }
    }
}

NSTimer *flowtime;
float anglePerSecond;
float speed;  //转动速度

#pragma mark - 转动手势
-(void)zhuanPgr:(UIPanGestureRecognizer *)pgr
{
    //    UIView *view=pgr.view;
    if(pgr.state==UIGestureRecognizerStateBegan){
        mTmpAngle = 0;
        beginPoint=[pgr locationInView:self];
        startTouchDate=[NSDate date];
    }else if (pgr.state==UIGestureRecognizerStateChanged){
        float StartAngleLast = mStartAngle;
        movePoint= [pgr locationInView:self];
        float start = [self getAngle:beginPoint];   //获得起始弧度
        float end = [self getAngle:movePoint];     //结束弧度
        if ([self getQuadrant:movePoint] == 1 || [self getQuadrant:movePoint] == 4) {
            mStartAngle += end - start;
            mTmpAngle += end - start;
            //            NSLog(@"第一、四象限____%f",mStartAngle);
        } else
            // 二、三象限，色角度值是付值
        {
            mStartAngle += start - end;
            mTmpAngle += start - end;
            //            NSLog(@"第二、三象限____%f",mStartAngle);
            //             NSLog(@"mTmpAngle is %f",mTmpAngle);
        }
        [self layoutBtn];
        beginPoint=movePoint;
        speed = mStartAngle - StartAngleLast;
        NSLog(@"speed is %f",speed);
    }else if (pgr.state==UIGestureRecognizerStateEnded){
        // 计算，每秒移动的角度
        
        NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:startTouchDate];
        anglePerSecond = mTmpAngle*50/ time;
        NSLog(@"anglePerSecond is %f",anglePerSecond);
        // 如果达到该值认为是快速移动
        if (fabsf(anglePerSecond) > mFlingableValue && !_isPlaying) {
            // post一个任务，去自动滚动
            _isPlaying = true;
            flowtime = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                        target:self
                                                      selector:@selector(flowAction)
                                                      userInfo:nil
                                                       repeats:YES];
        }
    }
}

//获取当前点弧度

-(float)getAngle:(CGPoint)point {
    double x = point.x - mRadius;
    double y = point.y - mRadius;
    return (float) (asin(y / hypot(x, y)));
}

/**
 * 根据当前位置计算象限
 *
 * @param x
 * @param y
 * @return
 */
-(int) getQuadrant:(CGPoint) point {
    int tmpX = (int) (point.x - mRadius);
    int tmpY = (int) (point.y - mRadius);
    if (tmpX >= 0) {
        return tmpY >= 0 ? 1 : 4;
    } else {
        return tmpY >= 0 ? 2 : 3;
    }
}

-(void)flowAction{
    if (speed < 0.1) {
        _isPlaying = false;
        [flowtime invalidate];
        flowtime = nil;
        return;
    }
    // 不断改变mStartAngle，让其滚动，/30为了避免滚动太快
    mStartAngle += speed ;
    speed = speed/1.1;
    // 逐渐减小这个值
    //    anglePerSecond /= 1.1;
    [self layoutBtn];
}

-(void)subViewOut:(UIButton *)button
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(ADRotateView:didSelectedItem:)]) {
        [self.delegate ADRotateView:self didSelectedItem:button];
    }

}

@end
