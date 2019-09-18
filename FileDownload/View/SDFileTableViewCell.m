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
    
    // 设置文字
    self.titleLable.text = [url lastPathComponent];
    
    // 控制状态
    MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:url];
    
    if (info.state == MJDownloadStateCompleted) { // 已经完全下载完毕
        [self.downloadSpeedLabel setHidden:YES];
        [self.selectButton setHidden:NO];
        [self.selectButton setImage:[UIImage imageNamed:@"downloadok"] forState:UIControlStateNormal];
        
    } else if (info.state == MJDownloadStateWillResume) {// 即将下载（等待下载）
        
    } else {
        if (info.state == MJDownloadStateNone ) {// 闲置状态
            
        }

        if (info.state == MJDownloadStateResumed) {// 下载中
            [self.selectButton setHidden:YES];
            [self.downloadSpeedLabel setHidden:NO];
            
            [[MJDownloadManager defaultManager] download:url progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.downloadSpeedLabel.text = [NSString stringWithFormat:@"%.2f%%", (CGFloat)totalBytesWritten / totalBytesExpectedToWrite * 100.0];
                });
                
            } state:^(MJDownloadState state, NSString *file, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // 2.3 下载完成，改变按钮状态，保存下载文件路径，保存cell点击状态
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
    
    // 1.0先隐藏掉下载按钮
    [self.selectButton setHidden:YES];
    // 1.1显示下载进度label
    [self.downloadSpeedLabel setHidden:NO];
    
    // 获取下载文件对象
    MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:_url];
    
    
    // 文件下载状态: 下载中和在下载队列排队, 最大3个下载
    if (info.state == MJDownloadStateResumed || info.state == MJDownloadStateWillResume) {
        [[MJDownloadManager defaultManager] suspend:info.url];
        
    } else if (info.state == MJDownloadStateSuspened || info.state == MJDownloadStateNone) {
        // 开始下载obj = Url
        [[MJDownloadManager defaultManager] download:_url progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
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
