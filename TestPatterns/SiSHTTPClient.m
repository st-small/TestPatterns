//
//  SiSHTTPClient.m
//  TestPatterns
//
//  Created by Stanly Shiyanovskiy on 04.11.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSHTTPClient.h"

@implementation SiSHTTPClient

- (id)getRequest:(NSString*)url {
    
    return nil;
}

- (id)postRequest:(NSString*)url body:(NSString*)body {
    
    return nil;
}

- (UIImage*)downloadImage:(NSString*)url {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    return [UIImage imageWithData:data];
}

@end
