//
//  XDColorPicker.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/25.
//

#import <UIKit/UIKit.h>
#import "XDMacros.h"

NS_ASSUME_NONNULL_BEGIN

#define pickerWidth (ISIPAD ? 500 : MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) -20)
#define pickerHeight pickerWidth*5/6

@interface XDColorPicker : UIView

@property (nonatomic, copy) void(^didClickSureButton) (UIColor *color,NSString *hexString);

@property (nonatomic, copy) void(^didClickCancelButton) (void);

@end

NS_ASSUME_NONNULL_END
