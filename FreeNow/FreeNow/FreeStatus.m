//
//  FreeStatus.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 22/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "FreeStatus.h"
#import "FreeStatusShell.h"
#import "ProgressHUD.h"
#import "AppDelegate.h"
#import "ShareContacts.h"

// MARK  - Properties
@implementation FreeStatus{
    UIView *viewToAdd;
    UIColor *selectedFreeColor;
    UIColor*selectedBusyColor;
    UIView*visualEffectView;
    UIWindow* window;
    UIStoryboard *storyboard;
    AppDelegate *appDelegate;
    CommonClass* manager;
    NSString*user_ID;
    UIButton *cancelButton;
}
# pragma mark => Life Cycle Methods
- (void)viewDidLoad{
    [super viewDidLoad];
    manager=[[CommonClass alloc]init];
    manager.delegate=self;
    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSLog(@"Available_user_id=%@",self.Available_user_id);
    NSLog(@"Busy_user_id=%@",self.Busy_user_id);
    self.user_unique_ID=[[NSUserDefaults standardUserDefaults]valueForKey:@"uniqueid"];
    selectedFreeColor = [UIColor colorWithRed:80.0/255.0 green:227.0/255.0 blue:194.0/255.0 alpha:1.0];
    selectedBusyColor=[UIColor colorWithRed:208.0/255.0 green:2.0/255.0 blue:27.0/255.0 alpha:1.0];
    visualEffectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    visualEffectView.backgroundColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0f];
    visualEffectView.alpha=0.8f;
    [self.view addSubview:visualEffectView];
    visualEffectView.hidden=YES;
    window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushNotificationReceived:) name:@"pushNotification" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    [[self.m_free_SegmentControl.subviews objectAtIndex:1]setTintColor: selectedFreeColor];
    [[self.m_free_SegmentControl.subviews objectAtIndex:0]setTintColor: selectedBusyColor];
    self.m_free_tableView.separatorColor=[UIColor clearColor];
    self.navigationItem.hidesBackButton=YES; 
}
-(BOOL)prefersStatusBarHidden{
    return NO;
 }
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
// Segment Control Action
-(IBAction)m_free_SegmentControl:(id)sender {
    if([CommonClass networkReachable]==YES){
    [self ColorsForSelectedButton];
    [self addCustomViewOnSelectionofSegmentButton];
    [self ApiCallingToUpdateStatus];
    }
    else{
        [self addCustomViewForNetworkAvailability];
    }
}
-(void)ColorsForSelectedButton{
    if(self.m_free_SegmentControl.selectedSegmentIndex==0){
        [[self.m_free_SegmentControl.subviews objectAtIndex:0 ]setTintColor: selectedBusyColor];
    }
    else if (self.m_free_SegmentControl.selectedSegmentIndex==1){
        [[self.m_free_SegmentControl.subviews objectAtIndex:1 ]setTintColor: selectedFreeColor];
    }
    [self.m_free_tableView reloadData];
}
// Add Custom view on selection of Button index
-(void)addCustomViewOnSelectionofSegmentButton{
    visualEffectView.hidden=NO;
    NSArray*nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileUpdated" owner: self options:nil];
    viewToAdd=[nib objectAtIndex:0];
    viewToAdd.frame=CGRectMake(30, window.frame.size.height/2-80, window.frame.size.width-60,120);
    viewToAdd.layer.cornerRadius=10.0f;
    viewToAdd.clipsToBounds=YES;
    [self.view addSubview:viewToAdd];
    UIButton *okayDone = (UIButton *)[viewToAdd viewWithTag:110];
    [okayDone addTarget:self action:@selector(removesuperView:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)addCustomViewOnMessageSent{
    visualEffectView.hidden=NO;
    NSArray*nib=[[NSBundle mainBundle]loadNibNamed:@"Requestsent" owner: self options:nil];
    viewToAdd=[nib objectAtIndex:0];
    viewToAdd.frame=CGRectMake(30, window.frame.size.height/2-80, window.frame.size.width-60,120);
    viewToAdd.layer.cornerRadius=10.0f;
    viewToAdd.clipsToBounds=YES;
    [self.view addSubview:viewToAdd];
    UIButton *okayDone = (UIButton *)[viewToAdd viewWithTag:112];
    [okayDone addTarget:self action:@selector(removesuperView:) forControlEvents:UIControlEventTouchUpInside];
    }
# pragma mark => tableView datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName;
    switch (section){
        case 0:
            sectionName = @"Available Now";
            break;
        case 1:
            if(self.m_free_SegmentControl.selectedSegmentIndex==0){
                sectionName = @"Busy";
            }
            else{
                sectionName=@"Flexible";
            }
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount;
    switch (section){
        case 0:
            rowCount=[self.Available_user_id count];
            return rowCount;
            break;
        case 1:
            rowCount=[self.Busy_user_id count];
            return rowCount;
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:0.7];
    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentLeft;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* identifier=@"statusfree";
    FreeStatusShell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(!cell){
        cell=[[FreeStatusShell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    switch (indexPath.section){
        case 0:
            if(self.m_free_SegmentControl.selectedSegmentIndex==0){
                cell.user_label.text =[NSString stringWithFormat:@"%@",[[self.Available_user_id valueForKey:@"name"] objectAtIndex:indexPath.row]];
                [cell.btn_hangout setTag:indexPath.row];
                [cell.btn_hangout setBackgroundImage:[UIImage imageNamed:@"hangout"] forState:UIControlStateNormal];
                [cell.btn_hangout addTarget:self
                                     action:@selector(aHangoutAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                cell.user_label.text=[NSString stringWithFormat:@"%@",[[self.Available_user_id valueForKey:@"name"]objectAtIndex:indexPath.row]];
                [cell.btn_hangout setBackgroundImage:[UIImage imageNamed:@"hangout"]forState:UIControlStateNormal];
                [cell.btn_hangout removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
            }
            break;
        case 1:
            if(self.m_free_SegmentControl.selectedSegmentIndex==0){
                cell.user_label.text=[NSString stringWithFormat:@"%@",[[self.Busy_user_id valueForKey:@"name"] objectAtIndex:indexPath.row]];
                [cell.btn_hangout setBackgroundImage:[UIImage imageNamed:@"busy"] forState:UIControlStateNormal];
                [cell.btn_hangout addTarget:self
                                     action:@selector(aAlertView:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                cell.user_label.text=[NSString stringWithFormat:@"%@",[[self.Busy_user_id valueForKey:@"name"] objectAtIndex:indexPath.row]];
                [cell.btn_hangout setBackgroundImage:[UIImage imageNamed:@"busy"] forState:UIControlStateNormal];
                [cell.btn_hangout removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
            }
            break;
    }
    tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    return cell;
}
// Hangout Action.
-(void)aHangoutAction:(UIButton*)sender{
    BOOL networkReachability;
    networkReachability=[CommonClass networkReachable];
   if(networkReachability==YES){
    [self addCustomViewOnMessageSent];
    user_ID= [NSString stringWithFormat:@"%@",[[self.Available_user_id valueForKey:@"userid"] objectAtIndex:sender.tag]];
    NSLog(@"User Id=%@",user_ID);
     [self ApiCallingForPushNotificationServices];
    }
    else{
        [self addCustomViewForNetworkAvailability];
    }
}
//AlertView Action
-(void)aAlertView:(UIButton*)sender{
    if([CommonClass networkReachable]==YES){
    visualEffectView.hidden=NO;
    NSArray*nib=[[NSBundle mainBundle]loadNibNamed:@"CustomAlert" owner: self options:nil];
    viewToAdd=[nib objectAtIndex:0];
    viewToAdd.frame=CGRectMake(30, window.frame.size.height/2-20, window.frame.size.width-60,200);
    viewToAdd.layer.cornerRadius=10.0f;
    viewToAdd.clipsToBounds=YES;
    [self.view addSubview:viewToAdd];
    UIButton *okayButton = (UIButton *)[viewToAdd viewWithTag:105];
    okayButton.layer.cornerRadius=okayButton.frame.size.height/2;
    okayButton.clipsToBounds=YES;
    [okayButton addTarget:self action:@selector(removesuperView:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [self  addCustomViewForNetworkAvailability];
    }
}
//handleActivity
-(void)handleActivity:(UIButton*)sender{
    [viewToAdd removeFromSuperview];
    visualEffectView.hidden=YES;
    NSString *textToShare = @"Let's hang!";
    NSArray *objectsToShare = @[textToShare];
    dispatch_queue_t queue = dispatch_queue_create("openActivityIndicatorQueue", NULL);
    dispatch_async(queue, ^{
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:activityVC animated:YES completion:nil];
            });
});
}
//remove Superview Action
-(void)removesuperView:(UIButton*)sender{
    visualEffectView.hidden=YES;
    [viewToAdd removeFromSuperview];
}
# pragma mark => Api call to update your status

-(void)ApiCallingToUpdateStatus{
    NSDictionary *paramz=@{@"method" :@"updateStatus",
                           @"userid" :self.user_unique_ID,
                           @"status" :@"1"
                           };
    [manager executeAPIRequestForMethod:@"updateStatus" Anddictdata:paramz];
}
# pragma mark => Api calling to send Push Notification services

-(void)ApiCallingForPushNotificationServices{
    NSDictionary *params=@{@"method" :@"sendPushnotification",
                           @"userid" :self.user_unique_ID,
                           @"otheruserid" :user_ID
                           };
    [manager executeAPIRequestForMethod:@"sendPushnotification" Anddictdata:params];
}
// Getting results from Api
-(void)GetResults:(NSDictionary *)dict{
    NSString* m_success= [dict valueForKey:@"success"];
    if([[dict valueForKey:@"method"]isEqualToString:@"updateStatus"]){
        if([m_success intValue]==1){
            NSLog(@"Your profile status updated successfully!");
        }
    }
    else if ([[dict valueForKey:@"method"]isEqualToString:@"sendPushnotification"]){
        if([m_success intValue]==1)
        {
            NSLog(@"Notification fired successfully!");
        }
    }
    else{
        if ([dict count] == 0){
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
    [CommonClass alertView:self title:@"" message:@"Error in Network."];
}
# pragma mark => Push Notfication Received
-(void)pushNotificationReceived:(NSNotification*)notification{
    visualEffectView.hidden=NO;
    UIApplication *application;
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive||state==UIApplicationStateBackground){
       NSArray*nib=[[NSBundle mainBundle]loadNibNamed:@"AlertView" owner: self options:nil];
        viewToAdd=[nib objectAtIndex:0];
        viewToAdd.backgroundColor=[UIColor whiteColor];
        viewToAdd.frame=CGRectMake(30, self.view.frame.size.height/2-20, self.view.frame.size.width-60,200);
        viewToAdd.layer.cornerRadius=10.0f;
        viewToAdd.clipsToBounds=YES;
        [self.view addSubview:viewToAdd];
        UIButton *startChatting = (UIButton *)[viewToAdd viewWithTag:101];
        cancelButton=(UIButton*)[viewToAdd viewWithTag:102];
        UILabel*lbl_userName=(UILabel*)[viewToAdd viewWithTag:103];
        NSString*user_Identifier=[[NSUserDefaults standardUserDefaults]valueForKey:@"uniqueusername"];
        lbl_userName.text=[NSString stringWithFormat:@"%@ wants to get",user_Identifier];
        [startChatting addTarget:self action:@selector(handleActivity:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton addTarget:self action:@selector(removesuperView:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(application.applicationState == UIApplicationStateInactive){
        window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        ShareContacts *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@" ShareContacts"];
        window.rootViewController = viewController;
        [window makeKeyAndVisible];
    }
}
// deallocating
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addCustomViewForNetworkAvailability{
    NSArray*nib=[[NSBundle mainBundle]loadNibNamed:@"NetworkView" owner: self options:nil];
    viewToAdd=[nib objectAtIndex:0];
    viewToAdd.frame=CGRectMake(0, 0, window.frame.size.width,window.frame.size.height);
    viewToAdd.layer.cornerRadius=10.0f;
    viewToAdd.clipsToBounds=YES;
    [self.view addSubview:viewToAdd];
    cancelButton = (UIButton *)[viewToAdd viewWithTag:115];
    cancelButton.layer.cornerRadius=cancelButton.frame.size.height/2;
    cancelButton.clipsToBounds=YES;
    [cancelButton addTarget:self action:@selector(removesuperView:) forControlEvents:UIControlEventTouchUpInside];
}

@end
