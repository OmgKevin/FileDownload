//
//  ViewController.m
//  FileDownload
//
//  Created by xingkk on 2019/9/17.
//  Copyright © 2019 kevinomg. All rights reserved.
//

#import "ViewController.h"
#import "SDFileReadViewController.h"
#import <QuickLook/QuickLook.h>
#import "LMJRequestManager.h"
#import "MJDownload.h"
#import "SDFileReadViewController.h"
#import "SDFileDownloadView.h"
#import "Masonry.h"

@interface ViewController ()<PromptViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文件下载";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupbtn];

}


- (void)setupbtn {
    
    UIButton *downloadbutton = [[UIButton alloc] init];
    [downloadbutton setTitle:@"下载" forState:UIControlStateNormal];
    [downloadbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    downloadbutton.backgroundColor = [UIColor lightGrayColor];
    [downloadbutton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *lookbutton = [[UIButton alloc] init];
    [lookbutton setTitle:@"查看" forState:UIControlStateNormal];
    [lookbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lookbutton.backgroundColor = [UIColor lightGrayColor];
    [lookbutton addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:downloadbutton];
    [self.view addSubview:lookbutton];
    
    
    
    [downloadbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@40);
        make.center.equalTo(self.view).mas_offset(-100);
    }];
    
    
    
    [lookbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@40);
        make.center.equalTo(self.view).mas_offset(100);
    }];
    
}

- (void)downloadAction :(UIButton *)sender {
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    
    NSArray * array = @[@"课件1的名字",@"课件2的名字",@"课件2的名字课件2的名字",@"课件2的名字课件2的名字课件2的名字课件2的名字课件2的名字",@"课件名字",@"课件2的名字",@"课件的名字课件的名字课件的名字课件的名字课件的名字课件的名字课件的名字课件的名字课件的名字课件的名字课件"];
    
    
    SDFileDownloadView * kproptView = [[SDFileDownloadView alloc]initWithFrame:window.frame title:@"资料下载" cellArray:array indexPath:nil];
    
    
    kproptView.delegate = self;
    
    [window addSubview:kproptView];
    
}


-(void)cellFilePathStr:(NSString *)cellStr{
    
    NSLog(@"view传过来的文件路径:%@",cellStr);
    
    SDFileReadViewController * readvc = [[SDFileReadViewController alloc]init];
    readvc.filepath = cellStr;
    [self presentViewController:readvc animated:YES completion:nil];
    
}
@end
