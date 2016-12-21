//
//  Hor_M_L_ScrollView.m
//  Test2
//
//  Created by ZSXJ on 2016/12/20.
//  Copyright © 2016年 WYJ. All rights reserved.
//

#import "Hor_M_L_ScrollView.h"

@interface Hor_M_L_ScrollView ()<UIScrollViewDelegate>
{
    NSArray *titleArray;
    
    id target;
    SEL action;
    
    NSInteger currentIndex;//表示显示第几个
    CGFloat oneW;//每个button的宽度
}

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *lineView;

@end

@implementation Hor_M_L_ScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 用来设置默认的
-(void)seletDefaultIndex:(NSInteger)btIndex {
    currentIndex = btIndex;
}
//设置button的宽度
-(void)setOneButtonWidth:(CGFloat)width {
    oneW = width;
}

#pragma mark 设置button属性
-(void)setButtonProperty:(UIButton *)button {
    [button setTitleColor:[UIColor greenColor] forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
    button.tintColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
}

#pragma mark -

-(instancetype)initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        currentIndex = -1;
        oneW = 60;
        
        titleArray = [NSArray arrayWithArray:array];
        [self addAllButton];
    }
    
    return self;
}

-(void)addAllButton {
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:_lineView];
    
    NSUInteger count = titleArray.count;
    for (int i = 0; i < count; i ++) {
        UIButton *button =[UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setTitle:titleArray[i] forState:(UIControlStateNormal)];
        [self setButtonProperty:button];
        [_scrollView addSubview:button];
        button.tag = 100 + i;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

-(void)layoutSubviews {
    
    CGFloat h = self.bounds.size.height;
    CGFloat w = self.bounds.size.width;
    
    _scrollView.frame = self.bounds;
    //button宽度一般
    _lineView.frame = CGRectMake(0, h-1, 0, 1);
    NSUInteger count = titleArray.count;
    
    _scrollView.contentSize = CGSizeMake(oneW * count, h);
    
    
    for (int i = 0; i < count; ++i) {
        // 先N等分  然后每一等份中 在设置一半居中
        UIButton *button = [_scrollView viewWithTag:100 + i];
        CGFloat x = i * oneW;
        button.frame = CGRectMake(x, 0, oneW, h);
        
        if (i == currentIndex) {
            //默认下 展示第几个 第一次需要在此调用 否则lineView没有效果
            [self buttonAction:button];
        }
    }
}

#pragma mark - button响应需要触发的方法
-(void)setTarget:(id)btTarget action:(SEL)btAction {
    target = btTarget;
    action = btAction;
}

#pragma mark button点击响应
-(void)buttonAction:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    sender.selected = YES;
    
    if (currentIndex != index) {
        if (currentIndex >= 0) {
            UIButton *lastButton = [self viewWithTag:100 + currentIndex];
            lastButton.selected = NO;
        }
        currentIndex = index;
    }
    
    /*
     需要优化 当滑动scrollView 时 当前的lineView不需要移动的时候 目前会快速移动闪回 
     或者先不使用动画
     
     */
    
    CGFloat lineXSpace = _lineView.frame.origin.x - _scrollView.contentOffset.x;
    
    [self moveButton:sender.frame index:index];
    
    CGFloat newLineX = sender.frame.origin.x + sender.frame.size.width/4;
    CGFloat newLineXSpace = newLineX - _scrollView.contentOffset.x;
    BOOL animation = YES;
    if (newLineXSpace - lineXSpace < 0.001 || newLineXSpace - lineXSpace > -0.001) {
       //位置不变 不需要动画
        animation = NO;
    }
    
    [self setLineViewLocation:sender.frame isAnimation:animation];
    
    if (target && [target respondsToSelector:action]) {
        NSString *currentIndexStr = [NSString stringWithFormat:@"%d",currentIndex];
        [target performSelector:action withObject:currentIndexStr];
    }
}

#pragma mark - 下划线的位置
-(void)setLineViewLocation:(CGRect)btFrame isAnimation:(BOOL)animation{
    //因为lineView是button的宽度一半 并且剧中
    CGFloat x = btFrame.origin.x + btFrame.size.width/4;
    CGFloat y = _scrollView.frame.size.height - 1;
    CGFloat w = btFrame.size.width/2;
    CGFloat h = 1;
    
    //先设置的srollView 然后可以根据偏移量与当前line的frame判读 是否需要动画
    
    if (animation) {
        [UIView animateWithDuration:0.25 animations:^{
            _lineView.frame = CGRectMake(x, y, w, h);
        } completion:nil];
    }else {
        _lineView.frame = CGRectMake(x, y, w, h);
    }
}

#pragma mark - 当前选择的button左边还有或者右边还有，自动展示左边或右边的
-(void)moveButton:(CGRect)btFrame index: (NSInteger)btIndex{
    CGFloat offx = _scrollView.contentOffset.x;
    
    //最左边
    if (btIndex == 0) {
        _scrollView.contentOffset = CGPointMake(0, 0);
        return;
    }
    
    if (btIndex > 0 && btIndex < titleArray.count - 1) {
        //左边
        //看看左边是否全部展示在里面 在便宜外 则放在最左边
        CGFloat lastBtx = (btIndex - 1)*btFrame.size.width;
        if (lastBtx < offx) {
            _scrollView.contentOffset = CGPointMake(lastBtx, 0);
            
            return;
        }
        
        //右边  看看下一个是否能展示全
        
        CGFloat nextBtX =  CGRectGetMaxX(btFrame);
        
        CGFloat right_up_limit = self.bounds.size.width - btFrame.size.width;
        
        //下一个处于不完全展示中
        if (nextBtX - right_up_limit > offx) {
            //
            _scrollView.contentOffset = CGPointMake(nextBtX + btFrame.size.width - self.bounds.size.width, 0);
            return;
        };
    }
    
    //最后一个
    if (btIndex == titleArray.count - 1) {
        CGFloat currentBtMax =  CGRectGetMaxX(btFrame);
        _scrollView.contentOffset = CGPointMake(currentBtMax - self.bounds.size.width, 0);
        
        return;
    }
}


@end
