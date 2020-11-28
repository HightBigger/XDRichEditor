//
//  XDFontPickerViewController.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDFontPickerViewController : UIViewController

@property (nonatomic, assign) CGFloat percent;

@property (nonatomic, copy) void(^didClickSureButton) (UIFont *font);

@property (nonatomic, copy) void(^didClickCancelButton) (void);

@end

NS_ASSUME_NONNULL_END
