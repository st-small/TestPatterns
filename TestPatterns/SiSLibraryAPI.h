//
//  SiSLibraryAPI.h
//  TestPatterns
//
//  Created by Stanly Shiyanovskiy on 04.11.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiSAlbum.h"

@interface SiSLibraryAPI : NSObject

+ (SiSLibraryAPI*)sharedInstance;
- (NSArray*) albums;
- (void) addAlbum:(SiSAlbum*)album atIndex:(int)index;
- (void) deleteAlbumAtIndex:(int)index;
- (void) saveAlbums;

@end
