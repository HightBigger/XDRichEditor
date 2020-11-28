//
//  XDRichInputAccessoryView.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/10/28.
//

#import "XDRichInputAccessoryView.h"
#import "XDMacros.h"
#import "UIColor+XDExtension.h"

@interface XDRichItem : UIButton
@property (nonatomic, assign) XDRichTextInputType inputType;
@end

@implementation XDRichItem
@end

@interface XDRichInputAccessoryView()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) NSArray *itemTypes;
@property (nonatomic, strong) UIView *keyboardBtnCropper;

@property (nonatomic, strong) UIScrollView *toolBarScroll;
@property (nonatomic, strong) NSLayoutConstraint *toolBarWidhtConstraint;

@end
    
@implementation XDRichInputAccessoryView

+ (XDRichInputAccessoryView *)inputAccessoryViewWithItemTypes:(NSArray *)itemTypes
{
    return [[XDRichInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, 0, 44) itemTypes:itemTypes];
}

- (instancetype)initWithFrame:(CGRect)frame itemTypes:(NSArray *)itemTypes
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.itemTypes = itemTypes;
        
        [self setupView];
    }
    return self;
}

#pragma mark - view

- (void)setupView
{
    [self setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7" alpha:1]];
    
    float floatsortaPixel = 1.0 / [UIScreen mainScreen].scale;
    [self addSubview:self.topLine];
    [self.topLine.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.topLine.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.topLine.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.topLine.heightAnchor constraintEqualToConstant:floatsortaPixel].active = YES;
    
    [self addSubview:self.keyboardBtnCropper];
    [self.keyboardBtnCropper.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.keyboardBtnCropper.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.keyboardBtnCropper.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.keyboardBtnCropper.widthAnchor constraintEqualToConstant:44].active = YES;
    
    [self addSubview:self.toolBarScroll];
    [self.toolBarScroll.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.toolBarScroll.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.toolBarScroll.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.toolBarScroll.rightAnchor constraintEqualToAnchor:self.keyboardBtnCropper.leftAnchor].active = YES;
        
    [self setupItems];
}

- (void)layoutSubviews
{
    if (self.itemTypes.count  > 0)
    {
        CGFloat w = MAX(44*self.itemTypes.count, XDScreenWidth - 44);
        self.toolBarScroll.contentSize = CGSizeMake(w, 44);
    }
}

- (void)setupItems
{
    XDRichItem *lastbtn;
    for (NSNumber *num in self.itemTypes)
    {
        XDRichTextInputType inputType = num.intValue;
        XDRichItem *btn = [self richButtonWithRichType:inputType];
        
        [self.toolBarScroll addSubview:btn];

        [btn.topAnchor constraintEqualToAnchor:self.toolBarScroll.topAnchor].active = YES;

        if (lastbtn) {
            [btn.leftAnchor constraintEqualToAnchor:lastbtn.rightAnchor].active = YES;
        }else{
            [btn.leftAnchor constraintEqualToAnchor:self.toolBarScroll.leftAnchor].active = YES;
        }

        [btn.bottomAnchor constraintEqualToAnchor:self.toolBarScroll.bottomAnchor].active = YES;
        [btn.widthAnchor constraintEqualToConstant:44].active = YES;
        [btn.heightAnchor constraintEqualToConstant:44].active = YES;

        lastbtn = btn;
    }
    
    if (lastbtn) {
        [lastbtn.rightAnchor constraintEqualToAnchor:self.toolBarScroll.rightAnchor].active = YES;
    }
}

#pragma mark - action
- (void)dismissKeyboard:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(richInputAccessoryViewWillResgin:)]) {
        [self.delegate richInputAccessoryViewWillResgin:self];
    }
}

- (void)inputAccessoryItemAction:(XDRichItem *)sender
{
    if ([self.delegate respondsToSelector:@selector(richInputAccessoryView:didClickItemWithType:completionHandler:)]) {
        [self.delegate richInputAccessoryView:self didClickItemWithType:sender.inputType completionHandler:^(BOOL itemSelected) {
            sender.selected = itemSelected;
        }];
    }
}

#pragma mark - public
- (void)updateInputAccessoryItems:(NSArray*)itemTypes
{
    NSArray *items = self.toolBarScroll.subviews;
    for (XDRichItem *item in items)
    {
        item.selected = [itemTypes containsObject:@(item.inputType)];
    }
}

#pragma mark - private

- (XDRichItem *)richButtonWithRichType:(XDRichTextInputType)richType
{
    XDRichItem *btn = [[XDRichItem alloc] init];
    btn.inputType = richType;
    
    NSString *imageName = [self imageNameWithWithRichType:richType];
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"XDRichEditor" ofType:@"bundle"]];
    
    UIImage *image = [[UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *imageSelected = [[UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:imageSelected forState:UIControlStateSelected];
    
    [btn setTintColor:[self barButtonItemDefaultColor]];
    [btn addTarget:self action:@selector(inputAccessoryItemAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.translatesAutoresizingMaskIntoConstraints = NO;

    return btn;
}

- (NSString *)imageNameWithWithRichType:(XDRichTextInputType)richType
{
    NSString *imageName;
    switch (richType) {
        case XDRichTextInputTypeBold:
            return @"XDRichEditorbold";
        case XDRichTextInputTypeItalic:
            return @"XDRichEditoritalic";
        case XDRichTextInputTypeUnderline:
            return @"XDRichEditorunderline";
        case XDRichTextInputTypeTextColor:
            return @"XDRichEditortextcolor";
        case XDRichTextInputTypeFonts:
            return @"XDRichEditorfonts";
        case XDRichTextInputTypeInsertImage:
            return @"XDRichEditorimage";
        case XDRichTextInputTypeBackgroundColor:
            return @"XDRichEditorbgcolor";
        case XDRichTextInputTypeLink:
            return @"XDRichEditorlink";
        default:
            return nil;
    }
    
    return imageName;
}

- (UIColor *)barButtonItemDefaultColor
{
    return [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

#pragma mark - get
- (UIView *)topLine
{
    if (!_topLine)
    {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor lightGrayColor];
        _topLine.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _topLine;
}


- (UIScrollView *)toolBarScroll
{
    if (!_toolBarScroll)
    {
        _toolBarScroll = [[UIScrollView alloc] init];
        _toolBarScroll.backgroundColor = [UIColor clearColor];
        _toolBarScroll.alwaysBounceHorizontal = YES;
        _toolBarScroll.showsVerticalScrollIndicator = NO;
        _toolBarScroll.showsHorizontalScrollIndicator = NO;
        _toolBarScroll.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _toolBarScroll;
}

- (UIView *)keyboardBtnCropper
{
    if (!_keyboardBtnCropper)
    {
        _keyboardBtnCropper = [[UIView alloc] init];
        _keyboardBtnCropper.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"XDRichEditor" ofType:@"bundle"]];
        UIButton *keyboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [keyboardBtn addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [[UIImage imageNamed:@"XDRichEditorkeyboard" inBundle:bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [keyboardBtn setImage:image forState:UIControlStateNormal];
        [keyboardBtn setTintColor:[self barButtonItemDefaultColor]];

        keyboardBtn.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_keyboardBtnCropper addSubview:keyboardBtn];
        [keyboardBtn.topAnchor constraintEqualToAnchor:_keyboardBtnCropper.topAnchor].active = YES;
        [keyboardBtn.rightAnchor constraintEqualToAnchor:_keyboardBtnCropper.rightAnchor].active = YES;
        [keyboardBtn.bottomAnchor constraintEqualToAnchor:_keyboardBtnCropper.bottomAnchor].active = YES;
        [keyboardBtn.leftAnchor constraintEqualToAnchor:_keyboardBtnCropper.leftAnchor].active = YES;
        
        UIView *leftLine = [[UIView alloc] init];
        leftLine.backgroundColor = [UIColor lightGrayColor];
        leftLine.translatesAutoresizingMaskIntoConstraints = NO;
        
        float floatsortaPixel = 1.0 / [UIScreen mainScreen].scale;
        [_keyboardBtnCropper addSubview:leftLine];
        [leftLine.topAnchor constraintEqualToAnchor:_keyboardBtnCropper.topAnchor].active = YES;
        [leftLine.bottomAnchor constraintEqualToAnchor:_keyboardBtnCropper.bottomAnchor].active = YES;
        [leftLine.leftAnchor constraintEqualToAnchor:_keyboardBtnCropper.leftAnchor].active = YES;
        [leftLine.widthAnchor constraintEqualToConstant:floatsortaPixel].active = YES;
    }
    return _keyboardBtnCropper;
}

@end
