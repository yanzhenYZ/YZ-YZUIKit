//
//  YZActionSheet.h
//  YZActionSheet
//
//  Created by yanzhen.
//

#import <UIKit/UIKit.h>

@class YZActionSheet;
@interface YZActionSheetItem : NSObject

/**
 * @brief 创建YZActionSheetItem
 *
 * @param title                  标题
 * @param titleColor             标题颜色
 * @param titleFont              标题大小(可以传0)
 *
 * @return YZActionSheetItem对象
 */

- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)titleColor font:(CGFloat)titleFont;
/**     标题     */
@property (nonatomic, copy)   NSString *title;
/**     标题颜色     */
@property (nonatomic, strong) UIColor *titleColor;
/**     标题大小     */
@property (nonatomic, assign) CGFloat titleFont;
@end

#pragma mark - YZActionSheet

@interface YZActionSheet : UIView
/**
 * @brief 创建YZActionSheet
 *
 * @param titleItem              标题
 * @param cancelItem             取消(默认文字是“取消”,index = 0)
 * @param itemsArray             其他(Action) *从下往上*
 * @param selected               选中某个Item的下标的block
 *
 * @return YZActionSheet对象
 */
- (instancetype)initWithTitle:(YZActionSheetItem *)titleItem cancelItem:(YZActionSheetItem *)cancelItem actionItems:(NSArray <YZActionSheetItem *> *)itemsArray didSelect:(void (^)(NSInteger index))selected;

/**  显示在哪个view上面，传nil的话会显示在window上面  */
- (void)showInView:(UIView *)view;


/**     动画显示的时间(默认0.5)     */
@property (nonatomic, assign) CGFloat showDuration;
/**     动画消失的时间(默认0.25)     */
@property (nonatomic, assign) CGFloat dismissDuration;

@end
