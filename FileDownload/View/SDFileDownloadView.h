//
//  SDFileDownloadView.h
//  SunLands
//
//  Created by xingkk on 2019/9/12.
//  Copyright © 2019 Yuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class SDFileDownloadView;
@protocol PromptViewDelegate<NSObject>

-(void)cellFilePathStr:(NSString *)cellStr;

@end


@interface SDFileDownloadView : UIView

@property (nonatomic,copy) NSString * title;
@property (nonatomic,strong) NSArray * cellArr;
@property (nonatomic,strong) NSIndexPath * indexPath;

@property (nonatomic,weak) id<PromptViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title cellArray:(NSArray *)cellArr indexPath:(NSIndexPath*)indexPath;


@end

NS_ASSUME_NONNULL_END
