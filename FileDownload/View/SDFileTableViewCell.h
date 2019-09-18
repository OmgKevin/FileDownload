//
//  SDFileTableViewCell.h
//  SunLands
//
//  Created by xingkk on 2019/9/12.
//  Copyright © 2019 Yuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SDFileTableViewCell;

@protocol PromptCellDelegate <NSObject>

-(void)selectRowStr:(NSString *)cellStr indexPath:(NSIndexPath*)selectedIndexPath ;
@end


@interface SDFileTableViewCell : UITableViewCell

@property (nonatomic,assign) NSIndexPath *selectedIndexPath;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,weak) id<PromptCellDelegate>delegate;

@property (nonatomic,weak) IBOutlet UILabel *titleLable;
@property (nonatomic,weak) IBOutlet UIButton *selectButton;
@property (nonatomic,weak) IBOutlet UILabel *downloadSpeedLabel;


@end

NS_ASSUME_NONNULL_END
