//
//  XDColorPicker.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/25.
//

#import "XDColorPicker.h"
#import "XDColorRectangleView.h"
#import "XDColorSlider.h"
#import "XDMacros.h"
#import "UIColor+XDExtension.h"



@interface XDColorPicker()

/// 矩形选择区域
@property(nonatomic,strong)XDColorRectangleView *rectangleView;

/// slider选择区域
@property(nonatomic,strong)XDColorSlider *colorSlider;

/// 颜色预览区域
@property(nonatomic,strong)UIView *previewColorView;

/// 颜色预览Hex展示
@property(nonatomic,strong)UILabel *previewColorHex;

/// 取消按钮
@property(nonatomic,strong)UIButton *cancelBtn;

/// 确认按钮
@property(nonatomic,strong)UIButton *sureBtn;

@end

@implementation XDColorPicker

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.rectangleView];
    [self.rectangleView.topAnchor constraintEqualToAnchor:self.topAnchor constant:10].active = YES;
    [self.rectangleView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:10].active = YES;
    [self.rectangleView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-50-20].active = YES;
    [self.rectangleView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-50-10].active = YES;
    
    [self addSubview:self.colorSlider];
    [self.colorSlider.topAnchor constraintEqualToAnchor:self.topAnchor constant:10].active = YES;
    [self.colorSlider.leftAnchor constraintEqualToAnchor:self.rectangleView.rightAnchor constant:10].active = YES;
    [self.colorSlider.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.colorSlider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10].active = YES;
    [self.colorSlider.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-50-10].active = YES;
    
    CGFloat w = ((pickerWidth-20)/2-10)/2;
    
    [self addSubview:self.previewColorView];
    [self.previewColorView.topAnchor constraintEqualToAnchor:self.rectangleView.bottomAnchor constant:10].active = YES;
    [self.previewColorView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:10].active = YES;
    [self.previewColorView.widthAnchor constraintEqualToConstant:w].active = YES;
    [self.previewColorView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10].active = YES;
    
    [self addSubview:self.previewColorHex];
    [self.previewColorHex.topAnchor constraintEqualToAnchor:self.rectangleView.bottomAnchor constant:10].active = YES;
    [self.previewColorHex.leftAnchor constraintEqualToAnchor:self.previewColorView.rightAnchor constant:10].active = YES;
    [self.previewColorHex.widthAnchor constraintEqualToConstant:w].active = YES;
    [self.previewColorHex.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10].active = YES;
        
    [self addSubview:self.sureBtn];
    [self.sureBtn.topAnchor constraintEqualToAnchor:self.rectangleView.bottomAnchor constant:10].active = YES;
    [self.sureBtn.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10].active = YES;
    [self.sureBtn.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.sureBtn.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10].active = YES;
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn.topAnchor constraintEqualToAnchor:self.rectangleView.bottomAnchor constant:10].active = YES;
    [self.cancelBtn.rightAnchor constraintEqualToAnchor:self.sureBtn.leftAnchor constant:-10].active = YES;
    [self.cancelBtn.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.cancelBtn.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10].active = YES;
}

#pragma mark - action
- (void)didClickCancelBtn:(UIButton *)sender
{
    XDSafeBlock(self.didClickCancelButton);
}

- (void)didClickSureBtn:(UIButton *)sender
{
    XDSafeBlock(self.didClickSureButton,self.previewColorView.backgroundColor,self.previewColorHex.text);
}

#pragma mark - Getter / Setter
- (XDColorRectangleView *)rectangleView
{
    if (!_rectangleView)
    {
        _rectangleView = [[XDColorRectangleView alloc] init];
        _rectangleView.translatesAutoresizingMaskIntoConstraints = NO;
        __weak typeof(self) weakSelf = self;
        [_rectangleView setColorChangedBlock:^(UIColor * _Nonnull color) {
            
            weakSelf.previewColorView.backgroundColor = color;
            weakSelf.previewColorHex.text = [UIColor hexStringFromColor:color];
            
        }];
    }
    return _rectangleView;
}

- (XDColorSlider *)colorSlider
{
    if (!_colorSlider)
    {
        _colorSlider = [[XDColorSlider alloc] init];
        _colorSlider.translatesAutoresizingMaskIntoConstraints = NO;
        __weak typeof(self) weakSelf = self;
        [_colorSlider setValueChangedBlock:^(CGFloat hvalue) {
            [weakSelf.rectangleView setHvalue:hvalue];
        }];
    }
    return _colorSlider;
}

- (UIView *)previewColorView
{
    if (!_previewColorView)
    {
        _previewColorView = [[UIView alloc] init];
        _previewColorView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _previewColorView;
}

- (UILabel *)previewColorHex
{
    if (!_previewColorHex)
    {
        _previewColorHex = [[UILabel alloc] init];
        _previewColorHex.translatesAutoresizingMaskIntoConstraints = NO;
        _previewColorHex.font = [UIFont systemFontOfSize:15];
        _previewColorHex.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _previewColorHex.layer.cornerRadius = 2;
        _previewColorHex.layer.borderWidth = 0.5;
        _previewColorHex.textColor = [UIColor lightGrayColor];
    }
    return _previewColorHex;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn)
    {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _cancelBtn.layer.cornerRadius = 2;
        _cancelBtn.layer.borderWidth = 0.5;
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn)
    {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_sureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(didClickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _sureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _sureBtn.layer.cornerRadius = 2;
        _sureBtn.layer.borderWidth = 0.5;
    }
    return _sureBtn;
}


@end
