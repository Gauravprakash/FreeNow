//
//  LoginScreen.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 20/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "LoginScreen.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ConfirmationScreen.h"
#import "AppDelegate.h"
#import "CommonClass.h"
#import "AFNetworking.h"
#import "ProgressHUD.h"
@interface LoginScreen (){
    NSDictionary*data_Dict;
    CommonClass *manager;
}
@end
@implementation LoginScreen

# pragma mark => Life Cycle Methods

- (void)viewDidLoad{
    [super viewDidLoad];
    data_Dict=[[NSDictionary alloc]init];
    manager=[[CommonClass alloc]init];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark
#pragma mark -- login with Facebook

-(IBAction)fb_login:(id)sender{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [login logInWithReadPermissions:@[@"public_profile",@"user_friends", @"email",@"user_birthday",@"user_likes"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error){
        if (error){
            NSLog(@"Login process error %@",error);
            [login logOut];
        }
        else if (result.isCancelled){
            NSLog(@"User cancelled login");
        }
        else{
            NSLog(@"Login Success");
            if ([result.grantedPermissions containsObject:@"email"]){
                NSLog(@"result is:%@",result);
ConfirmationScreen* screen=[self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmationScreen"];
                    [self.navigationController pushViewController:screen animated:YES];
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
                    [self fetchInfoFromFaceBookResult];
                });
            }
        }
    }];
}
#pragma mark
#pragma mark -- fetching details From Facebook
-(void)fetchInfoFromFaceBookResult{
    if ([FBSDKAccessToken currentAccessToken]){
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, email, picture.type(large), gender "}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error){
                 NSLog(@"%@",result);
                 [[NSUserDefaults standardUserDefaults]setObject:result forKey:@"facebookresult"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
             }
         }];
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
