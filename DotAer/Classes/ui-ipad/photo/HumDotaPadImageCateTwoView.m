//
//  PanguPhotoWallView.m
//  pangu
//
//  Created by yang zhiyun on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HumDotaPadImageCateTwoView.h"
#import "BqsUtils.h"
#import "HumDotaDataMgr.h"
#import "HumDotaUIOps.h"
#import "HumDotaNetOps.h"
#import "Env.h"
#import "Photo.h"
#import "EGORefreshTableHeaderView.h"
#import "HMPopMsgView.h"
#import "HumWebImageView.h"
#import "HumPadImageTableCell.h"
#import "HMImageViewController.h"
#import "HumDotaUserCenterOps.h"


#define kImageEachDownNum 10

@interface HumDotaPadImageCateTwoView()<HumImagePadTableCellDelegate>

@property (nonatomic, copy) NSString *imageCatId;

@property (nonatomic, retain) NSMutableArray *netArray;


@end

@implementation HumDotaPadImageCateTwoView
@synthesize netArray;
@synthesize imageCatId;
- (void)dealloc
{
    self.netArray = nil;
    self.imageCatId = nil;
    [super dealloc];
}





-(id)initWithDotaCatFrameViewCtl:(HumPadDotaBaseViewController*)ctl Frame:(CGRect)frame CategoryId:(NSString *)catId
{
    self = [super initWithDotaCatFrameViewCtl:ctl Frame:frame];
    if (self) {
        self.imageCatId = catId;
        

    }
    return self;
}




#pragma mark
#pragma mark instance method


- (BOOL)loadLocalDataNeedFresh{
    self.dataArray = [[HumDotaDataMgr instance] readLocalSaveImageDataCat:self.imageCatId];
    self.netArray = [NSMutableArray arrayWithArray:self.dataArray];
    _curPage = self.dataArray.count / kImageEachDownNum;
    if (_curPage != 0) {
        _curPage -= 1;
    }

    
    CGFloat lastUploadTs = [HumDotaUserCenterOps floatValueReadForKey:[NSString stringWithFormat:kDftImageCatSaveTimeForCat,self.imageCatId]];
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];
    
    if (fNow - lastUploadTs > kRefreshImageIntervalS) {
        return TRUE;
    }
    
    return FALSE;

    
       
}


-(void)loadNetworkData:(BOOL)bLoadMore {
    
    if (!bLoadMore) {
        _hasMore = YES;
        self.netArray = nil;
        _curPage = 0;
        self.nTaskId = [HumDotaNetOps imageMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil categoryId:self.imageCatId page:_curPage];
    }else{
        _curPage++;
        self.nTaskId = [HumDotaNetOps imageMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil categoryId:self.imageCatId page:_curPage];
    }
    
}



    

#pragma mark
#pragma mark Downlaoder Callback
-(void)onLoadDataFinished:(DownloaderCallbackObj*)cb {
    BqsLog(@"HumDotaImageCateTwoView onLoadDataFinished:%@",cb);
    
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        [HMPopMsgView showPopMsgError:cb.error Msg:NSLocalizedString(@"news.error.networkfailed", nil) Delegate:nil];
        return;
	}
    
    
    if(!self.netArray) self.netArray = [NSMutableArray arrayWithCapacity:20];
    NSArray *temp = [Photo parseXmlData:cb.rspData];
    
    if ([temp count] < kImageEachDownNum) {
        _hasMore = FALSE;
    }
    
    for (Photo *photo in temp) {
        [self.netArray addObject:photo];
    }
    
    if (self.netArray.count == 0) {
        [HMPopMsgView showPopMsgError:nil Msg:NSLocalizedString(@"pg.search.null", nil) RetMsg:nil RetStatus:nil];
    }
    
    self.dataArray = self.netArray;
    [[HumDotaDataMgr instance] saveImageData:self.dataArray forCat:self.imageCatId];
    
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];
    [HumDotaUserCenterOps floatVaule:fNow saveForKey:[NSString stringWithFormat:kDftImageCatSaveTimeForCat,self.imageCatId]];
   

}

#pragma mark
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    int plus = [self.dataArray count]%2 == 1?1:0;
    return [self.dataArray count]/2 + plus;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"cellId";
    HumPadImageTableCell *cell = (HumPadImageTableCell *)[aTableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[[HumPadImageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden] autorelease];
    }
    cell.delegate = self;
    
    CGRect frame = cell.frame;
    frame.size.height = 300;
    frame.size.width = CGRectGetWidth(self.bounds);
    cell.frame = frame;
    
    if ([self.dataArray count] <= indexPath.row*2) {
        BqsLog(@"self.dataArray count < indexPath.row *2 : %d",indexPath.row*2);
        return nil;
    }
    
    if (indexPath.row % 2 == 0) {
        cell.bgImg.image = [[Env sharedEnv] cacheImage:@"dota_cell_singer_bg.png"];
    }else{
        cell.bgImg.image = [[Env sharedEnv] cacheImage:@"dota_cell_double_bg.png"];
    }
        
    Photo *leftinfo = [self.dataArray objectAtIndex:indexPath.row*2];
    
    frame = cell.leftImage.frame;
    frame.origin.x = kOrgX;
    frame.origin.y = kOrgY;
    frame.size.height = CGRectGetHeight(cell.frame)-2*kOrgY;
    frame.size.width = (CGRectGetWidth(cell.frame)-2*kOrgX-kGapW)/2;
    cell.leftImage.frame = frame;
    
    [cell.leftImage displayImage:[[Env sharedEnv] cacheImage:@"dota_photo_default.png"]];
    cell.leftImage.imgUrl = leftinfo.imageUrl;
    
    cell.rightImage.hidden = YES;
    
    if ([self.dataArray count] <= indexPath.row*2+1) {
        BqsLog(@"hidden right image self.dataArray count < indexPath.row *2+1 : %d",indexPath.row*2+1);
        return cell;
    }
    
    cell.rightImage.hidden = NO;
    frame.origin.x = CGRectGetMaxX(cell.leftImage.frame)+kGapW;
    cell.rightImage.frame = frame;
    
    [cell.rightImage displayImage:[[Env sharedEnv] cacheImage:@"dota_photo_default.png"]];
    Photo *rightInfo = [self.dataArray objectAtIndex:indexPath.row*2+1];
    cell.rightImage.imgUrl = rightInfo.imageUrl;
    
   
    return cell;
    
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  300;
}

#pragma mark
#pragma mark HumImageTableCellDelegate

- (void)humVideoCell:(HumPadImageTableCell *)cell didLeftAtSelectIndex:(NSIndexPath *)index{
    
    if ([self.dataArray count] <= index.row*2) {
        BqsLog(@"self.dataArray count < indexPath.row *2 : %d",index.row*2);
        return ;
    }
    
    Photo *info = [self.dataArray objectAtIndex:index.row*2];
    
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *sumAry = [NSMutableArray arrayWithCapacity:10];
    for (PhotoImg *photo in info.arrImgUrls) {
        
        BqsLog(@"cell at section: %d,row :%d url = %@",index.section,index.row,photo.url);
        [arry addObject:photo.url ];
        [sumAry addObject:photo.introduce];
    }
    
    HMImageViewController *image = [[[HMImageViewController alloc] initWithImgArray:arry SumArray:sumAry] autorelease];
    image.modalPresentationStyle = UIModalPresentationFullScreen;
    [HumDotaUIOps slideShowModalViewControler:image ParentVCtl:self.parCtl];
    
}
- (void)humVideoCell:(HumPadImageTableCell *)cell didRightAtSelectIndex:(NSIndexPath *)index{
    
    if ([self.dataArray count] <= index.row*2+1) {
        BqsLog(@"self.dataArray count < indexPath.row *2+1 : %d",index.row*2+1);
        return ;
    }
    
    Photo *info = [self.dataArray objectAtIndex:index.row*2+1];
    
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *sumAry = [NSMutableArray arrayWithCapacity:10];
    for (PhotoImg *photo in info.arrImgUrls) {
        
        BqsLog(@"cell at section: %d,row :%d url = %@",index.section,index.row,photo.url);
        [arry addObject:photo.url ];
        [sumAry addObject:photo.introduce];
    }
    
    HMImageViewController *image = [[[HMImageViewController alloc] initWithImgArray:arry SumArray:sumAry] autorelease];
    image.modalPresentationStyle = UIModalPresentationFullScreen;
    [HumDotaUIOps slideShowModalViewControler:image ParentVCtl:self.parCtl];
}



@end

