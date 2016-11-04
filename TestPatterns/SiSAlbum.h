//
//  SiSAlbum.h
//  TestPatterns
//
//  Created by Stanly Shiyanovskiy on 04.11.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiSAlbum : NSObject <NSCoding>

@property (readonly, copy, nonatomic) NSString* title;
@property (readonly, copy, nonatomic) NSString* artist;
@property (readonly, copy, nonatomic) NSString* genre;
@property (readonly, copy, nonatomic) NSString* coverUrl;
@property (readonly, copy, nonatomic) NSString* year;


- (id) initWithTitle:(NSString*)title
              artist:(NSString*)artist
            coverUrl:(NSString*)coverUrl
                year:(NSString*)year;

@end
