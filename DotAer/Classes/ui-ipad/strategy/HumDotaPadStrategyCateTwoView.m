//
//  HumDotaStrategyCateTwoView.m
//  DotAer
//
//  Created by Kyle on 13-3-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaPadStrategyCateTwoView.h"
#import "HumDotaDataMgr.h"
#import "HumDotaNetOps.h"
#import "HumPadStrategyTableCell.h"
#import "Strategy.h"
#import "LeavesPadViewController.h"
#import "HumDotaUIOps.h"
#import "HMPopMsgView.h"
#import "HumDotaUserCenterOps.h"

#define kAllCategory @"1"
#define kStrategyPageEachNum 10

@interface HumDotaPadStrategyCateTwoView()<HumPadStrategyCellDelegate>

@property (nonatomic, retain) NSMutableArray *netArray;

@end

@implementation HumDotaPadStrategyCateTwoView
@synthesize netArray;

- (void)dealloc{
    self.netArray = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)loadLocalDataNeedFresh{
    self.dataArray = [[HumDotaDataMgr instance] readLocalSaveStrategyDataCat:kAllCategory];
    self.netArray = [NSMutableArray arrayWithArray:self.dataArray];
    _curPage = self.dataArray.count / kStrategyPageEachNum;
    if (_curPage != 0) {
        _curPage -= 1;
    }
    
    CGFloat lastUploadTs = [HumDotaUserCenterOps floatValueReadForKey:[NSString stringWithFormat:kDftStrategyCatSaveTimeForCat,kAllCategory]];
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];
    
    if (fNow - lastUploadTs > kRefreshStrategyInterVals) {
        return TRUE;
    }
    
    return FALSE;

    
}


-(void)loadNetworkData:(BOOL)bLoadMore {
    
    if (!bLoadMore) {
        _hasMore = YES;
        self.netArray = nil;
        _curPage = 0;
        self.nTaskId = [HumDotaNetOps strategyMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil page:_curPage];
    }else{
        _curPage++;
        self.nTaskId = [HumDotaNetOps strategyMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil page:_curPage];
    }
    
}

-(void)onLoadDataFinished:(DownloaderCallbackObj*)cb {
    BqsLog(@"HumDotaNewsCateTwoView onLoadDataFinished:%@",cb);
    
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        [HMPopMsgView showPopMsgError:cb.error Msg:nil Delegate:nil];
        
        return;
	}
    if (nil == self.netArray) {
        self.netArray = [[[NSMutableArray alloc] initWithCapacity:15] autorelease];
    }
    NSArray *arry = [Strategy parseXmlData:cb.rspData];
    if ([arry count] < kStrategyPageEachNum) {
        _hasMore = FALSE;
    }
    
    for (Strategy *strategy in arry) {
        [self.netArray addObject:strategy];
    }
    self.dataArray = self.netArray;
    [[HumDotaDataMgr instance] saveStrategyData:self.dataArray forCat:kAllCategory];
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];
    [HumDotaUserCenterOps floatVaule:fNow saveForKey:[NSString stringWithFormat:kDftStrategyCatSaveTimeForCat,kAllCategory]];
    
}


#pragma mark
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"cellId";
    HumPadStrategyTableCell *cell = (HumPadStrategyTableCell *)[aTableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[[HumPadStrategyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden] autorelease];
    }
    cell.delegate = self;
    
    if (indexPath.row % 2 == 0) {
        cell.bgImg.image = [[Env sharedEnv] cacheImage:@"dota_cell_singer_bg.png"];
    }else{
        cell.bgImg.image = [[Env sharedEnv] cacheImage:@"dota_cell_double_bg.png"];
    }
    
    
    Strategy *info = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat heigh = kOrgY;
    
    CGSize size = [info.title sizeWithFont:cell.title.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds)-2*kOrgX, 1000) lineBreakMode:UILineBreakModeWordWrap];
    CGRect frame = cell.title.frame;
    frame.size.height = size.height;
    cell.title.frame = frame;
    cell.title.text = info.title;
    heigh += size.height;
    
    
    size = [info.summary sizeWithFont:cell.summary.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds)-2*kOrgX, 1000) lineBreakMode:UILineBreakModeWordWrap];
    frame = cell.summary.frame;
    frame.origin.y = heigh+kTSGap;
    frame.size.height = size.height;
    cell.summary.frame = frame;
    cell.summary.text = info.summary;
    
    heigh += kTSGap+ size.height;
    
    frame = cell.timeLeb.frame;
    frame.origin.y = heigh+kSTGap;
    cell.timeLeb.frame = frame;
    cell.timeLeb.text = info.time;
    
    heigh += kSTGap+kTimeHeigh; //timelable heig
    
    heigh += kOrgY;
        
    frame = cell.frame;
    frame.size.height = heigh;
    cell.frame = frame;
    [cell setNeedsLayout];

    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Strategy *info = [self.dataArray objectAtIndex:indexPath.row];
    
    CGFloat height= kOrgY;
    
    CGSize size = [info.title sizeWithFont:kTitleFont constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds)-2*kOrgX, 1000) lineBreakMode:UILineBreakModeWordWrap];
    height += size.height;
    
    size = [info.summary sizeWithFont:kSummaryFont constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds)-2*kOrgX, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    height += kTSGap+size.height;
    
    height += kSTGap+kTimeHeigh; //timelable heig
    
    height += kOrgY;
    
    
    return height;
}


#pragma mark
#pragma makr HumStrategyCellDelegate
- (void)humNewsCell:(HumPadStrategyTableCell *)cell didSelectIndex:(NSIndexPath *)index{
    BqsLog(@"HumDotaStrategyCateTwoView HumStrategyTableCell didSelectIndex section:%d row:%d",index.section,index.row);
    if (index.row >= self.dataArray.count) {
        BqsLog(@"HumDotaStrategyCateTwoView HumStrategyTableCell didSelectIndex row > all row");
        
        return;
    }
    
    Strategy *info = [self.dataArray objectAtIndex:index.row];
    LeavesPadViewController *leaves = [[[LeavesPadViewController alloc] initWithArtUrl:info.content articeId:info.articleId articlMd5:info.md5] autorelease];
    [HumDotaUIOps slideShowModalViewControler:leaves ParentVCtl:self.parCtl];

    
}

@end
