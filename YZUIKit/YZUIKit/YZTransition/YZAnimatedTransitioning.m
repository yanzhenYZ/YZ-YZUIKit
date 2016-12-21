//
//  YZTransition.h
//  YZTransition
//
//  Created by yanzhen.
//

#import "YZAnimatedTransitioning.h"

@interface YZAnimatedTransitioning ()

@property (nonatomic, assign) YZTransitionType type;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) Rotation rotation;

@end

@implementation YZAnimatedTransitioning

- (instancetype)initWithTransitionType:(YZTransitionType)type rotation:(Rotation)rotation duration:(CGFloat)duration{
    if (self = [super init]) {
        _type = type;
        _rotation = rotation;
        _duration = duration;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case YZTransitionTypeSystem:
            [self fromUpOrBottom:NO Context:transitionContext];
            break;
        case YZTransitionTypeFromUp:
            [self fromUpOrBottom:YES Context:transitionContext];;
            break;
        case YZTransitionTypeFromLeft:
            [self fromLeftOrRight:YES Context:transitionContext];
            break;
        case YZTransitionTypeFromRight:
            [self fromLeftOrRight:NO Context:transitionContext];
            break;
        case YZTransitionTypeCustom:
            [self custom:transitionContext];
            break;
        default:
            break;
    }
}

- (void)fromUpOrBottom:(BOOL)up Context:(id <UIViewControllerContextTransitioning>)transitionContext
{
    CGFloat h = up ? -1 : 1;
    if (self.presented) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame = CGRectMake(0, h * toView.frame.size.height, toView.frame.size.width, toView.frame.size.height);
        [UIView animateWithDuration:_duration animations:^{
            toView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        [UIView animateWithDuration:_duration animations:^{
            UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            fromView.frame = CGRectMake(0, h * fromView.frame.size.height, fromView.frame.size.width, fromView.frame.size.height);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

- (void)fromLeftOrRight:(BOOL)left Context:(id <UIViewControllerContextTransitioning>)transitionContext{
    CGFloat w = left ? -1 : 1;
    if (self.presented) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame = CGRectMake(w * toView.frame.size.width, 0, toView.frame.size.width, toView.frame.size.height);
        [UIView animateWithDuration:_duration animations:^{
            toView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        [UIView animateWithDuration:_duration animations:^{
            UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            fromView.frame = CGRectMake(w * fromView.frame.size.width, 0, fromView.frame.size.width, fromView.frame.size.height);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

- (void)custom:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (self.presented) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.layer.transform = CATransform3DMakeRotation(_rotation.angle, _rotation.x, _rotation.y, _rotation.z);
        [UIView animateWithDuration:_duration animations:^{
            toView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        [UIView animateWithDuration:_duration animations:^{
            UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            fromView.layer.transform = CATransform3DMakeRotation(_rotation.angle, _rotation.x, _rotation.y, _rotation.z);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
