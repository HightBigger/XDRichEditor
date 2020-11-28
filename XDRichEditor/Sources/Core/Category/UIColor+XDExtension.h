//
//  UIColor+XDExtension.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

struct XDRGBStruct {
    CGFloat r;
    CGFloat g;
    CGFloat b;
};

typedef struct CG_BOXABLE XDRGBStruct XDRGBStruct;

@interface UIColor (XDExtension)

/**
 *  创建一个颜色
 *
 *  @param color color的16进制字符串值
 *  @param alpha 透明度
 *
 *  @return 根据color的16进制值创建的颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/// 根据颜色提取16进制字符串
/// @param color 颜色
+ (NSString *)hexStringFromColor:(UIColor *)color;

+ (XDRGBStruct)rgbFromHue:(CGFloat)hue;

+ (XDRGBStruct)rgbFromH:(CGFloat)h S:(CGFloat)s V:(CGFloat)v;


@end

NS_ASSUME_NONNULL_END
