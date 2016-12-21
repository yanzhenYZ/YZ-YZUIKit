//
//  YZTransition.h
//  YZTransition
//
//  Created by yanzhen.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YZTransitionType) {
    YZTransitionTypeSystem = 0,          //bottom-up
    YZTransitionTypeFromUp,
    YZTransitionTypeFromLeft,
    YZTransitionTypeFromRight,
    YZTransitionTypeCustom,               //rotation
};

@interface YZTransition : NSObject<UIViewControllerTransitioningDelegate>

struct Rotation {
    CGFloat x;
    CGFloat y;
    CGFloat z;
    CGFloat angle;
};
typedef struct Rotation Rotation;

@property (nonatomic, assign) YZTransitionType type;

/* Default x = 1, y = 0, z = 0, angle = M_PI_2.
 It will make CATransform3DMakeRotation*/
@property (nonatomic) Rotation rotation;

/**   Animation time (default 0.53)   */
@property (nonatomic, assign) CGFloat duration;

@end

