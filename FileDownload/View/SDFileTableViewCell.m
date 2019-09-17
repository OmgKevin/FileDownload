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
            
            
        } else {
            
            if (info.totalBytesExpectedToWrite) {
                
            } else {
                
            }
        }
        
        if (info.state == MJDownloadStateResumed) {// 下载中
            [self.selectButton setHidden:YES];
            [self.downloadSpeedLabel setHidden:NO];
            NSLog(@"状态状态");
            
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
                        
                    }
                });
            }];
        } else {
           
        }
    }
}


- (IBAction)selectButtonAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectRowStr:indexPath:)]) {
      [_delegate selectRowStr:self.titleLable.text indexPath:self.selectedIndexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
