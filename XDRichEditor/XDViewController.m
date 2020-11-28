//
//  XDViewController.m
//  XDRichEditor
//
//  Created by xiaoda on 2020/11/19.
//

#import "XDViewController.h"
#import "XDOCEditorViewController.h"

@interface XDViewController ()<UITableViewDelegate>

@end

@implementation XDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"XDEditor";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView.tableFooterView = [UIView new];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        XDOCEditorViewController *vc = [[XDOCEditorViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        
    }
}

@end
