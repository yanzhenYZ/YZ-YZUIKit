//
//  YZHorizontalLayout.h
//
//  Created by yanzhen.
//

#import "YZHorizontalLayout.h"

@interface YZHorizontalLayout ()
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGFloat space;
@end
@implementation YZHorizontalLayout

- (instancetype)initWithItemSize:(CGSize)itemSize scale:(CGFloat)scale minimumLineSpacing:(CGFloat)space{
    if (self = [super init]) {
        _size = itemSize;
        _scale = scale;
        _space = space > 0 ? space : _size.width * 0.5;
    }
    return self;
}

/**
 *  返回YES:
 *  开始滚动就会调用
   每次调用:内部会重新调用prepareLayout和layoutAttributesForElementsInRect方法获得所有cell的布局属性
 *
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//初始化时就会调用一次
-(void)prepareLayout{
    [super prepareLayout];
    self.itemSize = _size;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //第一个和最后一个居中
    CGFloat inset = (self.collectionView.frame.size.width - _size.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.minimumLineSpacing = _space;
}

//重置cell的布局
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //当前可见的frame
    CGRect showRect = CGRectZero;
    showRect.size = self.collectionView.frame.size;
    showRect.origin = self.collectionView.contentOffset;
    
    //取得cell默认的UICollectionViewLayoutAttributes
    NSArray *originArray = [super layoutAttributesForElementsInRect:showRect];
    NSArray *array = [[NSArray alloc] initWithArray:originArray copyItems:YES];
    // 计算屏幕最中间的x
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    //距离中心店开始缩放的距离
    CGFloat activeDistance = self.collectionView.frame.size.width * 0.5 - 10;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        //在可见范围内
        if (CGRectIntersectsRect(showRect, attributes.frame)){
            // 每一个item的中点x
            CGFloat itemCenterX = attributes.center.x;
            // 距离中心点越近放大倍数越大
            CGFloat scale = 1 + _scale * (1 - (ABS(itemCenterX - centerX) / activeDistance));
            scale = scale < 1 ? 1 : scale;
            attributes.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    return array;
}

/**
 *  用来设置collectionView停止滚动那一刻的位置
 *
 *  @param proposedContentOffset  原本collectionView停止滚动那一刻的位置
 *  @param velocity               滚动速度
 *
 *  @return collectionView停止滚动那一刻的位置
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //collectionView最后会停留的范围
    CGRect stopRect;
    stopRect.origin = proposedContentOffset;
    stopRect.size = self.collectionView.frame.size;
    
    // 计算屏幕最中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    // 取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:stopRect];
    
    //遍历所有属性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        //获得距离中心点最近cell
        if (ABS(attributes.center.x - centerX) < ABS(adjustOffsetX)) {
            adjustOffsetX = attributes.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}
@end
