//
//  SLTabBarVCDelegate.h
//  SLScrollTabController
//
//  Created by songlin on 2016/12/30.
//  Copyright © 2016年 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLTabBarVCDelegate : NSObject<UITabBarControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;
@property (nonatomic, assign) BOOL interactive;

@end
