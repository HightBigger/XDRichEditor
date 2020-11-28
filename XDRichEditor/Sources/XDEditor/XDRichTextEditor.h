//
//  XDRichTextEditor.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/10/30.
//

#import <UIKit/UIKit.h>
#import "XDRichTextObject.h"

NS_ASSUME_NONNULL_BEGIN

@class XDRichTextEditor;

@protocol XDRichTextEditorDelegate <NSObject>
@optional

/// 编辑器内容高度变化
/// @param richTextEditor 编辑器
/// @param contentSize 内容大小
- (void)richTextEditor:(XDRichTextEditor*)richTextEditor contentSizeDidChange:(CGSize)contentSize;

/// 富文本编辑器改变字体大小
/// @param richTextEditor 编辑器
/// @param completionHandler 返回的字体大小
- (void)richTextEditorShouldChangeFont:(XDRichTextEditor*)richTextEditor
                     completionHandler:(void (^)(CGFloat fontSize))completionHandler;

/// 富文本编辑器改变字体颜色
/// @param richTextEditor 编辑器
/// @param completionHandler 返回的字体颜色
- (void)richTextEditorShouldChangeTextColor:(XDRichTextEditor*)richTextEditor
                          completionHandler:(void (^)(UIColor *textColor))completionHandler;

/// 富文本编辑器改变字体背景颜色
/// @param richTextEditor 编辑器
/// @param completionHandler 返回的字体背景颜色
- (void)richTextEditorShouldChangeTextBgColor:(XDRichTextEditor*)richTextEditor
                            completionHandler:(void (^)(UIColor *textBgColor))completionHandler;

/// 富文本编辑器插入图片回调
/// @param richTextEditor 编辑器
/// @param completionHandler 返回的图片URL
- (void)richTextEditorShouldInsertImage:(XDRichTextEditor*)richTextEditor
                      completionHandler:(void (^)(NSURL *imageURL))completionHandler;

/// 富文本编辑器插入链接
/// @param richTextEditor 编辑器
/// @param selectedString 选中的字符串
/// @param completionHandler 返回该链接的目的地址
- (void)richTextEditorShouldAddLink:(XDRichTextEditor*)richTextEditor
                     selectedString:(NSString *)selectedString
                  completionHandler:(void (^)(NSURL *linkURL))completionHandler;

/// 富文本编辑器光标位置发生变化
/// @param richTextEditor 编辑器
/// @param cursorFrame 光标位置或者选中文字的frame
- (void)richTextEditor:(XDRichTextEditor*)richTextEditor
          cursorChange:(CGRect)cursorFrame;

@end

@interface XDRichTextEditor : UIView

@property(nonatomic,weak) id<XDRichTextEditorDelegate> delegate;

+ (XDRichTextEditor *)richTextEditorWithConfig:(XDRichTextEditorConfig *)config;

- (void)setHtml:(NSString *)html;

- (void)getRichTextEditHtml:(void (^)(NSString *html))completionHandler;

@end

NS_ASSUME_NONNULL_END
