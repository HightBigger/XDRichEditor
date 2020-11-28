//
//  XDColorRectangleView.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/26.
//

#import "XDColorRectangleView.h"
#import "UIImage+XDExtension.h"

@interface XDColorRectangleView()

@property(nonatomic,strong)UIView *indicator;

@end

@implementation XDColorRectangleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    [self addSubview:self.indicator];
    [self setHvalue:0];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat x = _svvalue.x * CGRectGetWidth(self.bounds);
    CGFloat y = CGRectGetHeight(self.bounds) - _svvalue.y * CGRectGetHeight(self.bounds);
    self.indicator.center = CGPointMake(x, y);
    
    self.curColor = [UIColor colorWithHue:_hvalue saturation:_svvalue.x brightness:_svvalue.y  alpha:1.0];
    
    if (_colorChangedBlock) {
        _colorChangedBlock(self.curColor);
    }
}

- (void)updateContent
{
    UIImage *image = [UIImage imageWithHue:self.hvalue * 360];
    self.layer.contents = (__bridge id _Nullable)(image.CGImage);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.allObjects.firstObject;
    [self indcatorViewWithTouch:touch];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.allObjects.firstObject;
    [self indcatorViewWithTouch:touch];
}

- (void)indcatorViewWithTouch:(UITouch *)touch {
    if (touch) {
        CGPoint p = [touch locationInView:self];
        CGFloat w = CGRectGetWidth(self.bounds);
        CGFloat h = CGRectGetHeight(self.bounds);
        if (p.x < 0) {
            p.x = 0;
        }
        if (p.x > w) {
            p.x = w;
        }
        if (p.y < 0) {
            p.y = 0;
        }
        if (p.y > h) {
            p.y = h;
        }
        _svvalue = CGPointMake(p.x / w, 1.0 - p.y / h);
        [self setNeedsLayout];
    }
}

#pragma mark - Getter / Setter
- (void)setHvalue:(CGFloat)hvalue
{
    if (hvalue > 1) {
        hvalue = 1;
    }
    if (hvalue < 0) {
        hvalue = 0;
    }
    _hvalue = hvalue;
    [self updateContent];
    [self setNeedsLayout];
}

-(void)setSvvalue:(CGPoint)svvalue{
    if (!CGPointEqualToPoint(_svvalue, svvalue)) {
        _svvalue = svvalue;
        [self setNeedsLayout];
    }
}

- (UIView *)indicator
{
    if (!_indicator)
    {
        _indicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _indicator.backgroundColor = [UIColor clearColor];
        _indicator.layer.borderWidth = 1.5;
        _indicator.layer.borderColor = [UIColor whiteColor].CGColor;
        _indicator.layer.cornerRadius = 9;
    }
    return _indicator;
}

@end
