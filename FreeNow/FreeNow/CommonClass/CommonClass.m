//
//  CommonClass.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 20/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#define SERVER_URL  @"http://54.229.178.2/freenow/api/index.php"

#import "CommonClass.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "ContactsView.h"
#import "AFNetworking.h"
#import "Reachability.h"

@implementation CommonClass

static CommonClass * gSharedClient = nil;
//create Singleton class
+ (id)sharedInstance{
    if (!gSharedClient){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            gSharedClient = [[CommonClass alloc] init];
});
}
return gSharedClient;
}

// Add paddingview to UItextfield
+(void)addPaddingView:(UITextField *)textfield{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,55,5)];
    textfield.leftView=paddingView;
    textfield.leftViewMode=UITextFieldViewModeAlways;
}
//Checking Network Reachability
+(BOOL) networkReachable{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status!=NotReachable) {
        return YES ;
    }
    else
    return NO;
}
//Add Alert Action
+(void)alertView:(UIViewController *)controller title:(NSString *)title message:(NSString *)message{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
}];
    [alertController addAction:action];
    [controller presentViewController:alertController animated:YES completion:nil];
}

//Execute Api request
-(NSDictionary *)executeAPIRequestForMethod:(NSString *)methodName Anddictdata:(NSDictionary*)dict{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString* url=SERVER_URL;
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionTask *task , id responseObject){
         NSLog(@"JSON: Success");
         [[self delegate]GetResults:responseObject];
         NSLog(@"Response Object=%@",responseObject);
         }failure:^(NSURLSessionTask *operation ,NSError *error){
          NSLog(@"Error: %@", error);
          [[self delegate]errorResult:error];
     }];
    return nil;
}
//Execute Api request for imageData
-(NSDictionary*)executeAPIRequestMethod:(NSString *)methodName Anddictdata:(NSDictionary *)dict{
    AFHTTPSessionManager* manager=[[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString* url=SERVER_URL;
   [manager POST:url
       parameters:dict
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
    NSDictionary* facebook_Data=[[NSUserDefaults standardUserDefaults]valueForKey:@"facebookresult"];
    NSString*fb_image=[[[facebook_Data valueForKey:@"picture"]valueForKey:@"data"]valueForKey:@"url"];
    NSData* data_image=[NSData dataWithContentsOfURL:[NSURL URLWithString:fb_image]];
    [formData appendPartWithFileData:data_image
                                name:@"file"
                            fileName:@"Image name"
                            mimeType:@"image/jpeg"];
}progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
              if (responseObject != nil){
                  NSDictionary *jsonDictionary = responseObject; 
                  NSLog(@"jsonDictionary =%@",jsonDictionary);
                  [[self delegate]GetResults:jsonDictionary];
              }
          }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
              NSLog(@"Error: %@", error);
           [[self delegate]errorResult:error];
}];
return nil;
}



@end
