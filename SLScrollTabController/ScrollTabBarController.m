//
//  ScrollTabBarController.m
//  SLScrollTabController
//
//  Created by songlin on 2016/12/30.
//  Copyright © 2016年 songlin. All rights reserved.
//

#import "ScrollTabBarController.h"
#import "SLTabBarVCDelegate.h"


@interface ScrollTabBarController ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) SLTabBarVCDelegate *tabBarVCDelegate;
@property (nonatomic, assign) NSInteger subViewControllerCount;

@end

@implementation ScrollTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _subViewControllerCount = self.viewControllers != nil ? self.viewControllers.count : 0;
    self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:self.panGesture];
    _tabBarVCDelegate = [[SLTabBarVCDelegate alloc]init]; //要注意delegate的弱引用问题,要是弱引用的话，TabBarController的代理方法将不会执行
    self.delegate = _tabBarVCDelegate;
    self.tabBar.tintColor = [UIColor greenColor];
    
}


-(void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGFloat trannslationX = [_panGesture translationInView:self.view].x;
    CGFloat translationAbs = trannslationX > 0 ? trannslationX : - trannslationX;
    CGFloat progress = translationAbs / self.view.frame.size.width;
    
    switch (_panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            _tabBarVCDelegate.interactive = true;
            CGFloat velocity = [_panGesture velocityInView:self.view].x;
            if (velocity < 0) {
                if (self.selectedIndex < _subViewControllerCount - 1) {
                    self.selectedIndex += 1;
                }
            }else {
                if (self.selectedIndex > 0) {
                    self.selectedIndex -= 1;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            [_tabBarVCDelegate.interactionController updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            /*这里有个小问题，转场结束或是取消时有很大几率出现动画不正常的问题。在8.1以上版本的模拟器中都有发现，7.x 由于缺乏条件尚未测试，
             但在我的 iOS 9.2 的真机设备上没有发现，而且似乎只在 UITabBarController 的交互转场中发现了这个问题。在 NavigationController 暂且没发现这个问题，
             Modal 转场尚未测试，因为我在 Demo 里没给它添加交互控制功能。
             
             测试不完整，具体原因也未知，不过解决手段找到了。多谢 @llwenDeng 发现这个 Bug 并且找到了解决手段。
             解决手段是修改交互控制器的 completionSpeed 为1以下的数值，这个属性用来控制动画速度，我猜测是内部实现在边界判断上有问题。
             这里其修改为0.99，既解决了 Bug 同时尽可能贴近原来的动画设定。
             */
            if (progress > 0.3) {
                _tabBarVCDelegate.interactionController.completionSpeed = 0.99;
                [_tabBarVCDelegate.interactionController finishInteractiveTransition];
            }else {
                //转场取消后，UITabBarController 自动恢复了 selectedIndex 的值，不需要我们手动恢复。
                _tabBarVCDelegate.interactionController.completionSpeed = 0.99;
                [_tabBarVCDelegate.interactionController cancelInteractiveTransition];
            }
            _tabBarVCDelegate.interactive = false;
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
