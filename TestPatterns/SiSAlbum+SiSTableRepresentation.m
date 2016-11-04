//
//  SiSAlbum+SiSTableRepresentation.m
//  TestPatterns
//
//  Created by Stanly Shiyanovskiy on 04.11.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSAlbum+SiSTableRepresentation.h"

@implementation SiSAlbum (SiSTableRepresentation)

- (NSDictionary*) tr_tableRepresentation {
    
    return @{@"titles":@[@"Исполнитель", @"Альбом", @"Жанр", @"Год"],
             @"values":@[self.artist, self.title, self.genre, self.year]};
}

@end
