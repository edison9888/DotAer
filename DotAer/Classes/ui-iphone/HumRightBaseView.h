//
//  HumRightBaseView.h
//  DotAer
//
//  Created by Kyle on 13-2-4.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMainRightViewLeftGap 60

@protocol HumRightBaseViewDelegate;

@interface HumRightBaseView : UIView

@property (nonatomic, retain) UIView *btnRightMask;
@property (nonatomic, assign) UIViewController *parCtl;
@property (nonatomic, assign) id<HumRightBaseViewDelegate> delegate;

-(id)initWithDotaCatFrameViewCtl:(UIViewController*)ctl Frame:(CGRect)frame;

- (void)didClickHideLefttView;
-(void)viewDidAppear;
-(void)viewDidDisappear;

-(void)viewWillAppear;
-(void)viewWillDisappear;


@end

@protocol HumRightBaseViewDelegate <NSObject>

@optional
-(void)humRightBaseView:(HumRightBaseView*)v DidClickGoback:(id)sender;

-(void)humRightBaseView:(HumRightBaseView *)v TouchBegin:(CGPoint)begin;
-(void)humRightBaseView:(HumRightBaseView *)v TouchMove:(CGPoint)move;
-(void)humRightBaseView:(HumRightBaseView *)v TouchEnd:(CGPoint)end;

@end

