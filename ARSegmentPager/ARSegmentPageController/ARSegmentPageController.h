//
//  ARSegmentPageController.h
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentPageControllerHeaderProtocol.h"
#import "ARSegmentControllerDelegate.h"
#import "ARSegmentPageHeader.h"
#import "ARSegmentView.h"

@interface ARSegmentPageController : UIViewController
@property (nonatomic, strong) UIView<ARSegmentPageControllerHeaderProtocol> *headerView;
@property (nonatomic, weak) UIViewController<ARSegmentControllerDelegate> *currentDisplayController;
@property (nonatomic, strong) ARSegmentView *segmentView;
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, assign) CGFloat segmentToInset;
@property (nonatomic, assign) CGFloat segmentMiniTopInset;
@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) NSLayoutConstraint *headerHeightConstraint;

-(instancetype)initWithControllers:(UIViewController<ARSegmentControllerDelegate> *)controller,... NS_REQUIRES_NIL_TERMINATION;
-(void)setViewControllers:(NSArray *)viewControllers;
-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView;

@end
