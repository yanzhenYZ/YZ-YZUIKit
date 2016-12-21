//
//  YZCircularMenu.m
//  YZCircularMenu
//
//  Created by yanzhen.
//

#import <UIKit/UIKit.h>

@class YZCircularMenu;
@class YZCircularMenuItem;
@protocol YZCircularMenuItemDelegate <NSObject>

- (void)yz_CircularMenuItemTouchesBegan:(YZCircularMenuItem *)item;
- (void)yz_CircularMenuItemTouchesEnd:(YZCircularMenuItem *)item;

@end

@interface YZCircularMenuItem : UIImageView
//以下属性都不需要设置
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGPoint nearPoint;
@property (nonatomic) CGPoint farPoint;
@property (nonatomic, weak) id<YZCircularMenuItemDelegate> delegate;


/**
 * @brief 创建YZCircularMenuItem对象
 *
 * @param image        自己的图片
 * @param hlImage      自己的高亮图片(可以传nil)
 * @param cImage       内部小的ImageView的图片
 * @param hlCImage     内部小的ImageView的高亮图片(可以传nil)
 *
 * @return YZCircularMenuItem对象
 */

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)hlImage ContentImage:(UIImage *)cImage highlightedContentImage:(UIImage *)hlCImage;

@end

#pragma mark - YZCircularMenu
@protocol YZCircularMenuDelegate <NSObject>

- (void)yz_CircularMenu:(YZCircularMenu *)menu didSelectIndex:(NSInteger)index;
@optional
- (void)yz_CircularMenuDidFinishAnimationClose:(YZCircularMenu *)menu;
- (void)yz_CircularMenuDidFinishAnimationOpen:(YZCircularMenu *)menu;
- (void)yz_CircularMenuWillAnimateOpen:(YZCircularMenu *)menu;
- (void)yz_CircularMenuWillAnimateClose:(YZCircularMenu *)menu;

@end

@interface YZCircularMenu : UIView
@property (nonatomic, weak) id<YZCircularMenuDelegate> delegate;
/**        所有Item                                */
@property (nonatomic, strong) NSArray *menuItems;
/**        startItem的中心坐标                      */
@property (nonatomic, assign) CGPoint startPoint;
/**        圆弧范围(不可以大于 2 * M_PI)              */
@property (nonatomic, assign) CGFloat menuWholeAngle;
/**        半径(默认120.0)                          */
@property (nonatomic, assign) CGFloat radius;
/**        展示,收起每个Item间隔时间(默认0.036)        */
@property (nonatomic, assign) CGFloat expandDuration;
/**        所有Item在原来坐标基础上旋转的弧度          */
@property (nonatomic, assign) CGFloat rotateAngle;
/**        startItem是否旋转(默认YES)                */
@property (nonatomic, assign) BOOL rotateAddButton;
/**        当前Items是否展开                         */
@property (nonatomic, assign) BOOL expanded;
//rotateAngle

/**
 * @brief 创建YZCircularMenu对象
 *
 * @param frame             坐标
 * @param startItem         开始的Item
 * @param startPoint        startItem的中心坐标
 * @param menuWholeAngle    圆弧范围(不可以大于 2 * M_PI)
 * @param menuItems         Item的数组
 *
 * @return YZCircularMenu对象
 */

- (instancetype)initWithFrame:(CGRect)frame startItem:(YZCircularMenuItem *)startItem startPoint:(CGPoint)startPoint menuWholeAngle:(CGFloat)menuWholeAngle menuItems:(NSArray <YZCircularMenuItem *> *)menuItems;

/**        展示所有的Item    */
- (void)open;
/**        关闭所有的Item    */
- (void)close;
@end
