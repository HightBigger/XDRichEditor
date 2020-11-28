//
//  XDColorSlider.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/26.
//

#import "XDColorSlider.h"
#import "UIImage+XDExtension.h"

@interface XDColorSlider()

@property (nonatomic, strong) UIView *indicator;

@property (nonatomic, strong) NSLayoutConstraint *indicatorTopConstraint;

@end

@implementation XDColorSlider

- (void)drawRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@(0.0),@(1.0),@(1.0),nil];
    CGImageRef image = [UIImage imageWithHSV:array barComponentIndex:InfComponentIndexHue].CGImage;
    if (image)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextDrawImage(ctx, rect, image);
        CGImageRelease(image);
        
        [self indicator];
        CGFloat y = _hvalue * CGRectGetHeight(self.frame);
        _indicatorTopConstraint.constant = y - CGRectGetHeight(self.indicator.frame)/2;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.allObjects.firstObject;
    [self indcatorViewWithTouch:touch];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
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
        
        self.hvalue = (constant + CGRectGetHeight(self.indicator.bounds)/2) / CGRectGetHeight(self.bounds);
        
        //颜色 回调
        if (_ColorChangedBlock) {
            _ColorChangedBlock([UIColor colorWithHue:_hvalue saturation:1.0 brightness:1.0 alpha:1.0]);
        }
        //hvalue 回调
        if (_ValueChangedBlock) {
            _ValueChangedBlock(_hvalue);
        }
    }
}

#pragma mark - get/set
- (UIView *)indicator
{
    if (!_indicator)
    {
        _indicator = [[UIView alloc] init];
        _indicator.translatesAutoresizingMaskIntoConstraints = NO;
        _indicator.backgroundColor = [UIColor clearColor];
        _indicator.layer.borderWidth = 1.5;
        _indicator.layer.borderColor = [UIColor blackColor].CGColor;
        _indicator.layer.cornerRadius = 2;
        
        [self addSubview:_indicator];
        [_indicator.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        [_indicator.heightAnchor constraintEqualToConstant:6].active = YES;
        [_indicator.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        _indicatorTopConstraint = [_indicator.topAnchor constraintEqualToAnchor:self.topAnchor constant:0];
        _indicatorTopConstraint.active = YES;
    }
    return _indicator;
}


@end
