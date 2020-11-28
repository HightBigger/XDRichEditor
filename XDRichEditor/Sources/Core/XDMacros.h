//
//  XDMacros.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/23.
//

#ifndef XDMacros_h
#define XDMacros_h

/// 判断字符串是否为空
#define IsEmptyString(str) (![str isKindOfClass:[NSString class]] || (!str || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]))

#define XDScreenWidth             [UIScreen mainScreen].bounds.size.width
#define XDScreenHeight            [UIScreen mainScreen].bounds.size.height
#define XDNavgationHeight         CGRectGetHeight(self.navigationController.navigationBar.frame)
#define XDStatusHeight            [[UIApplication sharedApplication] statusBarFrame].size.height
#define ISIPAD                    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)


#define XDSafeBlock(BlockName, ...)   ({ !BlockName ? nil : BlockName(__VA_ARGS__); })


#endif /* XDMacros_h */
