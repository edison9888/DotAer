//
//  HumDotaCateOneNoSplit.m
//  DotAer
//
//  Created by Kyle on 13-3-3.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaPadCateOneNoSplit.h"

@implementation HumDotaPadCateOneNoSplit

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#pragma mark
#pragma mark instanc method
- (void)viewDidAppear{
    
    [super viewDidAppear];
    
    
    [self.contentView viewWillDisappear];
    
    HumDotaPadCateTowBaseView *av = [self createContentViewCatIdx];
    
    [av viewWillAppear];
    
    [self insertSubview:av belowSubview:self.topNav];
    
    [av viewDidAppear];
    
    [self.contentView viewDidDisappear];
    [self.contentView removeFromSuperview];
    
    self.contentView = av;
    
    [self setNeedsLayout];
    
}




-(HumDotaPadCateTowBaseView *)viewForViewController:(HumPadDotaBaseViewController *)ctl frame:(CGRect)frm{

    return nil;
    
}




-(HumDotaPadCateTowBaseView *)createContentViewCatIdx {
    
    CGRect frame = self.contentView.frame;
//    frame.size.height -=20;
    return [self viewForViewController:self.parCtl frame:frame ];
}





@end
