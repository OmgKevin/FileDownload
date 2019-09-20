//
//  SDFileDownloadView.m
//  SunLands
//
//  Created by xingkk on 2019/9/12.
//  Copyright © 2019 Yuxuan. All rights reserved.
//

#import "SDFileDownloadView.h"
#import "SDFileTableViewCell.h"
#import "Masonry.h"
#import "SDFileReadViewController.h"
#import "MJDownload.h"

//一个默认的坐标
#define HHframe  CGRectMake(0, 0, 100, 30)
#define SD_ScreenHeight [UIScreen mainScreen].bounds.size.height
static NSString * CellID = @"SDFileTableViewCell";

@interface SDFileDownloadView ()<UITableViewDelegate,UITableViewDataSource,PromptCellDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIView * promptView;
@property (nonatomic,assign) NSIndexPath *selectedIndexPath;
@property (nonatomic,copy) NSString * cellStr;
@property (nonatomic, strong) NSMutableArray *urls;


@end


@implementation SDFileDownloadView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title cellArray:(NSArray *)cellArr indexPath:(NSIndexPath*)indexPath{
    
    if (self =[super initWithFrame:frame]) {
        
        self.cellArr = cellArr;
        self.indexPath = indexPath;
        self.title = title;
        self.backgroundColor = [[UIColor blackColor ]colorWithAlphaComponent:0.4];
        
        UIView * promptView = [[UIView alloc]init];
        self.promptView = promptView;
        [self addSubview:promptView];
        
        UILabel * titleLab = [[UILabel alloc]initWithFrame:HHframe];
        titleLab.backgroundColor = [UIColor whiteColor];
        titleLab.font = [UIFont systemFontOfSize:19];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = title;
        titleLab.textColor = [UIColor blackColor];
        
        UITableView * tableView = [[UITableView alloc]initWithFrame:HHframe style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        self.tableView = tableView;
        
        [promptView addSubview:titleLab];
        [promptView addSubview:tableView];
        
        // 布局
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
        
        [tableView registerNib:[UINib nibWithNibName:CellID bundle:nil] forCellReuseIdentifier:CellID];
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    
    return self;
}



#pragma mark - UITableViewDataSource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.urls.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDFileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.url = self.urls[indexPath.row];

    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 已下载完成的文件取url链接跳转阅读控制器
//    NSString * filepath = [NSString stringWithFormat:@"%@",info.file];
//
//    if ([self.delegate respondsToSelector:@selector(cellFilePathStr:)]) {
//
//        // 移除下载列表视图
//        [self removeFromSuperview];
//        // 代理方法跳转阅读文档控制器
//        [self.delegate cellFilePathStr:filepath];
//    }
}



#pragma mark - cell上下载按钮点击代理方法
-(void)selectRowStr:(NSString *)cellStr indexPath:(NSIndexPath *)selectedIndexPath
{
    
    
}


- (NSMutableArray *)urls
{
    if (!_urls) {
        self.urls = [NSMutableArray array];
        
        [self.urls addObject:[NSString stringWithFormat:@"http://teaching.csse.uwa.edu.au/units/CITS4401/practicals/James1_files/SPMP1.pdf"]];
        [self.urls addObject:[NSString stringWithFormat:@"http://down.51rc.com/dwndoc/WrittenExamination/WrittenExperiences/dwn00006795.doc"]];
        
        [self.urls addObject:[NSString stringWithFormat:@"https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4"]];
        
        [self.urls addObject:[NSString stringWithFormat:@"https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_50mb.mp4"]];
        
        [self.urls addObject:[NSString stringWithFormat:@"http://video1.remindchat.com/20190905/1gEji0Sv/mp4/1gEji0Sv.mp4"]];
        
        [self.urls addObject:[NSString stringWithFormat:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"]];
        [self.urls addObject:[NSString stringWithFormat:@"http://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4"]];
    }
    return _urls;
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
