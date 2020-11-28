//
//  XDRichTextObject.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/10/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const ImagePlaceholderTag;

typedef NS_ENUM(NSUInteger, XDRichTextInputType) {
    XDRichTextInputTypeNone    = 0,
    XDRichTextInputTypeBold    = 1,               //加粗
    XDRichTextInputTypeItalic  = 2,               //斜体
    XDRichTextInputTypeFonts,                     //字体
    XDRichTextInputTypeTextColor,                 //字体颜色
    XDRichTextInputTypeBackgroundColor,           //字体背景颜色
    XDRichTextInputTypeUnderline,                 //下划线
    XDRichTextInputTypeInsertImage,               //插入图片
    XDRichTextInputTypeLink,                      //链接
};

@interface XDRichTextEditorConfig : NSObject

/// 是否显示toolbar
@property(nonatomic,assign) BOOL alwaysShowToolbar;

/// toolbar中显示的按钮数组 `XDRichTextInputType`
@property(nonatomic,strong) NSArray *enabledToolbarItems;

/// Color to tint the toolbar items
@property(nonatomic,strong) UIColor *toolbarItemTintColor;

/// Color to tint selected items
@property(nonatomic,strong) UIColor *toolbarItemSelectedTintColor;

/// 输入框占位符
@property(nonatomic,copy)NSString *placeholder;

/// 编辑框的html
@property(nonatomic,copy)NSString *html;

@end

@interface XDRichTextImageAttach : NSObject

@property(nonatomic,strong) NSURL *url;

- (instancetype)initWithURL:(NSURL *)url;

@end


@interface XDRichTextObject : NSObject

@end

NS_ASSUME_NONNULL_END
