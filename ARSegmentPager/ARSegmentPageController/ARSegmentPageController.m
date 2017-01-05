//
//  ARSegmentPageCon/Users/shangjin/Desktop/ARSegmentPager/ARSegmentPager/ARSegmentPageController/ARSegmentPageController.mtroller.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "ARSegmentPageController.h"

const void* _ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET = &_ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET;
@interface ARSegmentPageController ()

@end

@implementation ARSegmentPageController

#pragma mark - life cycle methods
-(instancetype)initWithControllers:(UIViewController<ARSegmentControllerDelegate> *)controller, ...
{
    self = [super init];
    if (self) {
        NSAssert(controller != nil, @"the first controller must not be nil!");
        [self _setUp];
        UIViewController<ARSegmentControllerDelegate> *eachController;
    //VA_LIST 是在C语言中解决变参问题的一组宏
//        1)首先在函数里定义一个va_list型的变量,这里是arg_ptr,这个变
//        量是指向参数的指针.
//        2)然后用va_start宏初始化变量arg_ptr,这个宏的第二个参数是第
//        一个可变参数的前一个参数,是一个固定的参数.
//        3)然后用va_arg返回可变的参数,并赋值给整数j. va_arg的第二个
//        参数是你要返回的参数的类型,这里是int型.
//        4)最后用va_end宏结束可变参数的获取.然后你就可以在函数里使
//        用第二个参数了.如果函数有多个可变参数的,依次调用va_arg获
//        取各个参数.
        va_list argumentList;
        if (controller)
        {
            [self.controllers addObject: controller];
            va_start(argumentList, controller);
            while ((eachController = va_arg(argumentList, id)))
            {
                [self.controllers addObject:eachController];
            }
            va_end(argumentList);
        }
    }
    return self;
}

//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self _setUp];
//    }
//    return self;
//}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self _setUp];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _baseConfigs];
    [self _baseLayout];
}

#pragma mark - public methods

-(void)setViewControllers:(NSArray *)viewControllers
{
    [self.controllers removeAllObjects];
    [self.controllers addObjectsFromArray:viewControllers];
}

#pragma mark - override methods

-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView
{
    return [[ARSegmentPageHeader alloc] init];
}

#pragma mark - private methdos

-(void)_setUp
{
    self.headerHeight = 200;
    self.segmentHeight = 44;
    
    self.segmentToInset = 200;
    self.segmentMiniTopInset = 0;
    self.controllers = [NSMutableArray array];
}

-(void)_baseConfigs
{
/* self.automaticallyAdjustsScrollViewInsets = NO;
    (如果你不想让scroll view的内容自动调整，将这个属性设为NO（默认值YES）)上面这个特性是IOS7中出现的viewcontroller的属性,默认是yes 它可能导致的原因就是,你在scrollview中的添加了viewA 但是你的viewA的位置总是差些像素。通过Dlog发现又是正常的，那么你就可以设为NO。就不会再出现了
*/
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self.view respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
//        这个属性默认是NO，如果把它设为YES，layoutMargins会根据屏幕中相关view的布局而改变。
        self.view.preservesSuperviewLayoutMargins = YES;
    }
//    不透明的操作栏
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.headerView = [self customHeaderView];
//    这里的clip是修剪的意思，bounds是边界的意思是，合起来就是：如果子视图的范围超出了父视图的边界，那么超出的部分就会被裁剪掉。
    self.headerView.clipsToBounds = YES;
    [self.view addSubview:self.headerView];
    
    
    self.segmentView = [[ARSegmentView alloc] init];
    [self.segmentView.segmentControl addTarget:self action:@selector(segmentControlDidChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentView];
    
    //all segment title and controllers
    [self.controllers enumerateObjectsUsingBlock:^(UIViewController<ARSegmentControllerDelegate> *controller, NSUInteger idx, BOOL *stop) {
        NSString *title = [controller segmentTitle];
        [self.segmentView.segmentControl insertSegmentWithTitle:title atIndex:idx animated:NO];
    }];
    
    //defaut at index 0
    self.segmentView.segmentControl.selectedSegmentIndex = 0;
    UIViewController<ARSegmentControllerDelegate> *controller = self.controllers[0];
    [controller willMoveToParentViewController:self];
    [self.view insertSubview:controller.view atIndex:0];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    
    [self _layoutControllerWithController:controller];
    [self addObserverForPageController:controller];
    
    self.currentDisplayController = self.controllers[0];
    
}

-(void)_baseLayout
{
    //header
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.headerHeightConstraint = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:self.headerHeight];
    [self.headerView addConstraint:self.headerHeightConstraint];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    //segment
    self.segmentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.segmentView addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:self.segmentHeight]];
}

-(void)_layoutControllerWithController:(UIViewController<ARSegmentControllerDelegate> *)pageController
{
    UIView *pageView = pageController.view;
    if ([pageView respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        pageView.preservesSuperviewLayoutMargins = YES;
    }
    pageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    UIScrollView *scrollView = [self scrollViewInPageController:pageController];
    if (scrollView) {
        scrollView.alwaysBounceVertical = YES;
        CGFloat topInset = self.headerHeight+self.segmentHeight;
        //fixed bootom tabbar inset
        CGFloat bottomInset = 0;
        if (self.tabBarController.tabBar.hidden == NO) {
            bottomInset = CGRectGetHeight(self.tabBarController.tabBar.bounds);
        }
        
        [scrollView setContentInset:UIEdgeInsetsMake(topInset, 0, bottomInset, 0)];
        //fixed first time don't show header view
//        [scrollView setContentOffset:CGPointMake(0, -self.headerHeight-self.segmentHeight)];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.segmentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:-self.segmentHeight]];
    }
    
}

-(UIScrollView *)scrollViewInPageController:(UIViewController <ARSegmentControllerDelegate> *)controller
{
    if ([controller respondsToSelector:@selector(streachScrollView)]) {
        return [controller streachScrollView];
    }else if ([controller.view isKindOfClass:[UIScrollView class]]){
        return (UIScrollView *)controller.view;
    }else{
        return nil;
    }
}

#pragma mark - add / remove obsever for page scrollView

-(void)addObserverForPageController:(UIViewController <ARSegmentControllerDelegate> *)controller
{
    UIScrollView *scrollView = [self scrollViewInPageController:controller];
    if (scrollView != nil) {
        [scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&_ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET];
    }
}

-(void)removeObseverForPageController:(UIViewController <ARSegmentControllerDelegate> *)controller
{
    UIScrollView *scrollView = [self scrollViewInPageController:controller];
    if (scrollView != nil) {
        @try {
        [scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
        }
        @catch (NSException *exception) {
            NSLog(@"exception is %@",exception);
        }
        @finally {
                
        }
    }
}

#pragma mark - obsever delegate methods

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == _ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET) {
        NSLog(@"offset: %@\nheader: %f\nmini inset = %f", change, self.headerHeightConstraint.constant, self.segmentToInset);
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat offsetY = offset.y;
        CGPoint oldOffset = [change[NSKeyValueChangeOldKey] CGPointValue];
        CGFloat oldOffsetY = oldOffset.y;
        CGFloat deltaOfOffsetY = offset.y - oldOffsetY;
        CGFloat offsetYWithSegment = offset.y + self.segmentHeight;
        
        if (deltaOfOffsetY > 0) {
            // 当滑动是向上滑动时
            // 跟随移动的偏移量进行变化
            // NOTE:直接相减有可能constant会变成负数，进而被系统强行移除，导致header悬停的位置错乱或者crash
            if (self.headerHeightConstraint.constant - deltaOfOffsetY <= 0) {
                self.headerHeightConstraint.constant = self.segmentMiniTopInset;
            } else {
                self.headerHeightConstraint.constant -= deltaOfOffsetY;
            }
            // 如果到达顶部固定区域，那么不继续滑动
            if (self.headerHeightConstraint.constant <= self.segmentMiniTopInset) {
                self.headerHeightConstraint.constant = self.segmentMiniTopInset;
            }
        } else {
            // 当向下滑动时
            // 如果列表已经滚动到屏幕上方
            // 那么保持顶部栏在顶部
            if (offsetY > 0) {
                if (self.headerHeightConstraint.constant <= self.segmentMiniTopInset) {
                    self.headerHeightConstraint.constant = self.segmentMiniTopInset;
                }
            } else {
                // 如果列表顶部已经进入屏幕
                // 如果顶部栏已经到达底部
                if (self.headerHeightConstraint.constant >= self.headerHeight) {
                    // 如果当前列表滚到了顶部栏的底部
                    // 那么顶部栏继续跟随变大，否这保持不变
                    if (-offsetYWithSegment > self.headerHeight) {
                        self.headerHeightConstraint.constant = -offsetYWithSegment;
                    } else {
                        self.headerHeightConstraint.constant = self.headerHeight;
                    }
                } else {
                    // 在顶部拦未到达底部的情况下
                    // 如果列表还没滚动到顶部栏底部，那么什么都不做
                    // 如果已经到达顶部栏底部，那么顶部栏跟随滚动
                    if (self.headerHeightConstraint.constant < -offsetYWithSegment) {
                        self.headerHeightConstraint.constant -= deltaOfOffsetY;
                    }
                }
            }
        }
        // 更新 `segmentToInset` 变量，让外部的 kvo 知道顶部栏位置的变化
        self.segmentToInset = self.headerHeightConstraint.constant;
    }
}

#pragma mark - event methods

-(void)segmentControlDidChangedValue:(UISegmentedControl *)sender
{
    //remove obsever
    [self removeObseverForPageController:self.currentDisplayController];
    
    //add new controller
    NSUInteger index = [sender selectedSegmentIndex];
    UIViewController<ARSegmentControllerDelegate> *controller = self.controllers[index];
    
    [self.currentDisplayController willMoveToParentViewController:nil];
    [self.currentDisplayController.view removeFromSuperview];
    [self.currentDisplayController removeFromParentViewController];
    [self.currentDisplayController didMoveToParentViewController:nil];
    
    [controller willMoveToParentViewController:self];
    [self.view insertSubview:controller.view atIndex:0];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    
    // reset current controller
    self.currentDisplayController = controller;
    //layout new controller
    [self _layoutControllerWithController:controller];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    
    //trigger to fixed header constraint
    UIScrollView *scrollView = [self scrollViewInPageController:controller];
    if (self.headerHeightConstraint.constant != self.headerHeight) {
        if (scrollView.contentOffset.y >= -(self.segmentHeight + self.headerHeight) && scrollView.contentOffset.y <= -self.segmentHeight) {
            [scrollView setContentOffset:CGPointMake(0, -self.segmentHeight - self.headerHeightConstraint.constant)];
        }
    }
    //add obsever
    [self addObserverForPageController:self.currentDisplayController];
}

#pragma mark - manage memory methods

-(void)dealloc
{
    [self removeObseverForPageController:self.currentDisplayController];
}

@end
