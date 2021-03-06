//
//  LeavesCache.h
//  Reader
//
//  Created by Tom Brow on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LeavesPadViewDataSource;

@interface LeavesPadCache : NSObject {
	NSMutableDictionary *pageCache;
	id<LeavesPadViewDataSource> dataSource;
}

@property (nonatomic, assign) CGSize pageSize;
@property (assign) id<LeavesPadViewDataSource> dataSource;

- (id) initWithPageSize:(CGSize)aPageSize;
- (CGImageRef) cachedImageForPageIndex:(NSUInteger)pageIndex;
- (CGImageRef) reloadImageForPageIndex:(NSUInteger)pageIndex;
- (void) precacheImageForPageIndex:(NSUInteger)pageIndex;
- (void) minimizeToPageIndex:(NSUInteger)pageIndex;
- (void) flush;

@end
