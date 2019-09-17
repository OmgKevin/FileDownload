//
//  SDFileReadViewController.m
//  SunLands
//
//  Created by xingkk on 2019/9/11.
//  Copyright © 2019 Yuxuan. All rights reserved.
//
// 本地路径https://www.jianshu.com/p/680dd95f83c9
#import "SDFileReadViewController.h"
#import <QuickLook/QuickLook.h>

@interface SDFileReadViewController ()

@end

@implementation SDFileReadViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.dataSource = self;
}


#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    
    return 1;
}


- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"dwn00006466.ppt" ofType:nil];
    
    NSString * path = self.filepath;
    
    NSURL * url = [NSURL fileURLWithPath:path];
    
    return url;
}


- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}


@end
