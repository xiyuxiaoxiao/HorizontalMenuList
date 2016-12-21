//
//  Hor_M_L_ScrollView.h
//  Test2
//
//  Created by ZSXJ on 2016/12/20.
//  Copyright © 2016年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hor_M_L_ScrollView : UIView

-(instancetype)initWithArray:(NSArray *)array;
-(void)setTarget:(id)btTarget action:(SEL)btAction;

//设置单个的大小
-(void)seletDefaultIndex:(NSInteger)btIndex;
-(void)setOneButtonWidth:(CGFloat)width;

//子类重写
#pragma mark 设置button属性
-(void)setButtonProperty:(UIButton *)button;

@end
