//
//  SiSLibraryAPI.m
//  TestPatterns
//
//  Created by Stanly Shiyanovskiy on 04.11.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSLibraryAPI.h"
#import "SiSPersistencyManager.h"
#import "SiSHTTPClient.h"

@interface SiSLibraryAPI () {
    
    SiSPersistencyManager* persistencyManager;
    SiSHTTPClient* httpClient;
    BOOL isOnline;
}

@end

@implementation SiSLibraryAPI

- (id)init {
    
    self = [super init];
    if (self) {
        persistencyManager = [[SiSPersistencyManager alloc] init];
        httpClient = [[SiSHTTPClient alloc] init];
        isOnline = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(downloadImage:)
                                                     name:@"SiSDownloadImageNotification"
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (SiSLibraryAPI*)sharedInstance {
    
    //Объявляем статическую переменную для хранения указателя на экземпляр класса (её значение будет доступно глобально из нашего класса).
    static SiSLibraryAPI* _sharedInstance = nil;
    
    //Объявляем статическую переменную dispatch_once_t, которая обеспечит, что код инициализации будет выполнен только один раз.
    static dispatch_once_t oncePredicate;

    //При помощи Grand Central Dispatch (GCD) выполняем инициализацию экземпляра SiSLibraryAPI. В этом суть паттерна «одиночка»: блок инициализации никогда не выполнится повторно.
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SiSLibraryAPI alloc] init];
    });
    
    return _sharedInstance;
}

- (NSArray*) albums {
    
    return [persistencyManager albums];
}

- (void) addAlbum:(SiSAlbum*)album atIndex:(int)index {
    
    [persistencyManager addAlbum:album atIndex:index];
    
    if (isOnline) {
        
        [httpClient postRequest:@"/api/addAlbum" body:[album description]];
    }
}

- (void) deleteAlbumAtIndex:(int)index {
    
    [persistencyManager deleteAlbumAtIndex:index];
    
    if (isOnline) {
        
        [httpClient postRequest:@"/api/deleteAlbum" body:[@(index) description]];
    }
}

- (void) downloadImage:(NSNotification*)notification {
    
    // downloadImage вызывается из уведомления и получает объект объект NSNotification в качестве параметра. Из этого параметра извлекаются URL изображения и указатель на UIImageView.
    NSString* coverUrl = notification.userInfo[@"coverUrl"];
    UIImageView* imageView = notification.userInfo[@"imageView"];
    
    // Получаем и отображаем изображение из PersistencyManager, если оно было загружено ранее.
    imageView.image = [persistencyManager getImage:[coverUrl lastPathComponent]];
    
    if (imageView.image == nil) {
        
        // Если изображение ещё не было загружено, получаем его с помощью HTTPClient.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage* image = [httpClient downloadImage:coverUrl];
            
            // Когда загрузка будет завершена, отобразим изображение в UIImageView и сохраним его локально.
            dispatch_sync(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [persistencyManager saveImage:image filename:[coverUrl lastPathComponent]];
            });
        });
    }
}

- (void) saveAlbums {
    
    [persistencyManager saveAlbums];
}
@end
