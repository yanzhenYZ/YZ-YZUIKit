//
//  YZTransition.h
//  YZTransition
//
//  Created by yanzhen.
//

#import "YZTransition.h"
#import "YZAnimatedTransitioning.h"
#import "YZPresentationController.h"

@implementation YZTransition

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[YZPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    YZAnimatedTransitioning *animated = [[YZAnimatedTransitioning alloc] initWithTransitionType:self.type rotation:self.rotation duration:self.duration];
    animated.presented = YES;
    return animated;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    YZAnimatedTransitioning *animated = [[YZAnimatedTransitioning alloc] initWithTransitionType:self.type rotation:self.rotation duration:self.duration];
    animated.presented = NO;
    return animated;
}
#pragma mark - Get
-(Rotation)rotation{
    if (_rotation.x == 0 && _rotation.y == 0 && _rotation.z == 0 && _rotation.angle == 0) {
        _rotation.x = 1;
        _rotation.angle = M_PI_2;
    }
    return _rotation;
}

-(CGFloat)duration{
    if (_duration <= 0) {
        _duration = 0.53;
    }
    return _duration;
}

@end


