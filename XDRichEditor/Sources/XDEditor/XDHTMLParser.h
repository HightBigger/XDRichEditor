//
//  XDHTMLParser.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/10/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XDRichTextObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDHTMLParser : NSObject

//NSAttributedString -> html
+ (void)htmlStringWithAttributedText:(NSAttributedString *)attributedText
                    imageAttachArray:(NSArray<XDRichTextImageAttach *> *)imageAttachArray
                   completionHandler:(void (^)(NSString *_Nullable html))completionHandler;


//html -> NSAttributedString
+ (void)attributedTextWithHtmlString:(NSString *)htmlString
                          imageWidth:(CGFloat)width
                   completionHandler:(void (^)(NSAttributedString *_Nullable attributedString,NSArray <XDRichTextImageAttach *> *_Nullable imageAttachs))completionHandler;

//获取html中的图片地址数组
+ (NSArray *)imageUrls:(NSString *)html;

@end

NS_ASSUME_NONNULL_END
