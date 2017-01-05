//
//  NavigationViewController.m
//  ARSegmentPager
//
//  Created by August on 15/5/9.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               [UIFont systemFontOfSize:18],
                                               NSFontAttributeName, nil];
//    导航栏文字属性
    [self.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
//    导航栏背景图片
    [self.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
//    navigationBar 下面的黑线
    [self.navigationBar setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
//    自定义后退按钮的文字和颜色
    [self.navigationBar setTintColor:[UIColor whiteColor]];
//    如果setTranslucent=yes 默认的   则状态栏及导航栏底部为透明的，界面上的组件应该从屏幕顶部开始显示，因为是半透明的，可以看到，所以为了不和状态栏及导航栏重叠，第一个组件的y应该从44+20的位置算起
//    如果设置成no，则状态栏及导航样不为透明的，界面上的组件就是紧挨着导航栏显示了，所以就不需要让第一个组件在y方向偏离44+20的高度了
    [self.navigationBar setTranslucent:YES];
}

//颜色转变成图片
-(UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
