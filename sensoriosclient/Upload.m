//
//  Upload.m
//  uploadDemo
//
//  Created by jack on 14-9-5.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "Upload.h"
#import "RandomString.h"

@implementation Upload
{
    UIAlertView *prosess;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        if (prosess==nil) {
            prosess = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        }
    }
    return self;
}
- (void)uploadImage:(UIImage *)image toURL:(NSString *)imageUploadURL{
    
    NSURL *url = [NSURL URLWithString:imageUploadURL];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    //NSLog(@"%@", request.)
    // We need to add a header field named Content-Type with a value that tells that it's a form and also add a boundary.
    // I just picked a boundary by using one from a previous trace, you can just copy/paste from the traces.
    NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"utf-8" forHTTPHeaderField:@"Charset"];
    [request addValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    // end of what we've added to the header
    
    
    // the body of the post
    NSMutableData *body = [NSMutableData data];
    
    // Now we need to append the different data 'segments'. We first start by adding the boundary.
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    // Now append the image
    // Note that the name of the form field is exactly the same as in the trace ('attachment[file]' in my case)!
    // You can choose whatever filename you want.
    NSString *fileName = [RandomString randomStringFromTime];
    NSLog(@"%@",fileName);
    NSString *contentDisposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"%@.jpg\"\r\n\r\n",fileName];
    [body appendData:[ contentDisposition dataUsingEncoding:NSUTF8StringEncoding]];
    
    // We now need to tell the receiver what content type we have
    // In my case it's a png image. If you have a jpg, set it to 'image/jpg'
    //[body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Now we append the actual image data
    NSString *tem = [[NSString alloc]initWithData:body encoding:NSUTF8StringEncoding];
    NSLog(@"%@", tem);
    [body appendData:UIImageJPEGRepresentation(image, 0.75)];
    
    // and again the delimiting boundary
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    // adding the body we've created to the request
    [request setHTTPBody:body];
    //NSString *bodyStr = [[NSString alloc]initWithData:body encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",bodyStr);
    //NSLog(@"%@",body);
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self
                                                          startImmediately:YES];
    [prosess show];
    [connection start];
}
-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    prosess.title = @"正在上传";
    NSString *ratio = [NSString stringWithFormat:@"已传%d/%d",totalBytesWritten,totalBytesExpectedToWrite];
    prosess.message = ratio;
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *HTTPresponse = (NSHTTPURLResponse *)response;
    if (HTTPresponse.statusCode == 200) {
        //UIAlertView *response = [[UIAlertView alloc]initWithTitle:@"good" message:@"上传图片成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //[response show];
        prosess.title = @"完成！";
        NSLog(@"success!");
        NSLog(@"%ld\n%@",(long)HTTPresponse.statusCode,HTTPresponse.allHeaderFields);

    }
    else
    {
        UIAlertView *response = [[UIAlertView alloc]initWithTitle:@"no!" message:@"没传上去" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [response show];
        NSLog(@"%ld\n%@",(long)HTTPresponse.statusCode,HTTPresponse.allHeaderFields);
    }
}

@end
