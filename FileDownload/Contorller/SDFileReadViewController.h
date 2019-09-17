//
//  SDFileReadViewController.h
//  SunLands
//
//  Created by xingkk on 2019/9/11.
//  Copyright © 2019 Yuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDFileReadViewController : QLPreviewController<QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate>

@property (nonatomic,strong) QLPreviewController *previewController;

@property (nonatomic,strong) NSString *filepath;

@end

NS_ASSUME_NONNULL_END
