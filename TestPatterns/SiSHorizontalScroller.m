//
//  SiSHorizontalScroller.m
//  TestPatterns
//
//  Created by Stanly Shiyanovskiy on 04.11.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSHorizontalScroller.h"

// Определяем константы для удобной модификации внешнего вида на этапе разработки. Размеры представлений внутри скролла будут 100х100 пунктов с отступом 10 пунктов от прямоугольника, который их обрамляет.

#define VIEW_PADDING 10
#define VIEW_DIMENSIONS 100
#define VIEWS_OFFSET 100

// Класс HorizontalScroller реализует протокол UIScrollViewDelegate. Так как HorizontalScroller использует UIScrollView для прокрутки обложек альбомов, он должен знать о пользовательских событиях, например, когда пользователь остановил прокрутку.
@interface SiSHorizontalScroller () <UIScrollViewDelegate>
@end

// Собственно, создаём scroll view.
@implementation SiSHorizontalScroller {
    
    UIScrollView* scroller;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.delegate = self;
        [self addSubview:scroller];
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        [scroller addGestureRecognizer:tapRecognizer];
    }
    return self;
}


- (void)scrollerTapped:(UITapGestureRecognizer*)gesture {
    
    CGPoint location = [gesture locationInView:gesture.view];
    // Не используем enumerator, т.к. не хотим перечислять все дочерние представления. Мы хотим перечислить только те subviews, которые мы добавили:
    for (int index = 0; index < [self.delegate numberOfViewsForHorizontalScroller:self];  index++) {
        
        UIView* view = scroller.subviews[index];
        
        if (CGRectContainsPoint(view.frame, location)) {
            
            [self.delegate horizontalScroller:self clickedViewAtIndex:index];
            CGPoint offset = CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0);
            [scroller setContentOffset:offset animated:YES];
            break;
        }
    }
}

- (void) reload {
    
    // Если нет делегата, то нам тут нечего делать. Завершаем выполнение метода.
    if (self.delegate == nil) return;
    
    // Удаляем все дочерние представления (subviews), добавленные ранее.
    [scroller.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        [obj removeFromSuperview];
    }];
    
    // Все представления расположены начиная с некоторого смещения (VIEWS_OFFSET). В настоящее время это значение 100 пунктов, и оно может быть легко изменено в #define выше в этом файле.
    CGFloat xValue = VIEWS_OFFSET;
    for (int i = 0; i < [self.delegate numberOfViewsForHorizontalScroller:self]; i++) {
        
        // HorizontalScroller спрашивает у своего делегата все представления (UIView) одно за другим, и располагает их по горизонтали на определенном расстоянии друг от друга.
        xValue += VIEW_PADDING;
        UIView* view = [self.delegate horizontalScroller:self viewAtIndex:i];
        view.frame = CGRectMake(xValue, VIEW_PADDING, VIEW_DIMENSIONS, VIEW_DIMENSIONS);
        [scroller addSubview:view];
        xValue += VIEW_DIMENSIONS + VIEW_PADDING;
    }
    
    // Когда все представления на месте, установить размер скроллера, чтобы позволить пользователю осуществлять прокрутку между всеми альбомами.
    [scroller setContentSize:CGSizeMake(xValue + VIEWS_OFFSET, self.frame.size.height)];
    
    // HorizontalScroller смотрит: отвечает ли делегат на селектор сообщения initialViewIndexForHorizontalScroller:. Такая проверка нужна, потому что этот метод протокола является необязательным. Если делегат не реализует этот метод, в качестве значения по умолчанию берётся 0. Эта часть кода устанавливает вид прокрутки по центру представления, определённого делегатом (initialView).
    if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)]) {
        
        int initialView = [self.delegate initialViewIndexForHorizontalScroller:self];
        CGPoint offset = CGPointMake(initialView * (VIEW_DIMENSIONS + (2 * VIEW_PADDING)), 0);
        [scroller setContentOffset:offset animated:YES];
    }
}

- (void) didMoveToSuperview {
    
    [self reload];
}

- (void) centerCurrentView {
    
    int xFinal = scroller.contentOffset.x + (VIEWS_OFFSET / 2) + VIEW_PADDING;
    int viewIndex = xFinal / (VIEW_DIMENSIONS + (2 * VIEW_PADDING));
    xFinal = viewIndex * (VIEW_DIMENSIONS + (2 * VIEW_PADDING));
    [scroller setContentOffset:CGPointMake(xFinal, 0) animated:YES];
    [self.delegate horizontalScroller:self clickedViewAtIndex:viewIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        
        [self centerCurrentView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self centerCurrentView];
}
@end
