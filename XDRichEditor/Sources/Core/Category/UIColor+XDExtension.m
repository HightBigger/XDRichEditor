//
//  UIColor+XDExtension.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/23.
//

#import "UIColor+XDExtension.h"

@implementation UIColor (XDExtension)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (NSString *)hexStringFromColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    return [NSString stringWithFormat:@"#%06x", rgb];
}

+ (XDRGBStruct)rgbFromHue:(CGFloat)hue
{
    CGFloat r,g,b;
    
    float h_prime = hue / 60.0f;
    float x = 1.0f - fabsf(fmodf(h_prime, 2.0f) - 1.0f);
    
    if (h_prime < 1.0f) {
        r = 1;
        g = x;
        b = 0;
    }
    else if (h_prime < 2.0f) {
        r = x;
        g = 1;
        b = 0;
    }
    else if (h_prime < 3.0f) {
        r = 0;
        g = 1;
        b = x;
    }
    else if (h_prime < 4.0f) {
        r = 0;
        g = x;
        b = 1;
    }
    else if (h_prime < 5.0f) {
        r = x;
        g = 0;
        b = 1;
    }
    else {
        r = 1;
        g = 0;
        b = x;
    }
    
    XDRGBStruct rgb = {r,g,b};
    return rgb;
}

+ (XDRGBStruct)rgbFromH:(CGFloat)h S:(CGFloat)s V:(CGFloat)v
{
    XDRGBStruct rgb = [self rgbFromHue:h];
    
    CGFloat c = v*s;
    CGFloat m = v-c;
    
    CGFloat r = rgb.r * c + m;
    CGFloat g = rgb.g * c + m;
    CGFloat b = rgb.b * c + m;
 
    XDRGBStruct rgbReal = {r,g,b};
    return rgbReal;
}

@end
