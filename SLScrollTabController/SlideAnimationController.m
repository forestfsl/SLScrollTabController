//
//  SlideAnimationController.m
//  SLScrollTabController
//
//  Created by songlin on 2016/12/30.
//  Copyright © 2016年 songlin. All rights reserved.
//

#import "SlideAnimationController.h"

@implementation SlideAnimationController


/*
 在 UITabBarController 的转场里，如果你在动画控制器里实现了 animationEnded: 方法，这个方法会被调用2次。
 而在 NavigationController 和 Modal 转场里没有这种问题，观察函数帧栈也发现比前两种转场多了一次私有函数调用：
 [UITabBarController transitionFromViewController:toViewController:transition:shouldSetSelected:]
 该方法和 UIViewController 的 transitionFromViewController:toViewController:duration:options:animations:completion:
 方法应该是一脉相承的，用于控制器的转换，我在文章里实现自定义容器控制器转场时也用过这个方法来实现自定义转场，不过由于测试不完整我在文章里将这块删掉了。
 
 */
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    CGFloat translation = containerView.frame.size.width;
    CGAffineTransform toViewTransform = CGAffineTransformIdentity;
    CGAffineTransform fromViewTransorm = CGAffineTransformIdentity;
    
    switch (_transitionType) {
        case TransitionTypePush:
        case TransitionTypeRight:
            toViewTransform = CGAffineTransformMakeTranslation(translation, 0);
            fromViewTransorm = CGAffineTransformMakeTranslation(-translation, 0);
            break;
        case TransitionTypePop:
        case TransitionTypeLeft:
            toViewTransform = CGAffineTransformMakeTranslation(-translation, 0);
            fromViewTransorm = CGAffineTransformMakeTranslation(translation, 0);
            break;
        case TransitionTypePresentation:
            translation = containerView.frame.size.height;
            toViewTransform = CGAffineTransformMakeTranslation(0, translation);
            fromViewTransorm = CGAffineTransformMakeTranslation(0, 0);
            break;
        case TransitionTypeDismisssal:
            translation = containerView.frame.size.height;
            toViewTransform = CGAffineTransformMakeTranslation(0, 0);
            fromViewTransorm = CGAffineTransformMakeTranslation(0, translation);
        default:
            break;
    }
    
    switch (_transitionType) {
        case TransitionTypePresentation:
            [containerView addSubview:toView];
            break;
        case TransitionTypeDismisssal:
            break;
        default:
             [containerView addSubview:toView];
            break;
    }
    
    toView.transform = toViewTransform;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.transform = fromViewTransorm;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformIdentity;
        BOOL isCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!isCancelled];
    }];
}
@end
