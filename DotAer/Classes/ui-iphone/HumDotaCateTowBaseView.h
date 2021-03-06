//
//  HumDotaCateTowBaseView.h
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Downloader.h"
#import "Env.h"
#import "BqsUtils.h"
#import "HeroInfo.h"
#import "Equipment.h"
#import "MptCotentCell.h"
#import "MobClick.h"
#import "HumDotaMaco.h"

@interface HumDotaCateTowBaseView : MptCotentCell

@property (nonatomic, assign) UIViewController *parCtl;
@property (nonatomic, retain) Downloader *downloader;


-(BOOL)loadLocalDataNeedFresh;
-(void)loadNetworkData:(BOOL)bLoadMore;



-(void)onLoadDataFinished:(DownloaderCallbackObj*)cb;

-(void)viewWillAppear;
-(void)viewDidAppear;
-(void)viewWillDisappear;
-(void)viewDidDisappear;

-(void)didSelectHero:(HeroInfo *)hero;
-(void)didSelectEquip:(Equipment *)equip;


@end
