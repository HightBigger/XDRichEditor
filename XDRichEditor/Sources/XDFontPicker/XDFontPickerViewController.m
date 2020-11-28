//
//  XDFontPickerViewController.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/27.
//

#import "XDFontPickerViewController.h"
#import "XDFontPicker.h"

@interface XDFontPickerViewController ()

@end

@implementation XDFontPickerViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1]];
    
    XDFontPicker *picker = [[XDFontPicker alloc] init];
    
    picker.didClickCancelButton = self.didClickCancelButton;
    picker.didClickSureButton = self.didClickSureButton;
    picker.translatesAutoresizingMaskIntoConstraints = NO;
    picker.percent = self.percent;
    
    [self.view addSubview:picker];
    
    [picker.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [picker.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [picker.widthAnchor constraintEqualToConstant:pickerWidth].active = YES;
    [picker.heightAnchor constraintEqualToConstant:pickerHeight].active = YES;
    
}



@end
