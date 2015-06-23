//
//  ViewController.m
//  TestHttpIcomet
//
//  Created by venkman on 6/19/15.
//  Copyright © 2015 xingqiba. All rights reserved.
//

#import "ViewController.h"
#include "curl/curl.h"

@interface ViewController ()

@end

size_t icomet_callback(char *ptr, size_t size, size_t nmemb, void *userdata){
    const size_t sizeInBytes = size*nmemb;
    NSData *data = [[NSData alloc] initWithBytes:ptr length:sizeInBytes];
    NSString* s = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%@|", s);
    // beware of multi-thread issue
    return sizeInBytes;
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self performSelectorInBackground:@selector(startStreaming) withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startStreaming{
    CURL *_curl = curl_easy_init();
    curl_easy_setopt(_curl, CURLOPT_URL, "http://192.168.1.53:8100/stream?cname=test&token=4f9942d242f308830d8caeca4fffe964");
    curl_easy_setopt(_curl, CURLOPT_NOSIGNAL, 1L);  // try not to use signals
    curl_easy_setopt(_curl, CURLOPT_USERAGENT, curl_version()); // set a default user agent
    curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, icomet_callback);
    curl_easy_perform(_curl);
    curl_easy_cleanup(_curl);
}

@end
