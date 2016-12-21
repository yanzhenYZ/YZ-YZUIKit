//
//  YZCircularMenu.m
//  YZCircularMenu
//
//  Created by yanzhen.
//

#import "YZCircularMenu.h"

static CGFloat const kYZCircularMenuDefaultNearRadius = 110.0f;
static CGFloat const kYZCircularMenuDefaultEndRadius = 120.0f;
static CGFloat const kYZCircularMenuDefaultFarRadius = 140.0f;
static CGFloat const kYZCircularMenuDefaultTimeOffset = 0.036f;
static CGFloat const kYZCircularMenuDefaultRotateAngle = 0;
//没有效果
static CGFloat const kYZCircularMenuDefaultExpandRotation = M_PI;
static CGFloat const kYZCircularMenuDefaultCloseRotation = M_PI * 2;
static CGFloat const kYZCircularMenuDefaultAnimationDuration = 0.5f;
static CGFloat const kYZCircularMenuStartMenuDefaultAnimationDuration = 0.3f;

//一个点围绕某个中心点旋转的某个弧度
static CGPoint RotateCGPointAroundCenter(CGPoint point, CGPoint center, float angle)
{
    CGAffineTransform translation = CGAffineTransformMakeTranslation(center.x, center.y);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation);
    return CGPointApplyAffineTransform(point, transformGroup);
}


static inline CGRect ScaleRect(CGRect rect, float n) {return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);}

@interface YZCircularMenuItem ()

@property (nonatomic, strong) UIImageView *contentImageView;

@end

@implementation YZCircularMenuItem
-(instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)hlImage ContentImage:(UIImage *)cImage highlightedContentImage:(UIImage *)hlCImage{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = image;
        self.highlightedImage = hlImage;
        _contentImageView = [[UIImageView alloc] initWithImage:cImage];
        _contentImageView.highlightedImage = hlCImage;
        [self addSubview:_contentImageView];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [_contentImageView setHighlighted:highlighted];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    CGFloat width = _contentImageView.image.size.width;
    CGFloat height = _contentImageView.image.size.height;
    _contentImageView.frame = CGRectMake(self.bounds.size.width / 2 - width / 2, self.bounds.size.height / 2 - height / 2, width, height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    if ([_delegate respondsToSelector:@selector(yz_CircularMenuItemTouchesBegan:)])
    {
        [_delegate yz_CircularMenuItemTouchesBegan:self];
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location))
    {
        self.highlighted = NO;
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location))
    {
        if ([_delegate respondsToSelector:@selector(yz_CircularMenuItemTouchesEnd:)])
        {
            [_delegate yz_CircularMenuItemTouchesEnd:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
}
@end

#pragma mark - YZCircularMenu

@interface YZCircularMenu ()<YZCircularMenuItemDelegate>
@property (nonatomic, strong) YZCircularMenuItem *startItem;
@property (nonatomic, assign) CGFloat nearRadius;
@property (nonatomic, assign) CGFloat farRadius;
@property (nonatomic, assign) CGFloat expandRotation;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat closeRotation;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) NSInteger flag;

@end

@implementation YZCircularMenu
-(instancetype)initWithFrame:(CGRect)frame startItem:(YZCircularMenuItem *)startItem startPoint:(CGPoint)startPoint menuWholeAngle:(CGFloat)menuWholeAngle menuItems:(NSArray<YZCircularMenuItem *> *)menuItems{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.startPoint = startPoint;
        self.menuItems = menuItems;
        self.startItem = startItem;
        self.menuWholeAngle = menuWholeAngle;
        
        self.rotateAngle = kYZCircularMenuDefaultRotateAngle;
        self.expandDuration = kYZCircularMenuDefaultTimeOffset;
        self.radius = kYZCircularMenuDefaultEndRadius;
        
        self.nearRadius = kYZCircularMenuDefaultNearRadius;
        self.farRadius = kYZCircularMenuDefaultFarRadius;
        self.expandRotation = kYZCircularMenuDefaultExpandRotation;
        self.closeRotation = kYZCircularMenuDefaultCloseRotation;
        self.animationDuration = kYZCircularMenuDefaultAnimationDuration;
        
        self.rotateAddButton = YES;
        self.startItem.delegate = self;
        self.startItem.center = self.startPoint;
        [self addSubview:self.startItem];
    }
    return self;
}

- (void)open
{
    if (_isAnimating || self.expanded) {
        return;
    }
    [self setExpanded:YES];
}

- (void)close
{
    if (_isAnimating || !self.expanded) {
        return;
    }
    [self setExpanded:NO];
}


#pragma mark - YZCircularMenuItemDelegate
- (void)yz_CircularMenuItemTouchesBegan:(YZCircularMenuItem *)item
{
    if (item == self.startItem)
    {
        self.expanded = !self.expanded;
    }
}
- (void)yz_CircularMenuItemTouchesEnd:(YZCircularMenuItem *)item
{
    if (item == self.startItem)
    {
        return;
    }
    CAAnimationGroup *blowup = [self blowupAnimationAtPoint:item.center];
    [item.layer addAnimation:blowup forKey:@"blowup"];
    item.center = item.startPoint;
    
    for (int i = 0; i < [self.menuItems count]; i ++)
    {
        YZCircularMenuItem *otherItem = [self.menuItems objectAtIndex:i];
        CAAnimationGroup *shrink = [self shrinkAnimationAtPoint:otherItem.center];
        if (otherItem.tag == item.tag) {
            continue;
        }
        [otherItem.layer addAnimation:shrink forKey:@"shrink"];
        
        otherItem.center = otherItem.startPoint;
    }
    _expanded = NO;
    float angle = self.expanded ? -M_PI_4 : 0.0f;
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.startItem.transform = CGAffineTransformMakeRotation(angle);
    }];
    
    if ([_delegate respondsToSelector:@selector(yz_CircularMenu:didSelectIndex:)])
    {
        [_delegate yz_CircularMenu:self didSelectIndex:item.tag - 1000];
    }
}
#pragma mark - startItem Animation
- (void)expandAnimation
{
    
    if (_flag == [self.menuItems count])
    {
        _isAnimating = NO;
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    NSUInteger tag = 1000 + _flag;
    YZCircularMenuItem *item = (YZCircularMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:self.expandRotation],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = self.animationDuration;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.3],
                                [NSNumber numberWithFloat:.4], nil];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = self.animationDuration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = self.animationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationgroup.delegate = self;
    if(_flag == [self.menuItems count] - 1){
        [animationgroup setValue:@"firstAnimation" forKey:@"id"];
    }
    
    [item.layer addAnimation:animationgroup forKey:@"Expand"];
    item.center = item.endPoint;
    
    _flag ++;
    
}

- (void)closeAnimation
{
    if (_flag == -1)
    {
        _isAnimating = NO;
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    NSUInteger tag = 1000 + _flag;
    YZCircularMenuItem *item = (YZCircularMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:self.closeRotation],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = self.animationDuration;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.0],
                                [NSNumber numberWithFloat:.4],
                                [NSNumber numberWithFloat:.5], nil];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = self.animationDuration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = self.animationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationgroup.delegate = self;
    if(_flag == 0){
        [animationgroup setValue:@"lastAnimation" forKey:@"id"];
    }
    
    [item.layer addAnimation:animationgroup forKey:@"Close"];
    item.center = item.startPoint;
    
    _flag --;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if([[anim valueForKey:@"id"] isEqual:@"lastAnimation"]) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(yz_CircularMenuDidFinishAnimationClose:)]){
            [self.delegate yz_CircularMenuDidFinishAnimationClose:self];
        }
    }
    if([[anim valueForKey:@"id"] isEqual:@"firstAnimation"]) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(yz_CircularMenuDidFinishAnimationOpen:)]){
            [self.delegate yz_CircularMenuDidFinishAnimationOpen:self];
        }
    }
}
#pragma mark - items Animation
- (CAAnimationGroup *)blowupAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = self.animationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}

- (CAAnimationGroup *)shrinkAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = self.animationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}
#pragma mark - 响应范围
//控制响应的区域（超出自己frame之外，也可以响应）
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (_isAnimating)
    {
        return NO;
    }
    if (YES == self.expanded)
    {
        return YES;
    }
    else
    {
        return CGRectContainsPoint(self.startItem.frame, point);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //上面的方法决定了 YES == self.expanded 可以响应
    self.expanded = !self.expanded;
}

#pragma mark - set get

- (void)setMenuItems:(NSArray *)menuItems
{
    if (menuItems == _menuItems)
    {
        return;
    }
    _menuItems = [menuItems copy];
    
    
    // clean subviews
    for (UIView *v in self.subviews)
    {
        if (v.tag >= 1000)
        {
            [v removeFromSuperview];
        }
    }
}

- (void)setMenu {
    NSUInteger count = [self.menuItems count];
    for (int i = 0; i < count; i ++)
    {
        YZCircularMenuItem *item = [self.menuItems objectAtIndex:i];
        item.tag = 1000 + i;
        item.startPoint = self.startPoint;
        
        // avoid overlap
        if (self.menuWholeAngle >= M_PI * 2) {
            _menuWholeAngle = 2 * M_PI;
            self.menuWholeAngle = self.menuWholeAngle - self.menuWholeAngle / count;
        }
        //float result = sinf(yourDegree / 180 * M_PI);
        //根据半径计算位置
        CGPoint endPoint = CGPointMake(self.startPoint.x + _radius * sinf(i * self.menuWholeAngle / (count - 1)), self.startPoint.y - _radius * cosf(i * self.menuWholeAngle / (count - 1)));
        item.endPoint = RotateCGPointAroundCenter(endPoint, self.startPoint, self.rotateAngle);
        CGPoint nearPoint = CGPointMake(self.startPoint.x + self.nearRadius * sinf(i * self.menuWholeAngle / (count - 1)), self.startPoint.y - self.nearRadius * cosf(i * self.menuWholeAngle / (count - 1)));
        item.nearPoint = RotateCGPointAroundCenter(nearPoint, self.startPoint, self.rotateAngle);
        CGPoint farPoint = CGPointMake(self.startPoint.x + self.farRadius * sinf(i * self.menuWholeAngle / (count - 1)), self.startPoint.y - self.farRadius * cosf(i * self.menuWholeAngle / (count - 1)));
        item.farPoint = RotateCGPointAroundCenter(farPoint, self.startPoint, self.rotateAngle);
        item.center = item.startPoint;
        item.delegate = self;
        [self insertSubview:item belowSubview:self.startItem];
    }
}

- (BOOL)isExpanded
{
    return _expanded;
}
- (void)setExpanded:(BOOL)expanded
{
    
    if (expanded) {
        [self setMenu];
        if(self.delegate && [self.delegate respondsToSelector:@selector(yz_CircularMenuWillAnimateOpen:)]){
            [self.delegate yz_CircularMenuWillAnimateOpen:self];
        }
    } else {
        if(self.delegate && [self.delegate respondsToSelector:@selector(yz_CircularMenuWillAnimateClose:)]){
            [self.delegate yz_CircularMenuWillAnimateClose:self];
        }
    }
    
    _expanded = expanded;
    
    // rotate add button
    if (self.rotateAddButton) {
        float angle = self.expanded ? -M_PI_4 : 0.0f;
        [UIView animateWithDuration:kYZCircularMenuStartMenuDefaultAnimationDuration animations:^{
            self.startItem.transform = CGAffineTransformMakeRotation(angle);
        }];
    }
    
    // expand or close animation
    if (!_timer)
    {
        _flag = self.expanded ? 0 : ([self.menuItems count] - 1);
        SEL selector = self.expanded ? @selector(expandAnimation) : @selector(closeAnimation);
        
        // Adding timer to runloop to make sure UI event won't block the timer from firing
        _timer = [NSTimer timerWithTimeInterval:self.expandDuration target:self selector:selector userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _isAnimating = YES;
    }
}


-(void)setRadius:(CGFloat)radius{
    _radius = radius;
    _nearRadius = radius - 10;
    _farRadius = radius + 20;
}
-(void)setStartPoint:(CGPoint)startPoint{
    _startPoint = startPoint;
    _startItem.center = startPoint;
}

@end
