//
//  SlideAnimationController.h
//  SLScrollTabController
//
//  Created by songlin on 2016/12/30.
//  Copyright © 2016年 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,TransitionType){
    TransitionTypeNone,
    TransitionTypePush,
    TransitionTypePop,
    TransitionTypeLeft,
    TransitionTypeRight,
    TransitionTypePresentation,
    TransitionTypeDismisssal
};

@interface SlideAnimationController : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) TransitionType transitionType;

@end
