//
//  CustomHeaderViewController.m
//  ARSegmentPager
//
//  Created by August on 15/5/20.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "CustomHeaderViewController.h"
#import "TableViewController.h"
#import "CollectionViewController.h"
//#import "UIImage+ImageEffects.h"
#import "CustomHeader.h"

void *CusomHeaderInsetObserver = &CusomHeaderInsetObserver;

@interface CustomHeaderViewController ()

@end

@implementation CustomHeaderViewController

-(instancetype)init
{
    TableViewController *table = [[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil];
    CollectionViewController *collectionView = [[CollectionViewController alloc] initWithNibName:@"CollectionViewController" bundle:nil];
    

    self = [super initWithControllers:table,collectionView, nil];
    if (self) {
        // your code
        self.segmentMiniTopInset = 64;
    }
    
    return self;
}

#pragma mark - override 

-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView
{
    CustomHeader *view = [[[NSBundle mainBundle] loadNibNamed:@"CustomHeader" owner:nil options:nil] lastObject];
//    view.backgroundColor = [UIColor redColor];
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addObserver:self forKeyPath:@"segmentToInset" options:NSKeyValueObservingOptionNew context:CusomHeaderInsetObserver];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if (context == CusomHeaderInsetObserver) {
        CGFloat inset = [change[NSKeyValueChangeNewKey] floatValue];
        NSLog(@"inset is %f",inset);
    }
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"segmentToInset"];
}


@end
