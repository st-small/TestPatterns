//
//  SiSPersistencyManager.h
//  TestPatterns
//
//  Created by Stanly Shiyanovskiy on 04.11.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SiSAlbum.h"

@interface SiSPersistencyManager : NSObject

- (NSArray*) albums;
- (void) addAlbum:(SiSAlbum*)album atIndex:(NSUInteger)index;
- (void) deleteAlbumAtIndex:(NSUInteger)index;
- (void) saveImage:(UIImage*)image filename:(NSString*)filename;
- (UIImage*) getImage:(NSString*)filename;
- (void) saveAlbums;


@end
