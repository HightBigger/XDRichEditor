//
//  UIImage+XDExtension.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum {
    InfComponentIndexHue = 0,
    InfComponentIndexSaturation = 1,
    InfComponentIndexBrightness = 2,
} InfComponentIndex;

@interface UIImage (XDExtension)

// 生成1个像素纯色图
+ (UIImage *)imageWithColor:(UIColor *)color;


+ (UIImage *)imageWithHue:(CGFloat)hue;


+ (UIImage *)imageWithHSV:(NSMutableArray *)hsv barComponentIndex:(InfComponentIndex)barComponentIndex;

@end

NS_ASSUME_NONNULL_END
