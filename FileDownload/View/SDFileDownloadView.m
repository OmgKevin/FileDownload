//
//  SDFileDownloadView.m
//  SunLands
//
//  Created by xingkk on 2019/9/12.
//  Copyright © 2019 Yuxuan. All rights reserved.
//

#import "SDFileDownloadView.h"
#import "SDFileTableViewCell.h"
#import "LMJRequestManager.h"
#import "Masonry.h"
#import "SDFileReadViewController.h"
#import "LMJRequestManager.h"
#import "MJDownload.h"

//一个默认的坐标
#define HHframe  CGRectMake(0, 0, 100, 30)
#define SD_ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface SDFileDownloadView ()<UITableViewDelegate,UITableViewDataSource,promptCellDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIView * promptView;
@property (nonatomic,assign) NSIndexPath *selectedIndexPath;
@property (nonatomic,copy) NSString * cellStr;

@end


@implementation SDFileDownloadView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title cellArray:(NSArray *)cellArr indexPath:(NSIndexPath*)indexPath{
    
    if (self =[super initWithFrame:frame]) {
        
        self.cellArr = cellArr;
        self.indexPath=indexPath;
        self.cellStr=@"";
        self.title=title;
        self.backgroundColor = [[UIColor blackColor ]colorWithAlphaComponent:0.4];
        
        UIView * promptView = [[UIView alloc]init];
        self.promptView = promptView;
        [self addSubview:promptView];
        
        UILabel * titleLab= [[UILabel alloc]initWithFrame:HHframe];
        titleLab.backgroundColor = [UIColor whiteColor];
        titleLab.font =[UIFont systemFontOfSize:19];
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.text=title;
        titleLab.textColor = [UIColor blackColor];
        
        UITableView * tableView = [[UITableView alloc]initWithFrame:HHframe style:UITableViewStylePlain];
        tableView.delegate =self;
        tableView.dataSource=self;
        self.tableView = tableView;
        
        [promptView addSubview:titleLab];
        [promptView addSubview:tableView];
     
        // layput 布局
        [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self);
            make.height.mas_equalTo(SD_ScreenHeight*3/4);
        }];
        
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(promptView);
            make.height.mas_equalTo(50);
        }];
        
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLab.mas_bottom);
            make.left.right.mas_equalTo(promptView);
            make.bottom.mas_equalTo(promptView.mas_bottom).offset(0);
        }];

        [tableView registerNib:[UINib nibWithNibName:@"SDFileTableViewCell" bundle:nil] forCellReuseIdentifier:@"SDFileTableViewCell"];
        tableView.tableFooterView= [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self;
}



#pragma mark - UITableViewDataSource

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.cellArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *ID = @"SDFileTableViewCell";
    SDFileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate=self;
    cell.titleLable.text=self.cellArr[indexPath.row];

    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDFileTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];

    // 1.0先隐藏掉下载按钮
    [cell.selectButton setHidden:YES];
    // 1.1显示下载进度label
    [cell.downloadSpeedLabel setHidden:NO];
    
    
    // 2.1 下载文件url
    NSArray<NSString *> *urls = @[
                                  
        @"http://teaching.csse.uwa.edu.au/units/CITS4401/practicals/James1_files/SPMP1.pdf",
        @"http://down.51rc.com/dwndoc/WrittenExamination/WrittenExperiences/dwn00006795.doc",
        @"http://video1.remindchat.com/20190905/1gEji0Sv/mp4/1gEji0Sv.mp4",
        @"https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",
        @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
        @"http://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4",
                                  
        ];
    
    
    __weak typeof(self)weakSelf = self;
    
    [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:obj];
        
        if (info.state == MJDownloadStateCompleted) {
            // 下载完成之后，下载中图标更换为下载完成图标
            [cell.downloadSpeedLabel setHidden:YES];
            [cell.selectButton setHidden:NO];
            [cell.selectButton setImage:[UIImage imageNamed:@"downloadok"] forState:UIControlStateNormal];
        }else {
            // 未下载状态
            NSLog(@"222222222222");
        }
        
        
        if (info.state == MJDownloadStateResumed || info.state == MJDownloadStateWillResume) {
            
            
        } else if (info.state == MJDownloadStateSuspened || info.state == MJDownloadStateNone) {
            
            [[MJDownloadManager defaultManager] download:obj progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // 2.2 下载中进度显示
                    cell.downloadSpeedLabel.text = [NSString stringWithFormat:@"%.2f%%", (CGFloat)totalBytesWritten / totalBytesExpectedToWrite * 100.0];
                    
                });
                
            } state:^(MJDownloadState state, NSString *file, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // 2.3 下载完成，改变按钮状态，保存下载文件路径，保存cell点击状态
                    if (state == MJDownloadStateCompleted) {
                        
                        [cell.downloadSpeedLabel setHidden:YES];
                        [cell.selectButton setHidden:NO];
                        [cell.selectButton setImage:[UIImage imageNamed:@"downloadok"] forState:UIControlStateNormal];
                        
                        NSLog(@"打印保存文件路径地址 ：%@",file);
                        
                    }
                });
            }];
            
        }else if (info.state == MJDownloadStateCompleted) {
            
            // 已下载完成的文件取url链接跳转阅读控制器
            NSString * filepath = [NSString stringWithFormat:@"%@",info.file];
            
            if ([self.delegate respondsToSelector:@selector(cellFilePathStr:)]) {
                
                // 移除下载列表视图
                [self removeFromSuperview];
                // 代理方法跳转阅读文档控制器
                [self.delegate cellFilePathStr:filepath];
            }
        }
    }];
    
}



#pragma mark - 点击cell didSelectRowAtIndexPath事件
- (void) cellDidSelectRow :(SDFileTableViewCell *)cell {
    
  
}




#pragma mark - cell上下载按钮点击代理方法
-(void)selectRowStr:(NSString *)cellStr indexPath:(NSIndexPath *)selectedIndexPath
{

}




// 点击提示框视图以外的其他地方时隐藏弹框
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [self.promptView.layer convertPoint:point fromLayer:self.layer];
    if (![self.promptView.layer containsPoint:point]) {
        self.hidden = YES;
    }
}

@end
