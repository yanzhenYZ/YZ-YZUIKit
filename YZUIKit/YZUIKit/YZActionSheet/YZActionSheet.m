//
//  YZActionSheet.h
//  YZActionSheet
//
//  Created by yanzhen.
//

#import "YZActionSheet.h"

#define YZColor(R,G,B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1]
@implementation YZActionSheetItem
- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)titleColor font:(CGFloat)titleFont{
    if (self = [super init]) {
        _title = title;
        _titleColor = titleColor;
        _titleFont = titleFont;
    }
    return self;
}
@end

@interface YZActionSheet ()
@property (nonatomic, strong) YZActionSheetItem *titleItem;
@property (nonatomic, strong) YZActionSheetItem *cancelItem;
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) void (^selectedBlock)(NSInteger index);
@end

@implementation YZActionSheet

-(instancetype)initWithTitle:(YZActionSheetItem *)titleItem cancelItem:(YZActionSheetItem *)cancelItem actionItems:(NSArray<YZActionSheetItem *> *)itemsArray didSelect:(void (^)(NSInteger))selected{
    self = [super init];
    if (self) {
        _titleItem = titleItem;
        _cancelItem = cancelItem;
        _itemsArray = itemsArray;
        _selectedBlock = selected;
        [self configUI];
    }
    return self;
}

- (void)showInView:(UIView *)view{
    self.backgroundColor = [UIColor clearColor];
    [self removeFromSuperview];
    UIView *showView = view;
    if (!view) {
        UIWindow *window = [[UIApplication sharedApplication] windows].lastObject;
        showView = window;
    }
    self.frame = CGRectMake(0, 0, showView.frame.size.width, showView.frame.size.height);
    _backView.frame = CGRectMake(0, self.frame.size.height, 0, 0);
    [self resetFrame];
    [showView addSubview:self];
    [self show];
}

- (void)show{
    CGFloat duration = _showDuration > 0 ? _showDuration : 0.5;
    [UIView animateWithDuration:duration animations:^{
        _backView.frame = CGRectMake(0, self.frame.size.height - _backView.frame.size.height, self.frame.size.width, _backView.frame.size.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }];
}

- (void)dismiss{
    self.backgroundColor = [UIColor clearColor];
    CGFloat duration = _dismissDuration > 0 ? _dismissDuration : 0.25;
    [UIView animateWithDuration:duration animations:^{
        _backView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, _backView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)btnAction:(UIButton *)btn{
    if (_selectedBlock) {
        _selectedBlock(btn.tag - 100);
    }
    [self dismiss];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

#pragma mark - UI
- (void)configUI{
    self.backgroundColor = [UIColor clearColor];
    _backView = [[UIView alloc] init];
    _backView.clipsToBounds = YES;
    _backView.backgroundColor = YZColor(229, 229, 231);
    [self addSubview:_backView];
    //取消
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    cancel.backgroundColor = [UIColor whiteColor];
    cancel.tag = 100;
    [cancel setTitle:_cancelItem.title ? _cancelItem.title : @"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:_cancelItem.titleColor ? _cancelItem.titleColor : YZColor(22, 22, 22) forState:UIControlStateNormal];
    CGFloat font = _cancelItem.titleFont > 0 ? _cancelItem.titleFont : 18.0;
    cancel.titleLabel.font = [UIFont systemFontOfSize:font];
    [cancel addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:cancel];
    //item
    for (int i = 0; i < _itemsArray.count; i++) {
        YZActionSheetItem *item = _itemsArray[i];
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        itemBtn.backgroundColor = [UIColor whiteColor];
        itemBtn.tag = 101 + i;
        [itemBtn setTitle:item.title ? item.title : @"未命名" forState:UIControlStateNormal];
        [itemBtn setTitleColor:item.titleColor ? item.titleColor : YZColor(222, 63, 65) forState:UIControlStateNormal];
        CGFloat font = item.titleFont > 0 ? item.titleFont : 18.0;
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:font];
        [itemBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:itemBtn];
    }
    //title
    if (_titleItem) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor whiteColor];
        label.text = _titleItem.title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = _titleItem.titleColor ? _titleItem.titleColor : YZColor(147, 148, 149);
        label.font = [UIFont systemFontOfSize:_titleItem.titleFont > 0 ? _titleItem.titleFont : 15.0];
        label.tag = 1000;
        [_backView addSubview:label];
    }
}

- (void)resetFrame{
    CGFloat width = self.frame.size.width;
    CGFloat backViewHeight = 50 + 5 + 50.5 * _itemsArray.count;
    if (_titleItem) {
        backViewHeight += (1 + 60);
        UILabel *label = (UILabel *)[_backView viewWithTag:1000];
        label.frame = CGRectMake(0, 0, width, 60);
    }
    _backView.frame = CGRectMake(0, _backView.frame.origin.y, width, backViewHeight);
    //
    UIButton *cancel = (UIButton *)[_backView viewWithTag:100];
    cancel.frame = CGRectMake(0, backViewHeight - 50, width, 50);
    //
    for (int i = 0; i < _itemsArray.count; i++) {
        UIButton *itemBtn = (UIButton *)[_backView viewWithTag:101 + i];
        itemBtn.frame = CGRectMake(0, backViewHeight - 55 - 50.5 * (i + 1), width, 50);
    }
}
@end
