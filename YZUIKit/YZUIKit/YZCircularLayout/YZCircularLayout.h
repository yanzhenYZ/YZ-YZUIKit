//
//  YZCircularLayout.h
//
//  Created by yanzhen.
//

#import <UIKit/UIKit.h>

@interface YZCircularLayout : UICollectionViewLayout

/**
 * @brief 环形布局(just for one section)
 *
 * @param itemSize     每一个cell的大小
 * @param radius       环形布局的半径(圆心:collectionView.center)
 * @param angle        cell会随机顺时针或者逆时针旋转(0~angle)
 *
 * @return YZCircularLayout
 */
- (instancetype)initWithItemSzie:(CGSize)itemSize radius:(CGFloat)radius angle:(CGFloat)angle;
@end
