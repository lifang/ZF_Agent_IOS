//
//  ScanImageViewController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

/**************************
 
        查看大图
 
 ***************************/

#import "CommonViewController.h"
#import "ImageScrollView.h"
#import "UIImageView+WebCache.h"

@interface ScanImageViewController : CommonViewController

- (void)showDetailImageWithURL:(NSString *)urlString imageRect:(CGRect)rect;

@end
