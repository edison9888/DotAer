//
//  HumDotaMaco.h
//  DotAer
//
//  Created by Kyle on 13-1-23.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kDotaCat_News @"DotaCat_News"  //新闻
#define kDotaCat_Video @"DotaCat_Video" //视频
#define kDotaCat_Photo @"DotaCat_Photo" //图片
#define kDotaCat_Strategy @"DotaCat_Strategy" //攻略
#define kDotaCat_Simulator @"DotaCat_Simulator" //模拟器



#define HUMSAFERELEASE(x) [x release];x=nil

#define OBJECT_OF_ARRAY_ATINDEX(_OBJ_,_ARRAY_,_INDEX_) ({if(_ARRAY_&&_INDEX_<[_ARRAY_ count]){_OBJ_ =[_ARRAY_ objectAtIndex:_INDEX_];}})

#define DISTANCE_X(_POINT_A_,POINT_B_,_X_) (_X_ = _POINT_A_.x - POINT_B_.x)

#define DISTANCE_Y(_POINT_A_,POINT_B_,_Y_) (_Y_ = _POINT_A_.y - POINT_B_.y)



//umeng tatics
#define kUmeng_newspage @"newspage"
#define kUmeng_videopage @"videopage"
#define kUmeng_imagepage @"imagepage"
#define kUmeng_strategyPage @"strategypage"
#define kUmeng_simulatorPage @"simulatorpage"

#define kUmeng_news_cell_event @"news_cell_event"

#define kUmeng_video_cateChange @"video_category_change"
#define kUmeng_video_dota1 @"category_dota1"
#define kUmeng_video_dota2 @"category_dota2"

#define kUmeng_video_cell_event @"video_cell_event"
#define kUmeng_video_dota2_cell_event @"video_dota2_cell_event"


#define kUmeng_image_cell_event @"image_cell_event"
#define kUmeng_strategy_cell_event @"strategy_cell_event"