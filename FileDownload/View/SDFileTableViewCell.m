//
//  SDFileTableViewCell.m
//  SunLands
//
//  Created by xingkk on 2019/9/12.
//  Copyright © 2019 Yuxuan. All rights reserved.
//

#import "SDFileTableViewCell.h"
#import "MJDownload.h"

@implementation SDFileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLable.font = [UIFont systemFontOfSize:17];
    self.titleLable.textColor = [UIColor blackColor];
    self.titleLable.numberOfLines = 0;
    self.titleLable.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.downloadSpeedLabel.textColor = [UIColor redColor];
    [self.downloadSpeedLabel setHidden:YES];
    
}


-(void)setUrl:(NSString *)url{
    
    _url = [url copy];
    
    // 设置列表title
    self.titleLable.text = [url lastPathComponent];
    
    // 设置下载文件保存目录
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SDDownloadFile/ProductName/CourseName"];
    NSString *filePath = [path stringByAppendingPathComponent:_url.lastPathComponent];
    _filePath = filePath;
    
    
    // 控制状态
    MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:_url];
    
    if (info.state == MJDownloadStateCompleted) { // 已经完全下载完毕
        [self.downloadSpeedLabel setHidden:YES];
        [self.selectButton setHidden:NO];
        [self.selectButton setImage:[UIImage imageNamed:@"downloadok"] forState:UIControlStateNormal];
        
        NSLog(@"111111");
        
    } else if (info.state == MJDownloadStateWillResume) {// 即将下载（等待下载）
        
    } else {
        if (info.state == MJDownloadStateNone ) {// 闲置状态
            
        }
        
        if (info.state == MJDownloadStateResumed) {// 下载中
            [self.selectButton setHidden:YES];
            [self.downloadSpeedLabel setHidden:NO];
            
            // 1.默认方式下载
            //            [[MJDownloadManager defaultManager] download:url progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            //
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //
            //                    self.downloadSpeedLabel.text = [NSString stringWithFormat:@"%.2f%%", (CGFloat)totalBytesWritten / totalBytesExpectedToWrite * 100.0];
            //                });
            //
            //            } state:^(MJDownloadState state, NSString *file, NSError *error) {
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //
            //                    // 下载完成，改变按钮状态，保存下载文件路径，保存cell点击状态
            //                    if (state == MJDownloadStateCompleted) {
            //
            //                        [self.downloadSpeedLabel setHidden:YES];
            //                        [self.selectButton setHidden:NO];
            //                        [self.selectButton setImage:[UIImage imageNamed:@"downloadok"] forState:UIControlStateNormal];
            //                        NSLog(@"下载完成，打印文件所在路径 :%@",file);
            //                    }
            //                });
            //            }];
            
            // 2。自定义缓存路径的方式下载
            [[MJDownloadManager defaultManager] download:_url toDestinationPath:_filePath progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.downloadSpeedLabel.text = [NSString stringWithFormat:@"%.2f%%", (CGFloat)totalBytesWritten / totalBytesExpectedToWrite * 100.0];
                });
                
            } state:^(MJDownloadState state, NSString *file, NSError *error) {
                // 主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (state == MJDownloadStateCompleted) {
                        
                        [self.downloadSpeedLabel setHidden:YES];
                        [self.selectButton setHidden:NO];
                        [self.selectButton setImage:[UIImage imageNamed:@"downloadok"] forState:UIControlStateNormal];
                        NSLog(@"下载完成，打印文件所在路径 :%@",file);
                    }
                });
            }];
        }}
}


- (IBAction)selectButtonAction:(UIButton *)sender {
    
    // 隐藏下载按钮
    [self.selectButton setHidden:YES];
    // 显示下载进度label
    [self.downloadSpeedLabel setHidden:NO];
    
    // 获取下载文件对象
    MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:_url];
    
    
    // 文件下载状态: 下载中和在下载队列排队, 最大3个下载
    if (info.state == MJDownloadStateResumed || info.state == MJDownloadStateWillResume) {
        [[MJDownloadManager defaultManager] suspend:info.url];
        
    } else if (info.state == MJDownloadStateSuspened || info.state == MJDownloadStateNone) {
        
        // 1.默认方式下载
        //        [[MJDownloadManager defaultManager] download:_url progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        //
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                self.url = self.url;
        //            });
        //
        //        } state:^(MJDownloadState state, NSString *file, NSError *error) {
        //            // 主线程刷新UI
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                self.url = self.url;
        //
        //            });
        //        }];
        
        
        // 2 .用自定义缓存路径的方式下载
        [[MJDownloadManager defaultManager] download:_url toDestinationPath:_filePath progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.url = self.url;
            });
            
            
        } state:^(MJDownloadState state, NSString *file, NSError *error) {
            // 主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.url = self.url;
            });
        }];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
