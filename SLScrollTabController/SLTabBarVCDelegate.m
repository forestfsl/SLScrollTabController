//
//  SLTabBarVCDelegate.m
//  SLScrollTabController
//
//  Created by songlin on 2016/12/30.
//  Copyright © 2016年 songlin. All rights reserved.
//

#import "SLTabBarVCDelegate.h"
#import "SlideAnimationController.h"

@implementation SLTabBarVCDelegate

-(instancetype)init {
    if (self = [super init]) {
        _interactive = false;
        _interactionController = [[UIPercentDrivenInteractiveTransition alloc]init];
    }
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    CGFloat fromIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    CGFloat toIndex = [tabBarController.viewControllers indexOfObject:toVC];
    NSUInteger tabChangeDirection = toIndex < fromIndex ? TransitionTypeLeft : TransitionTypeRight;
    SlideAnimationController *slideAnimationController = [[SlideAnimationController alloc]init];
    slideAnimationController.transitionType = tabChangeDirection;
    return slideAnimationController;
}

-(id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return _interactive ? _interactionController : nil;
}

@end
