//
//  YZTransition.h
//  YZTransition
//
//  Created by yanzhen.
//

#import "YZPresentationController.h"

@implementation YZPresentationController
//- (CGRect)frameOfPresentedViewInContainerView
//{
//    return CGRectInset(self.containerView.bounds, 0, 100);
//}

- (void)presentationTransitionWillBegin
{
    self.presentedView.frame = self.containerView.bounds;
    [self.containerView addSubview:self.presentedView];
    
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    
}

- (void)dismissalTransitionWillBegin
{
    
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    //???
    [self.presentedView removeFromSuperview];
}
@end
