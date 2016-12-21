//
//  YZHorizontalLayout.h
//
//  Created by yanzhen.
//

#import <UIKit/UIKit.h>

@interface YZHorizontalLayout : UICollectionViewFlowLayout
/**
 * @brief 创建一个流水布局
 *
 * @param itemSize     每一个cell的大小
 * @param scale        1 + scale * (<1)
 cell在collectionView中心位置时放大系数最大(1 + scale)
 * @param space        cell之间的间隔(default is itemSize.width * 0.5)
 *
 * @return YZHorizontalLayout
 */
- (instancetype)initWithItemSize:(CGSize)itemSize scale:(CGFloat)scale minimumLineSpacing:(CGFloat)space;
@end
