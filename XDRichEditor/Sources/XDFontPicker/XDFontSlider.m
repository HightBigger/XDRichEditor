//
//  XDFontSlider.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/27.
//

#import "XDFontSlider.h"

@interface XDFontSlider()

@property (nonatomic, strong) UIView *indicator;

@property (nonatomic, strong) NSLayoutConstraint *indicatorTopConstraint;

@end

@implementation XDFontSlider

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addSubview:self.indicator];
        [self.indicator.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        [self.indicator.heightAnchor constraintEqualToConstant:6].active = YES;
        [self.indicator.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        self.indicatorTopConstraint = [self.indicator.topAnchor constraintEqualToAnchor:self.topAnchor constant:0];
        self.indicatorTopConstraint.active = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.percent = 0.5;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects.firstObject;
    [self indcatorViewWithTouch:touch];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects.firstObject;
    [self indcatorViewWithTouch:touch];
}

- (void)indcatorViewWithTouch:(UITouch *)touch
{
    CGPoint p = [touch locationInView:self];
    if (p.y > 0 && p.y <= CGRectGetHeight(self.bounds))
    {
        CGFloat constant = p.y - CGRectGetHeight(self.indicator.frame)/2;
        
        _indicatorTopConstraint.constant = constant;
        
        self.percent = (constant + CGRectGetHeight(self.indicator.bounds)/2) / CGRectGetHeight(self.bounds);
        
        //percent 回调
        if (_percentChangedBlock) {
            _percentChangedBlock(self.percent);
        }
    }
}

- (void)setPercent:(CGFloat)percent
{
    _percent = percent;
    
    CGFloat h = CGRectGetHeight(self.bounds) * percent - CGRectGetHeight(self.indicator.bounds)/2;

    _indicatorTopConstraint.constant = h;
    
    //percent 回调
    if (_percentChangedBlock) {
        _percentChangedBlock(self.percent);
    }
}

#pragma mark - get/set
- (UIView *)indicator
{
    if (!_indicator)
    {
        _indicator = [[UIView alloc] init];
        _indicator.translatesAutoresizingMaskIntoConstraints = NO;
        _indicator.backgroundColor = [UIColor lightGrayColor];
        _indicator.layer.borderWidth = 1.5;
        _indicator.layer.borderColor = [UIColor blackColor].CGColor;
        _indicator.layer.cornerRadius = 2;
    }
    return _indicator;
}
@end
