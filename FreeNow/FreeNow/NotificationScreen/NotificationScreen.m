//
//  NotificationScreen.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 20/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "NotificationScreen.h"
#import "ContactsView.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"

@interface NotificationScreen ()
@end
//MARK - Properties
@implementation NotificationScreen{
    AppDelegate* appDelegate;
    NSDictionary* data_Dict;
    CommonClass *manager;
    UIView *visualEffectView;
}

#pragma mark => Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    manager=[[CommonClass alloc]init];
    manager.delegate=self;
    NSLog(@"user phone number : %@",self.user_phone);
    NSLog(@"country code : %@",self.country_code);
    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    visualEffectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    visualEffectView.backgroundColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0f];
    visualEffectView.alpha=0.8f;
    [self.view addSubview:visualEffectView];
    visualEffectView.hidden=YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    visualEffectView.hidden=YES;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
// Button Action to access Notification
-(IBAction)enable_Notifications:(id)sender{
    visualEffectView.hidden=NO;
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"FreeNow would like to send you Notifications"  message:@"Notifications may include alerts, sounds and icon badges. These can be configured in settings."  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Don't Allow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        visualEffectView.hidden=YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        dispatch_async(dispatch_get_main_queue(),^{
            visualEffectView.hidden=YES;
            [self callingAPI];
            // [self performSelector:@selector(callingAPiForSettingServices) withObject:nil afterDelay:0.01];
            ContactsView* view=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactsView"];
            [self.navigationController pushViewController:view animated:YES];
        });
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    [appDelegate registerForRemoteNotification];
}
-(void)pushViewToAnotherController{
    ContactsView* view=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactsView"];
    [self.navigationController pushViewController:view animated:YES];
}

# pragma mark => Api calling for login data
-(void)callingAPI{
    data_Dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"facebookresult"];
    NSLog(@"Dictionary values are : %@",data_Dict);
    dispatch_queue_t queue = dispatch_queue_create("Facebook Login", NULL);
    dispatch_async(queue, ^{
    NSDictionary *paramz = @{@"method" : @"login",
                             @"facebookid":[NSString stringWithFormat:@"%@",[data_Dict valueForKey:@"id"]],
                             @"deviceToken":@"101",
                             @"deviceType":@"1",
                             @"gender":[data_Dict valueForKey:@"gender"],
                             @"countrycode":[NSString stringWithFormat:@"%@" ,self.country_code],
                             @"firstName":[NSString stringWithFormat:@"%@",[data_Dict valueForKey:@"first_name"]],
                             @"lastName" :[NSString stringWithFormat:@"%@",[data_Dict valueForKey:@"last_name"]],
                             @"image":[[[data_Dict valueForKey:@"picture"]valueForKey:@"data"]valueForKey:@"url"],
                             @"email":[NSString stringWithFormat:@"%@",[data_Dict valueForKey:@"email"]],
                             @"phoneNumber":[NSString stringWithFormat:@"%@",self.user_phone],
                             @"notification": @"1"
                             };
          dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
          [manager executeAPIRequestMethod:@"login" Anddictdata:paramz];
          });
    });
}
-(void)GetResults:(NSDictionary *)dict{
    NSString *m_success=[NSString stringWithFormat:@"%@", [dict objectForKey:@"success"]];
    if([[dict valueForKey:@"method"]isEqualToString:@"notificationOnOff"]){
        NSLog(@"your settings saved successfully");
    }
    else if([[dict valueForKey:@"method"]isEqualToString:@"login"]){
        if([m_success intValue]==1){
            NSString* user_id=[[[dict valueForKey:@"userDetail"]objectAtIndex:0]valueForKey:@"userid"];
            [[NSUserDefaults standardUserDefaults]setValue:user_id forKey:@"uniqueid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSString* user_first_name=[[[dict valueForKey:@"userDetail"]objectAtIndex:0]valueForKey:@"firstName"];
            [[NSUserDefaults standardUserDefaults]setValue:user_first_name forKey:@"uniqueusername"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }  else
    {
        if ([dict count]== 0){
            NSLog(@"Data Count is null");
        }
        else
            [CommonClass alertView:self title:@"" message:[dict objectForKey:@"message"]];
    }
}
-(void)errorResult:(NSError *)error{
    NSLog(@"Error result shown : %@",error.localizedDescription);
}
-(void)error{
    NSLog(@"Data not found");
}
# pragma mark => Api calling for setting services
-(void)callingAPiForSettingServices{
    self.user_unique_ID=[[NSUserDefaults standardUserDefaults]valueForKey:@"uniqueid"];
    NSDictionary* params=   @{@"method" :@"setting",
                              @"userid" :self.user_unique_ID,
                              @"onOff":@"1"
                              };
    [manager executeAPIRequestForMethod:@"setting" Anddictdata:params];
    NSLog(@"settings saved successfully");
}




@end
