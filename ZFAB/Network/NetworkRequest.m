//
//  NetworkRequest.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/30.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "NetworkRequest.h"

@implementation NetworkRequest

- (id)initWithRequestURL:(NSString *)urlString
              httpMethod:(NSString *)method
                finished:(requestDidFinished)finish {
    if (self = [super init]) {
        NSURL *url = [NSURL URLWithString:urlString];
        _request = [[NSMutableURLRequest alloc] initWithURL:url
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:20.0];
        _finishBlock = finish;
        if (method) {
            [_request setHTTPMethod:method];
        }
    }
    return self;
}

- (void)setPostBody:(NSData *)postData {
    [_request setHTTPMethod:@"POST"];
    NSString *postLength = [NSString stringWithFormat:@"%ld",[postData length]];
    [_request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [_request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
}

- (void)uploadImageData:(NSData *)imageData
              imageName:(NSString *)imageName
                    key:(NSString *)key {
    [_request setHTTPMethod:@"POST"];
    
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
    CFRelease(uuid);
    NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@",charset,stringBoundary];
    [_request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    //文件起始标识
    NSString *startBoundary = [NSString stringWithFormat:@"--%@\r\n",stringBoundary];
    //文件名和参数
    NSString *name = imageName;
    if (!name) {
        name = @"image.png";
    }
    NSString *fileName = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, name];
    //上传格式
    NSString *postContentType = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"application/octet-stream"];
    //结尾标识
    NSString *endBoundary = [NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary];
    
    NSMutableData *data = [NSMutableData data];
    [data appendData:[self postDataForString:startBoundary]];
    [data appendData:[self postDataForString:fileName]];
    [data appendData:[self postDataForString:postContentType]];
    [data appendData:imageData];
    [data appendData:[self postDataForString:endBoundary]];
    [_request setHTTPBody:data];
}

- (NSData *)postDataForString:(NSString *)postString {
    return [postString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)start {
    _requestConnection = [[NSURLConnection alloc] initWithRequest:_request
                                                         delegate:self
                                                 startImmediately:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _requestData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_requestData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (_finishBlock) {
        _finishBlock(YES,_requestData);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error = %@",error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (_finishBlock) {
        _finishBlock(NO,_requestData);
    }
}


@end
