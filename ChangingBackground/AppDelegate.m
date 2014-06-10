//
//  AppDelegate.m
//  ChangingBackground
//
//  Created by Jeffrey Camealy on 4/15/13.
//  Copyright (c) 2013 Ora Interactive. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AppDelegate () <UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning> {
    UIWindow *window;
}
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    [window makeKeyAndVisible];
    
    FirstViewController *firstViewController = FirstViewController.new;
    UINavigationController *navigationController = [UINavigationController.alloc initWithRootViewController:firstViewController];
    [navigationController setNavigationBarHidden:YES];
	navigationController.delegate = self;
    window.rootViewController = navigationController;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    return YES;
}

#pragma mark - UINavigationControllerDelegate 

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UIColor * gradientColor;
    if ([viewController isKindOfClass:[FirstViewController class]]) {
        
        gradientColor = [UIColor colorWithRed:(22.0f /  255.0f) green:(82.0f / 255.0f) blue:(53.0f / 255.0f) alpha:1.0f];
    } else {
        
        gradientColor = [UIColor colorWithRed:(30.0f / 255.0f) green:(68.0f / 255.0f) blue:(86.0f / 255.0f) alpha:1.0f];
    }
    
    [self applyAnimatedGradientWithCenterColor:gradientColor];
}

-(void)applyAnimatedGradientWithCenterColor:(UIColor *)gradientColor {
    
    UIGraphicsBeginImageContext(window.frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    
    NSArray *colors = @[(id)gradientColor.CGColor,
                        (id)[UIColor colorWithRed:(0.0f / 255.0f) green:(0.0f / 255.0f) blue:(0.0f / 255.0f) alpha:1.0f].CGColor];
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColors(colorspace,
                                          (CFArrayRef)colors, NULL);
    
    CGPoint startPoint, endPoint;
    CGFloat startRadius, endRadius;
    startPoint.x = 330;
    startPoint.y = 90;
    endPoint.x = 200;
    endPoint.y = 200;
    startRadius = 0;
    endRadius = 375;
    
    CGContextDrawRadialGradient (context, gradient, startPoint,
                                 startRadius, endPoint, endRadius,
                                 0);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:1.0f];
    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    animation.type = kCATransitionFade;
    [window.layer addAnimation:animation forKey:@"backgroundColor"];
    window.backgroundColor = [UIColor colorWithPatternImage:image];
    window.userInteractionEnabled = NO;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    window.userInteractionEnabled = YES;
}

#pragma mark - Animated Transitioning

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect boundsWindows = window.bounds;
    
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:toViewController.view];
    
    if ([fromViewController isKindOfClass:[FirstViewController class]]) {
        
        fromViewController.view.frame = CGRectMake(0, 0, boundsWindows.size.width, boundsWindows.size.height);
        toViewController.view.frame = CGRectMake(boundsWindows.size.width, 0, boundsWindows.size.width, boundsWindows.size.height);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             fromViewController.view.frame = CGRectMake(-boundsWindows.size.width, 0, boundsWindows.size.width, boundsWindows.size.height);
                             toViewController.view.frame = CGRectMake(0, 0, boundsWindows.size.width, boundsWindows.size.height);
                             fromViewController.view.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                             fromViewController.view.alpha = 1.0f;
                         }];
    } else {
        
        fromViewController.view.frame = CGRectMake(0, 0, boundsWindows.size.width, boundsWindows.size.height);
        toViewController.view.frame = CGRectMake(-boundsWindows.size.width, 0, boundsWindows.size.width, boundsWindows.size.height);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             fromViewController.view.frame = CGRectMake(boundsWindows.size.width, 0, boundsWindows.size.width, boundsWindows.size.height);
                             toViewController.view.frame = CGRectMake(0, 0, boundsWindows.size.width, boundsWindows.size.height);
                             fromViewController.view.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                             fromViewController.view.alpha = 1.0f;
                         }];
    }
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    return self;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    return nil;
}

@end
