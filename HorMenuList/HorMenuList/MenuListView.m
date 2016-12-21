//
//  MenuListView.m
//  HorMenuList
//
//  Created by ZSXJ on 2016/12/21.
//  Copyright © 2016年 WYJ. All rights reserved.
//

#import "MenuListView.h"

@implementation MenuListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setButtonProperty:(UIButton *)button {
    [button setTitleColor:[UIColor greenColor] forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
    button.tintColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
}

@end
