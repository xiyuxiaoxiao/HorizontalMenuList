//
//  ViewController.m
//  HorMenuList
//
//  Created by ZSXJ on 2016/12/21.
//  Copyright © 2016年 WYJ. All rights reserved.
//

#import "ViewController.h"
#import "MenuListView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *titleArray = @[@"BT0",@"BT1",@"BT2",@"BT3",@"BT4",@"BT5",@"BT6",@"BT7",@"BT8",@"BT9"];
    
    MenuListView *view = [[MenuListView alloc] initWithArray:titleArray];
    view.frame = CGRectMake(50, 100, 300, 40);
    view.backgroundColor = [UIColor whiteColor];
    [view setTarget:self action:@selector(buttonAction:)];
    [view seletDefaultIndex:6];
    [self.view addSubview:view];
    
}

-(void)buttonAction:(NSString *)index {
    NSLog(@"%@",index);
}

@end
