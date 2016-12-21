//
//  YZTransition.h
//  YZTransition
//
//  Created by yanzhen.
//

#import <Foundation/Foundation.h>
#import "YZTransition.h"

@interface YZAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL presented;

- (instancetype)initWithTransitionType:(YZTransitionType)type rotation:(Rotation)rotation duration:(CGFloat)duration;

@end
