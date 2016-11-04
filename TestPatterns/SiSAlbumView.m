//
//  SiSAlbumView.m
//  TestPatterns
//
//  Created by Stanly Shiyanovskiy on 04.11.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSAlbumView.h"

@implementation SiSAlbumView {
    
    UIImageView* coverImage;
    UIActivityIndicatorView* indicator;
}

- (id) initWithFrame:(CGRect)frame
          albumCover:(NSString*)albumCover {
    
    self =[super initWithFrame:frame];
    
    if (self) {
        
        //Устанавливаем черный фон
        self.backgroundColor = [UIColor blackColor];
        
        //Создаем изображение с небольшим отступом - 5 пикселей от края
        coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        [self addSubview:coverImage];
        
        //Добавляем индикатор активности
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [self addSubview:indicator];
        
        [coverImage addObserver:self
                     forKeyPath:@"image"
                        options:0
                        context:nil];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SiSDownloadImageNotification"
         object:self
         userInfo:@{@"coverUrl":albumCover,
                    @"imageView":coverImage}];
    }
    
    return self;
}

- (void) dealloc {
    
    [coverImage removeObserver:self
                    forKeyPath:@"image"];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                        context:(void *)context {
    
    if ([keyPath isEqualToString:@"image"]) {
        
        [indicator stopAnimating];
    }
        
    
}

@end
