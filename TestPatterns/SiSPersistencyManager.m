//
//  SiSPersistencyManager.m
//  TestPatterns
//
//  Created by Stanly Shiyanovskiy on 04.11.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSPersistencyManager.h"

@interface SiSPersistencyManager () {
    
    NSMutableArray* albums; //Массив всех альбомов
}

@end

@implementation SiSPersistencyManager

- (id) init {
    
    self = [super init];
    if (self) {
        
        NSData* data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/albums.bin"]];
        albums = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if (albums == nil) {
            albums = [NSMutableArray arrayWithArray:
                      @[[[SiSAlbum alloc] initWithTitle:@"Best of Bowie"
                                                 artist:@"David Bowie"
                                               coverUrl:@"https://s3.amazonaws.com/CoverProject/album/album_david_bowie_best_of_bowie.png"
                                                   year:@"1992"],
                        
                        [[SiSAlbum alloc] initWithTitle:@"It's My Life"
                                                 artist:@"No Doubt"
                                               coverUrl:@"https://s3.amazonaws.com/CoverProject/album/album_no_doubt_its_my_life_bathwater.png"
                                                   year:@"2003"],
                        
                        [[SiSAlbum alloc] initWithTitle:@"Nothing Like The Sun"
                                                 artist:@"Sting"
                                               coverUrl:@"https://s3.amazonaws.com/CoverProject/album/album_sting_nothing_like_the_sun.png"
                                                   year:@"1999"],
                        
                        [[SiSAlbum alloc] initWithTitle:@"Staring at the Sun"
                                                 artist:@"U2"
                                               coverUrl:@"https://s3.amazonaws.com/CoverProject/album/album_u2_staring_at_the_sun.png"
                                                   year:@"2000"],
                        
                        [[SiSAlbum alloc] initWithTitle:@"American Pie"
                                                 artist:@"Madonna"
                                               coverUrl:@"https://s3.amazonaws.com/CoverProject/album/album_madonna_american_pie.png"
                                                   year:@"2000"]]];
            
            [self saveAlbums];
        }
    }
    return self;
}

- (NSArray*) albums {
    
    return albums;
}

- (void) addAlbum:(SiSAlbum*)album atIndex:(NSUInteger)index {
    
    if (albums.count >= index) {
        
        [albums insertObject:album atIndex:index];
        
    } else {
        
        [albums addObject:album];
    }
    
}

- (void) deleteAlbumAtIndex:(NSUInteger)index {
    
    [albums removeObjectAtIndex:index];
    
}

- (void) saveImage:(UIImage *)image filename:(NSString *)filename {
    
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:filename atomically:YES];
}

- (UIImage*) getImage:(NSString *)filename {
    
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    
    if (!filename) {
        
        NSLog(@"Something wrong... You can't get the image!");
        
    }
    NSData* data = [NSData dataWithContentsOfFile:filename];
    
    return [UIImage imageWithData:data];
}

- (void) saveAlbums {
    
    NSString* filename = [NSHomeDirectory() stringByAppendingString:@"/Documents/albums.bin"];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:albums];
    [data writeToFile:filename atomically:YES];
}

@end
