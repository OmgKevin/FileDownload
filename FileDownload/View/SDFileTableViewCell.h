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
@protocol promptCellDelegate <NSObject>

-(void)selectRowStr:(NSString *)cellStr indexPath:(NSIndexPath*)selectedIndexPath ;
@end


@interface SDFileTableViewCell : UITableViewCell

@property (nonatomic,strong) UIButton *lastButton;
@property (nonatomic,assign) NSIndexPath *selectedIndexPath;

@property (nonatomic,weak) id<promptCellDelegate>delegate;

@property (nonatomic,weak) IBOutlet UILabel *titleLable;

@property (nonatomic,weak) IBOutlet UIButton *selectButton;
 
@property (nonatomic,weak) IBOutlet UILabel *downloadSpeedLabel;


@end

NS_ASSUME_NONNULL_END
