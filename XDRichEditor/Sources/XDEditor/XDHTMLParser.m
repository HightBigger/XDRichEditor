//
//  XDHTMLParser.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/10/30.
//

#import "XDHTMLParser.h"
#import "XDMacros.h"
#import "UIColor+XDExtension.h"
#import "XDRichTextObject.h"

@implementation XDHTMLParser

//NSAttributedString -> html
+ (void)htmlStringWithAttributedText:(NSAttributedString *)attributedText
                    imageAttachArray:(NSArray<XDRichTextImageAttach *> *)imageAttachArray
                   completionHandler:(void (^)(NSString *html))completionHandler
{
    if (attributedText.length == 0) {
        XDSafeBlock(completionHandler,nil);
        return;
    }
    
    //富文本转换为html(最后相当于整个网页代码，会有css等)
    NSDictionary *dic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:@(NSUnicodeStringEncoding)};
    NSData *data = [attributedText dataFromRange:NSMakeRange(0, attributedText.length) documentAttributes:dic error:nil];
    NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUnicodeStringEncoding];
    
    NSRange startRange = [htmlString rangeOfString:@"<body>"];
    NSRange endRange = [htmlString rangeOfString:@"</body>"];
        
    if (startRange.location != NSNotFound && endRange.location != NSNotFound)
    {
        //取出body
        htmlString = [htmlString substringWithRange:NSMakeRange(startRange.location, endRange.location + endRange.length - startRange.location)];
        
        NSArray *imageurls = [self imageUrls:htmlString];

        for (XDRichTextImageAttach *newAttach in imageurls)
        {
            for (XDRichTextImageAttach *realAttach in imageAttachArray)
            {
                if ([realAttach.url.absoluteString containsString:newAttach.url.lastPathComponent.stringByDeletingPathExtension])
                {
                    htmlString = [htmlString stringByReplacingOccurrencesOfString:newAttach.url.absoluteString withString:realAttach.url.absoluteString];
                    break;
                }
            }
        }
    }

    XDSafeBlock(completionHandler,htmlString);
}

//html -> NSAttributedString
+ (void)attributedTextWithHtmlString:(NSString *)htmlString
                          imageWidth:(CGFloat)width
                   completionHandler:(nonnull void (^)(NSAttributedString * _Nullable, NSArray<XDRichTextImageAttach *> * _Nullable))completionHandler
{
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                          NSCharacterEncodingDocumentOption: @(NSUTF8StringEncoding)};
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData:data options:dic
                                            documentAttributes:nil error:nil];
    
    //斜体适配
    NSMutableAttributedString *mAttributedString = attributedString.mutableCopy;
    [mAttributedString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, mAttributedString.length) options:(NSAttributedStringEnumerationLongestEffectiveRangeNotRequired) usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if ([value isKindOfClass:[UIFont class]]) {
            if ([[value description] containsString:@"italic"]) {
                [mAttributedString addAttribute:NSObliquenessAttributeName value:@0.35 range:range];
            }
        }
    }];
    
    //为了调整图片尺寸 需要在图片名后面拼接有图片宽高 例如：img-880x568.jpg
    [mAttributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, mAttributedString.length) options:(NSAttributedStringEnumerationLongestEffectiveRangeNotRequired) usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if ([value isKindOfClass:[NSTextAttachment class]])
        {
            NSTextAttachment *attachment = value;
            NSString *imageName = [[attachment.fileWrapper.preferredFilename stringByDeletingPathExtension] stringByDeletingPathExtension];
            NSArray *sizeArr = [[imageName componentsSeparatedByString:@"-"].lastObject componentsSeparatedByString:@"x"];
            if (sizeArr.count == 2) {
                CGFloat width0 = [sizeArr[0] floatValue];
                CGFloat height0 = [sizeArr[1] floatValue];
                attachment.bounds = CGRectMake(0, 0, width, width * height0 / width0);
                ;
            } else {
                attachment.bounds = CGRectMake(0, 0, width, width * 0.5);
            }
        }
    }];
    NSArray *imageUrls = [self imageUrls:htmlString];
    
    XDSafeBlock(completionHandler,mAttributedString,imageUrls);
}

//获取html中的图片地址数组
+ (NSArray *)imageUrls:(NSString *)html
{
    if (html.length == 0) return @[];
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    [regex enumerateMatchesInString:html
                            options:0
                              range:NSMakeRange(0, [html length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             NSString *url = [html substringWithRange:[result rangeAtIndex:2]];
                             [array addObject:[[XDRichTextImageAttach alloc]  initWithURL:[NSURL URLWithString:url]]];
                         }];
    return array.copy;
}

@end
