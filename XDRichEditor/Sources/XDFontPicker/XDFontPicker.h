//
//  XDFontPicker.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/27.
//

#import <UIKit/UIKit.h>
#import "XDMacros.h"

NS_ASSUME_NONNULL_BEGIN

#define pickerWidth (ISIPAD ? 500 : MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) -20)
#define pickerHeight pickerWidth*5/6

@interface XDFontPicker : UIView

@property (nonatomic, assign) CGFloat percent;

@property (nonatomic, copy) void(^didClickSureButton) (UIFont *font);

@property (nonatomic, copy) void(^didClickCancelButton) (void);

@end

NS_ASSUME_NONNULL_END
