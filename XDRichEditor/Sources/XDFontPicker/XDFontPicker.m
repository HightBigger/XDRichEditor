//
//  XDFontPicker.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/27.
//

#import "XDFontPicker.h"
#import "XDFontSlider.h"

@interface XDFontPicker()

/// 矩形选择区域
@property(nonatomic,strong)UILabel *titleLabel;

/// slider选择区域
@property(nonatomic,strong)XDFontSlider *fontSlider;

/// 颜色预览Hex展示
@property(nonatomic,strong)UILabel *fontLabel;

/// 取消按钮
@property(nonatomic,strong)UIButton *cancelBtn;

/// 确认按钮
@property(nonatomic,strong)UIButton *sureBtn;

@end

@implementation XDFontPicker

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
    
    [self addSubview:self.titleLabel];
    [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:10].active = YES;
    [self.titleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:10].active = YES;
    [self.titleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-50-20].active = YES;
    [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-50-10].active = YES;
    
    [self addSubview:self.fontSlider];
    [self.fontSlider.topAnchor constraintEqualToAnchor:self.topAnchor constant:10].active = YES;
    [self.fontSlider.leftAnchor constraintEqualToAnchor:self.titleLabel.rightAnchor constant:10].active = YES;
    [self.fontSlider.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.fontSlider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10].active = YES;
    [self.fontSlider.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-50-10].active = YES;
    
    CGFloat w = ((pickerWidth-20)/2-10)/2;
    
    [self addSubview:self.fontLabel];
    [self.fontLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:10].active = YES;
    [self.fontLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:10].active = YES;
    [self.fontLabel.widthAnchor constraintEqualToConstant:w].active = YES;
    [self.fontLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10].active = YES;
        
    [self addSubview:self.sureBtn];
    [self.sureBtn.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:10].active = YES;
    [self.sureBtn.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10].active = YES;
    [self.sureBtn.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.sureBtn.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10].active = YES;
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:10].active = YES;
    [self.cancelBtn.rightAnchor constraintEqualToAnchor:self.sureBtn.leftAnchor constant:-10].active = YES;
    [self.cancelBtn.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.cancelBtn.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10].active = YES;
}

- (void)didClickCancelBtn:(UIButton *)sender
{
    XDSafeBlock(self.didClickCancelButton);
}

- (void)didClickSureBtn:(UIButton *)sender
{
    XDSafeBlock(self.didClickSureButton,self.titleLabel.font);
}

#pragma mark - get/set
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.text = @"这里是标题";
        _titleLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _titleLabel;
}

- (XDFontSlider *)fontSlider
{
    if (!_fontSlider)
    {
        _fontSlider = [[XDFontSlider alloc] init];
        _fontSlider.translatesAutoresizingMaskIntoConstraints = NO;
        
        _fontSlider.layer.borderWidth = 0.5;
        _fontSlider.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _fontSlider.layer.cornerRadius = 2;
        _fontSlider.backgroundColor = [UIColor whiteColor];
        _fontSlider.percent = self.percent;
        __weak typeof(self) weakSelf = self;
        [_fontSlider setPercentChangedBlock:^(CGFloat percent) {
            NSInteger fontSize = MAX(100*percent, 1);
            
            weakSelf.fontLabel.text = [NSString stringWithFormat:@"%ld",fontSize];
            weakSelf.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        }];
    }
    return _fontSlider;
}

- (UILabel *)fontLabel
{
    if (!_fontLabel)
    {
        _fontLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _fontLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _fontLabel.font = [UIFont systemFontOfSize:16.0f];
        _fontLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _fontLabel.layer.cornerRadius = 2;
        _fontLabel.layer.borderWidth = 0.5;
    }
    return _fontLabel;
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
