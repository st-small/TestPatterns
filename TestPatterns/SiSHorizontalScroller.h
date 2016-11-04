//
//  SiSHorizontalScroller.h
//  TestPatterns
//
//  Created by Stanly Shiyanovskiy on 04.11.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SiSHorizontalScrollerDelegate;

@interface SiSHorizontalScroller : UIView

@property (weak) id <SiSHorizontalScrollerDelegate> delegate;

- (void) reload;

@end

@protocol SiSHorizontalScrollerDelegate <NSObject>

@required

// Спросить делегата, сколько представлений мы покажем внутри горизонтального скроллера
- (NSInteger)numberOfViewsForHorizontalScroller:(SiSHorizontalScroller*)scroller;

// Попросить делегата получить представление по индексу <index>
- (UIView*)horizontalScroller:(SiSHorizontalScroller*)scroller viewAtIndex:(int)index;

// Сообщить делегату о нажатии на представлении по индексу <index>
- (void)horizontalScroller:(SiSHorizontalScroller*)scroller clickedViewAtIndex:(int)index;

@optional

// Спросить делегата, какое из представлений отобразить при открытии (метод необязательный, по умолчанию 0, если делегат не реализукет метод)
- (NSInteger)initialViewIndexForHorizontalScroller:(SiSHorizontalScroller*)scroller;


@end
