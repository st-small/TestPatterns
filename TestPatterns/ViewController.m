//
//  ViewController.m
//  TestPatterns
//
//  Created by Stanly Shiyanovskiy on 04.11.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "ViewController.h"
#import "SiSLibraryAPI.h"
#import "SiSAlbum+SiSTableRepresentation.h"
#import "SiSHorizontalScroller.h"
#import "SiSAlbumView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, SiSHorizontalScrollerDelegate> {
    
    UITableView* dataTable;
    NSArray* allAlbums;
    NSDictionary* currentAlbumData;
    int currentAlbumIndex;
    SiSHorizontalScroller* scroller;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //Установить цвет фона в тёмно-синий.
    self.view.backgroundColor = [UIColor colorWithRed:0.76f
                                              green:0.81f
                                               blue:0.87f
                                              alpha:1.f];
    currentAlbumIndex = 0;
    
    //Получить список всех альбомов через API. Нам не нужно использовать PersistencyManager напрямую!
    allAlbums = [[SiSLibraryAPI sharedInstance] albums];
    
    //Создать UITableView. Мы заявляем, что наш ViewController — делегат и источник данных (data source) для UITableView, поэтому вся информация, которая нужна UITableView, будет предоставлена ViewController'ом.
    CGRect frame = CGRectMake(0.f, 120.f, self.view.frame.size.width, self.view.frame.size.height - 120.f);
    dataTable = [[UITableView alloc] initWithFrame:frame
                                             style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
    
    // Инициализация скроллера
    [self loadPreviousState];
    scroller = [[SiSHorizontalScroller alloc] initWithFrame:CGRectMake(0.f, 20.f, self.view.frame.size.width, 120.f)];
    scroller.backgroundColor = [UIColor colorWithRed:0.24f
                                               green:0.35f
                                                blue:0.49f
                                               alpha:1];
    scroller.delegate = self;
    [self.view addSubview:scroller];
    
    [self reloadScroller];
    
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}

- (void) showDataForAlbumAtIndex:(int)albumIndex {
    
    if (albumIndex < allAlbums.count) {
        
        SiSAlbum* album = allAlbums[albumIndex];
        currentAlbumData = [album tr_tableRepresentation];
        
    } else {
        
        currentAlbumData = nil;
    }
    
    [dataTable reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveCurrentState)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [currentAlbumData[@"titles"] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = currentAlbumData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentAlbumData[@"values"][indexPath.row];
    
    return cell;
}

#pragma mark - SiSHorizontalScrollerDelegate methods

- (void)horizontalScroller:(SiSHorizontalScroller *)scroller clickedViewAtIndex:(int)index {
    
    currentAlbumIndex = index;
    [self showDataForAlbumAtIndex:index];
}

- (NSInteger)numberOfViewsForHorizontalScroller:(SiSHorizontalScroller *)scroller {
    
    return allAlbums.count;
}

- (UIView*)horizontalScroller:(SiSHorizontalScroller *)scroller viewAtIndex:(int)index {
    
    SiSAlbum* album = allAlbums[index];
    return [[SiSAlbumView alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 100.f)
                                    albumCover:album.coverUrl];
}

- (void)reloadScroller {
    
    allAlbums = [[SiSLibraryAPI sharedInstance] albums];
    if (currentAlbumIndex < 0) {
        
        currentAlbumIndex = 0;
        
    } else if (currentAlbumIndex >= allAlbums.count) {
        
        currentAlbumIndex = allAlbums.count - 1;
        [scroller reload];
        
        [self showDataForAlbumAtIndex:currentAlbumIndex];
    }
}

- (void) saveCurrentState {
    
    // Когда пользователь закрывает приложение и потом снова к нам приходит, он хочет увидеть то же состояние, на котором он закончил. Для этого нужно сохранить текущий выбранный альбом. Здесь немного информации, поэтому можно использовать NSUserDefaults:
    [[NSUserDefaults standardUserDefaults] setInteger:currentAlbumIndex
                                               forKey:@"currentAlbumIndex"];
    [[SiSLibraryAPI sharedInstance] saveAlbums];
}

- (void) loadPreviousState {
    
    currentAlbumIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentAlbumIndex"];
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}

- (NSInteger) initialViewIndexForHorizontalScroller:(SiSHorizontalScroller *)scroller {
    
    return currentAlbumIndex;
}


@end
