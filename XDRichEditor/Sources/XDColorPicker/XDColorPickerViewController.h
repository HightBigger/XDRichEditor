//
//  XDColorPickerViewController.h
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDColorPickerViewController : UIViewController

@property (nonatomic, copy) void(^didClickSureButton) (UIColor *color,NSString *hexString);

@property (nonatomic, copy) void(^didClickCancelButton) (void);

@end

NS_ASSUME_NONNULL_END
