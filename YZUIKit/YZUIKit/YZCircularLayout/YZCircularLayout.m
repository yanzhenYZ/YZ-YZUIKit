//
//  YZCircularLayout.h
//
//  Created by yanzhen.
//

#import "YZCircularLayout.h"

@interface YZCircularLayout ()
@property (nonatomic) CGSize itemSzie;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat angle;
@end

@implementation YZCircularLayout

- (instancetype)initWithItemSzie:(CGSize)itemSize radius:(CGFloat)radius angle:(CGFloat)angle{
    if (self = [super init]) {
        _itemSzie = itemSize;
        _radius = radius;
        _angle = angle;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = _itemSzie;
    CGPoint center = CGPointMake(self.collectionView.frame.size.width * 0.5, self.collectionView.frame.size.height * 0.5);
    //每个item之间的弧度
    CGFloat angle = M_PI * 2 / [self.collectionView numberOfItemsInSection:indexPath.section];
    //当前item的弧度
    CGFloat currentAngle = angle * indexPath.item;
    attributes.center = CGPointMake(center.x + _radius * cosf(currentAngle), center.y - _radius * sinf(currentAngle));
    int i = arc4random() % 2 > 0 ? 1 : -1;
    attributes.transform = CGAffineTransformMakeRotation(arc4random_uniform(10) / 10.0 * _angle * i);
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attributes];
    }
    return array;
}
@end
