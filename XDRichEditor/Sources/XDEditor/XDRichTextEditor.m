//
//  XDRichTextEditor.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/10/30.
//

#import "XDRichTextEditor.h"
#import "UIColor+XDExtension.h"
#import "XDRichInputAccessoryView.h"
#import "XDHTMLParser.h"
#import "XDMacros.h"
#import "XDRichEditorTextView.h"

static CGFloat const Editor_Italic_Rate = 0.35;

@interface XDRichTextEditor()<XDRichInputAccessoryViewDelegate,UITextViewDelegate,XDRichEditorTextViewDelegate>

@property (nonatomic, strong) XDRichEditorTextView *textView;

@property (nonatomic, strong) XDRichTextEditorConfig *config;
@property (nonatomic, strong) XDRichInputAccessoryView *richInputAccessoryView;

@property(nonatomic,assign) BOOL isBold;
@property(nonatomic,assign) BOOL isItalic;
@property(nonatomic,assign) BOOL isUnderline;
@property(nonatomic,strong) UIColor *richTextColor;
@property(nonatomic,assign) CGFloat fontSize;
@property(nonatomic,strong) UIColor *richBackgroundColor;
@property(nonatomic,copy) NSString *linkValue;

@property(nonatomic) NSRange lastSelectedRange;

/// 附件图片数组，
@property(nonatomic,strong) NSMutableArray <XDRichTextImageAttach *>*imageAttachArray;

@end

@implementation XDRichTextEditor

+ (XDRichTextEditor *)richTextEditorWithConfig:(XDRichTextEditorConfig *)config
{
    return [[self alloc] initWithConfig:config];
}

- (instancetype)initWithConfig:(XDRichTextEditorConfig *)config
{
    self = [super init];
    if (self)
    {
        self.config = config;
        self.isBold = NO;
        self.isItalic = NO;
        self.isUnderline = NO;
        self.richTextColor = [UIColor colorWithHexString:@"#333333" alpha:1];
        self.fontSize = 16;
        self.richBackgroundColor = [UIColor clearColor];
        self.linkValue = @"";
        
        self.textView.textColor = self.richTextColor;
        self.textView.font = [UIFont systemFontOfSize:self.fontSize];
        
        self.textView.textContainerInset = UIEdgeInsetsMake(10, 6, 10, 6);
        
        if (self.config.alwaysShowToolbar) {
            self.textView.inputAccessoryView = self.richInputAccessoryView;
        }
        
        [self resetTypingAttributes:XDRichTextInputTypeNone];
        
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    [self addSubview:self.textView];
    [self.textView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.textView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.textView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.textView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    [self setHtml:self.config.html];
}

#pragma mark - public
- (void)setHtml:(NSString *)html
{
    __weak typeof(self) weakSelf = self;
    
    [XDHTMLParser attributedTextWithHtmlString:html imageWidth:XDScreenWidth - 12-12 completionHandler:^(NSAttributedString * _Nullable attributedString, NSArray<XDRichTextImageAttach *> * _Nullable imageAttachs) {
        
        [weakSelf.imageAttachArray removeAllObjects];
        
        [weakSelf.imageAttachArray addObjectsFromArray:imageAttachs];
        
        weakSelf.textView.attributedText = attributedString;
        
    }];
}

- (void)getRichTextEditHtml:(void (^)(NSString *html))completionHandler
{
    [XDHTMLParser htmlStringWithAttributedText:self.textView.attributedText imageAttachArray:self.imageAttachArray completionHandler:^(NSString * _Nullable html) {
        
    }];
}

#pragma mark - action
- (void)setBoldInRange
{
    if (self.textView.selectedRange.length > 0)
    {
        NSRange range = self.textView.selectedRange;
        
        NSMutableAttributedString *attributedString = self.textView.attributedText.mutableCopy;
        [attributedString enumerateAttribute:NSFontAttributeName inRange:self.textView.selectedRange options:(NSAttributedStringEnumerationLongestEffectiveRangeNotRequired) usingBlock:^(id  _Nullable value, NSRange range0, BOOL * _Nonnull stop) {
            
            if ([value isKindOfClass:[UIFont class]]) {
                UIFont *font = value;
                //字号
                CGFloat fontSize = [font.fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute] floatValue];
                UIFont *newFont = self.isBold ? [UIFont boldSystemFontOfSize:fontSize] : [UIFont systemFontOfSize:fontSize];
                [attributedString addAttribute:NSFontAttributeName value:newFont range:range0];
            }
        }];
        
        self.textView.attributedText = attributedString.copy;
        
        self.textView.selectedRange = range;
    }
    
    [self resetTypingAttributes:XDRichTextInputTypeBold];
}

- (void)setUnderlineInRange
{
    if (self.textView.selectedRange.length > 0)
    {
        NSRange range = self.textView.selectedRange;
        
        NSMutableAttributedString *attributedString = self.textView.attributedText.mutableCopy;
        
        if (self.isUnderline == NO) {
            [attributedString removeAttribute:NSUnderlineStyleAttributeName range:self.textView.selectedRange];
            [attributedString removeAttribute:NSUnderlineColorAttributeName range:self.textView.selectedRange];
            self.textView.attributedText = attributedString.copy;
            return;
        }
        
        [attributedString enumerateAttribute:NSForegroundColorAttributeName inRange:self.textView.selectedRange options:(NSAttributedStringEnumerationLongestEffectiveRangeNotRequired) usingBlock:^(id  _Nullable value, NSRange range0, BOOL * _Nonnull stop) {
            
            if ([value isKindOfClass:[UIColor class]]) {
                UIColor *color = value;
                [attributedString addAttribute:NSUnderlineColorAttributeName value:color range:range0];
                [attributedString addAttribute:NSUnderlineStyleAttributeName value:@1 range:range0];
            }
        }];
        self.textView.attributedText = attributedString.copy;
        
        self.textView.selectedRange = range;
    }
    
    [self resetTypingAttributes:XDRichTextInputTypeUnderline];
}

- (void)setItalicInRange
{
    if (self.textView.selectedRange.length > 0)
    {
        NSRange range = self.textView.selectedRange;
        
        NSMutableAttributedString *attributedString = self.textView.attributedText.mutableCopy;
        if (self.isItalic) {
            [attributedString addAttribute:NSObliquenessAttributeName value:@(Editor_Italic_Rate) range:self.textView.selectedRange];
        } else {
            [attributedString removeAttribute:NSObliquenessAttributeName range:self.textView.selectedRange];
        }
        
        self.textView.attributedText = attributedString.copy;
        
        self.textView.selectedRange = range;
    }
    
    [self resetTypingAttributes:XDRichTextInputTypeItalic];
}

- (void)setFontInRange
{
    if (self.textView.selectedRange.length > 0)
    {
        NSRange range = self.textView.selectedRange;
        
        NSMutableAttributedString *attributedString = self.textView.attributedText.mutableCopy;
        
        UIFont *font = self.isBold ? [UIFont boldSystemFontOfSize:self.fontSize] : [UIFont systemFontOfSize:self.fontSize];
        
        [attributedString addAttribute:NSFontAttributeName value:font range:self.textView.selectedRange];
                
        self.textView.attributedText = attributedString.copy;
        
        self.textView.selectedRange = range;
    }
    
    [self resetTypingAttributes:XDRichTextInputTypeFonts];
}

- (void)setRichForegroundTextColor
{
    if (self.textView.selectedRange.length > 0)
    {
        NSRange range = self.textView.selectedRange;
        
        NSMutableAttributedString *attributedString = self.textView.attributedText.mutableCopy;
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:self.richTextColor range:self.textView.selectedRange];
                
        self.textView.attributedText = attributedString.copy;
        
        self.textView.selectedRange = range;
    }
    
    [self resetTypingAttributes:XDRichTextInputTypeTextColor];
}

- (void)setRichTextBgColor
{
    if (self.textView.selectedRange.length > 0)
    {
        NSRange range = self.textView.selectedRange;
        
        NSMutableAttributedString *attributedString = self.textView.attributedText.mutableCopy;
        
        [attributedString addAttribute:NSBackgroundColorAttributeName value:self.richBackgroundColor range:self.textView.selectedRange];
                
        self.textView.attributedText = attributedString.copy;
        
        self.textView.selectedRange = range;
    }
    [self resetTypingAttributes:XDRichTextInputTypeBackgroundColor];
}

- (void)insertImage:(NSURL *)imageURL
{
    UIImage *image = [UIImage imageWithContentsOfFile:imageURL.path];
        
    CGFloat width = self.frame.size.width-self.textView.textContainer.lineFragmentPadding*2;

    NSMutableAttributedString *mAttributedString = self.textView.attributedText.mutableCopy;

    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.bounds = CGRectMake(0, 0, width-12, width * image.size.height / image.size.width);
    
    NSFileWrapper *wrapper = [[NSFileWrapper alloc] initWithURL:imageURL options:NSFileWrapperReadingImmediate error:nil];
    attachment.fileWrapper = wrapper;

    NSMutableAttributedString *attachmentString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    [attachmentString addAttributes:[self getCurrentAttributes:XDRichTextInputTypeInsertImage] range:NSMakeRange(0, attachmentString.length)];

    [mAttributedString insertAttributedString:attachmentString atIndex:NSMaxRange(self.textView.selectedRange)];
    
    //更新attributedText
    NSInteger location = NSMaxRange(self.textView.selectedRange) + 1;
    self.textView.attributedText = mAttributedString.copy;

    //回复焦点
    self.textView.selectedRange = NSMakeRange(location, 0);
    
    [self.imageAttachArray addObject:[[XDRichTextImageAttach alloc] initWithURL:imageURL]];
    
    [self becomeFirstResponder];
}

- (void)addLinkWithValue:(NSURL *)url
{
    if (self.textView.selectedRange.length > 0)
    {
        NSRange range = self.textView.selectedRange;
        
        NSMutableAttributedString *attributedString = self.textView.attributedText.mutableCopy;
        
        [attributedString addAttribute:NSLinkAttributeName value:url range:self.textView.selectedRange];
                
        self.textView.attributedText = attributedString.copy;
        
        self.textView.selectedRange = range;
    }
}

#pragma mark - private
- (void)changeColorOfToolBarItem
{
    if ([self.textView isFirstResponder] == NO) return;
    
    NSDictionary *attrs = self.textView.typingAttributes;
    NSMutableArray *selectedItemTypes = [NSMutableArray arrayWithCapacity:0];
    
    UIFont *font = attrs[NSFontAttributeName];
    //粗体
    self.isBold = (font.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) > 0;
    if (self.isBold) {
        [selectedItemTypes addObject:@(XDRichTextInputTypeBold)];
    }
    
    //斜体
    self.isItalic = [attrs.allKeys containsObject:NSObliquenessAttributeName];
    if (self.isItalic) {
        [selectedItemTypes addObject:@(XDRichTextInputTypeItalic)];
    }
    
    //下划线
    self.isUnderline = [attrs.allKeys containsObject:NSUnderlineColorAttributeName];
    if (self.isUnderline) {
        [selectedItemTypes addObject:@(XDRichTextInputTypeUnderline)];
    }
    
    //链接
    if ([attrs.allKeys containsObject:NSLinkAttributeName]) {
        self.linkValue = attrs[NSLinkAttributeName];
        [selectedItemTypes addObject:@(XDRichTextInputTypeLink)];
    }
    
    [self.richInputAccessoryView updateInputAccessoryItems:selectedItemTypes];
}

- (void)resetTypingAttributes:(XDRichTextInputType)type
{
    if (self.textView.selectedRange.length) return;
    self.textView.typingAttributes = [self getCurrentAttributes:type];
}

- (NSMutableDictionary *)getCurrentAttributes:(XDRichTextInputType)type
{
    NSMutableDictionary *dict = self.textView.typingAttributes.mutableCopy;
    
    switch (type)
    {
        case XDRichTextInputTypeBold:
        {
            UIFont *font = dict[NSFontAttributeName];
            CGFloat fontSize = [font.fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute] floatValue];
            if (self.isBold)
            {
                dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:fontSize];
            }
            else
            {
                dict[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
            }
        }
            break;
        case XDRichTextInputTypeItalic:
        {
            if (self.isItalic)
            {
                dict[NSObliquenessAttributeName] = @(Editor_Italic_Rate);
            } else {
                [dict removeObjectForKey:NSObliquenessAttributeName];
            }
        }
            break;
        case XDRichTextInputTypeUnderline: {
            if (self.isUnderline) {
                UIColor *color = dict[NSForegroundColorAttributeName];
                dict[NSUnderlineColorAttributeName] = color;
                dict[NSUnderlineStyleAttributeName] = @1;
            } else {
                [dict removeObjectForKey:NSUnderlineColorAttributeName];
                [dict removeObjectForKey:NSUnderlineStyleAttributeName];
            }
        }
            break;
        case XDRichTextInputTypeTextColor: {
            dict[NSForegroundColorAttributeName] = self.richTextColor;
        }
            break;
        case XDRichTextInputTypeFonts: {
            UIFont *font = dict[NSFontAttributeName];
            if ((font.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) > 0) {
                dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:self.fontSize];
            } else {
                dict[NSFontAttributeName] = [UIFont systemFontOfSize:self.fontSize];
            }
        }
            break;
        case XDRichTextInputTypeInsertImage:
            break;
        case XDRichTextInputTypeBackgroundColor:{
            dict[NSBackgroundColorAttributeName] = self.richBackgroundColor;
        }
            break;
        case XDRichTextInputTypeLink:{
            break;
        }
            break;
        default:
            break;
    }
    return dict.copy;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        if ([(__bridge NSString *)context isEqualToString:@"XDRichTextEditorView"])
        {
            if ([self.delegate respondsToSelector:@selector(richTextEditor:contentSizeDidChange:)]) {
                [self.delegate richTextEditor:self contentSizeDidChange:self.textView.contentSize];
            }
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewWillDelete:(XDRichEditorTextView *)textView
{
    NSRange range = textView.selectedRange;
    
    if (range.length == 0)
    {
        range = NSMakeRange(range.location - 1, 1);
    }
    
    NSAttributedString *selectedAttr = [self.textView.attributedText attributedSubstringFromRange:range];
    NSString *string = selectedAttr.string;
    NSMutableArray *delArr = [NSMutableArray arrayWithCapacity:0];
    
    [selectedAttr enumerateAttributesInRange:NSMakeRange(0, selectedAttr.length) options:(NSAttributedStringEnumerationLongestEffectiveRangeNotRequired) usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        NSString *selectString = [string substringWithRange:range];
        
        if ([selectString isEqualToString:ImagePlaceholderTag])
        {
            NSTextAttachment *attachment = attrs[NSAttachmentAttributeName];
            NSString *imageName = [[attachment.fileWrapper.preferredFilename stringByDeletingPathExtension] stringByDeletingPathExtension];
            for (XDRichTextImageAttach *imageAttach in self.imageAttachArray)
            {
                BOOL matches = [attachment.fileWrapper matchesContentsOfURL:imageAttach.url];
                
                //先匹配本地图片
                if (matches)
                {
                    [delArr addObject:imageAttach];
                    break;
                }else
                {
                    //网络图片判断
                    if ([imageAttach.url.absoluteString containsString:imageName])
                    {
                        [delArr addObject:imageAttach];
                        break;
                    }
                }
            }
        }
    }];
    
    [self.imageAttachArray removeObjectsInArray:delArr];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self updateCaretRectIfNeeded:NO];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.lastSelectedRange = NSMakeRange(0, 0);
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    [self changeColorOfToolBarItem];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateCaretRectIfNeeded:NO];
    });
}

- (void)textViewDidChange:(UITextView *)textView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateCaretRectIfNeeded:YES];
    });
}

- (void)updateCaretRectIfNeeded:(BOOL)newText
{
    CGRect caretRect = [self.textView caretRectForPosition:self.textView.selectedTextRange.end];
    
    if (newText)
    {
        if ([self.delegate respondsToSelector:@selector(richTextEditor:cursorChange:)])
        {
            [self.delegate richTextEditor:self cursorChange:caretRect];
        }
    }
    else
    {
        if (!NSEqualRanges(self.textView.selectedRange, self.lastSelectedRange))
        {
            if ([self.delegate respondsToSelector:@selector(richTextEditor:cursorChange:)])
            {
                [self.delegate richTextEditor:self cursorChange:caretRect];
            }
        }
    }
    
    self.lastSelectedRange = self.textView.selectedRange;
}

#pragma mark - XDRichInputAccessoryViewDelegate
- (void)richInputAccessoryViewWillResgin:(XDRichInputAccessoryView *)inputAccessoryView
{
    [self.textView resignFirstResponder];
}

- (void)richInputAccessoryView:(XDRichInputAccessoryView *)inputAccessoryView didClickItemWithType:(XDRichTextInputType)inputType completionHandler:(nonnull void (^)(BOOL))completionHandler
{
    __weak typeof(self) weakSelf = self;
    if (inputType == XDRichTextInputTypeBold)
    {
        self.isBold = !self.isBold;
        
        [self setBoldInRange];
        
        XDSafeBlock(completionHandler,self.isBold);
        
    }else if (inputType == XDRichTextInputTypeItalic)
    {
        self.isItalic = !self.isItalic;

        [self setItalicInRange];
        
        XDSafeBlock(completionHandler,self.isItalic);
        
    }else if (inputType == XDRichTextInputTypeFonts)
    {
        if ([self.delegate respondsToSelector:@selector(richTextEditorShouldChangeFont:completionHandler:)]) {
            [self.delegate richTextEditorShouldChangeFont:self completionHandler:^(CGFloat fontSize) {
                weakSelf.fontSize = fontSize;
                [weakSelf setFontInRange];
            }];
        }
    }else if (inputType == XDRichTextInputTypeTextColor)
    {
        if ([self.delegate respondsToSelector:@selector(richTextEditorShouldChangeTextColor:completionHandler:)]) {
            [self.delegate richTextEditorShouldChangeTextColor:self completionHandler:^(UIColor * _Nonnull textColor) {
                weakSelf.richTextColor = textColor;
                [weakSelf setRichForegroundTextColor];
            }];
        }
    }else if (inputType == XDRichTextInputTypeBackgroundColor)
    {
        if ([self.delegate respondsToSelector:@selector(richTextEditorShouldChangeTextBgColor:completionHandler:)]) {
            [self.delegate richTextEditorShouldChangeTextBgColor:self completionHandler:^(UIColor * _Nonnull textBgColor) {
                weakSelf.richBackgroundColor = textBgColor;
                [weakSelf setRichTextBgColor];
            }];
        }

    }else if (inputType == XDRichTextInputTypeUnderline)
    {
        self.isUnderline = !self.isUnderline;
        
        [self setUnderlineInRange];
        
        XDSafeBlock(completionHandler,self.isUnderline);
        
    }else if (inputType == XDRichTextInputTypeInsertImage)
    {
        if ([self.delegate respondsToSelector:@selector(richTextEditorShouldInsertImage:completionHandler:)]) {
            [self.delegate richTextEditorShouldInsertImage:self completionHandler:^(NSURL * _Nonnull imageURL) {
                [weakSelf insertImage:imageURL];
            }];
        }
    }else if (inputType == XDRichTextInputTypeLink)
    {
        if (self.textView.selectedRange.length)
        {
            NSString *selectedString = [self.textView.attributedText.string substringWithRange:self.textView.selectedRange];
            
            if ([self.delegate respondsToSelector:@selector(richTextEditorShouldAddLink:selectedString:completionHandler:)]) {
                [self.delegate richTextEditorShouldAddLink:self selectedString:selectedString completionHandler:^(NSURL * _Nonnull linkURL) {
                    [weakSelf addLinkWithValue:linkURL];
                }];
            }
        }
    }
}

#pragma mark - get
- (XDRichInputAccessoryView *)richInputAccessoryView
{
    if (!_richInputAccessoryView)
    {
        _richInputAccessoryView = [XDRichInputAccessoryView inputAccessoryViewWithItemTypes:self.config.enabledToolbarItems];
        _richInputAccessoryView.delegate = self;
    }
    return _richInputAccessoryView;
}

- (XDRichEditorTextView *)textView
{
    if (!_textView)
    {
        _textView = [[XDRichEditorTextView alloc] init];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.richTextViewDelegate = self;
        
        [_textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:@"XDRichTextEditorView"];
    }
    return _textView;
}

- (NSMutableArray<XDRichTextImageAttach *> *)imageAttachArray
{
    if (!_imageAttachArray)
    {
        _imageAttachArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageAttachArray;
}

- (void)dealloc
{
    [_textView removeObserver:self forKeyPath:@"contentSize"];
}

@end
