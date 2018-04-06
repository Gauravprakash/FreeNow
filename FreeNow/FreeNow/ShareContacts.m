//
//  ShareContacts.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 22/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//
#define BlockWeakSelf BlockWeakObject(self)
#define BlockWeakObject(o) __typeof(o) __weak
#import "ShareContacts.h"
#import "ShareContactsShell.h"
#import "CommonClass.h"
#import "ProgressHUD.h"
#import "FreeStatus.h"
#import "AFNetworking.h"

// MARK  - Properties
@interface ShareContacts (){
    NSArray  * user_name;
    NSArray  * user_email;
    CommonClass* manager;
    AppDelegate *appDelegate;
    NSArray* Array_table_Data;
    NSString *jsonString;
    NSData *jsonData2;
    NSMutableArray *arrayResult;
    NSMutableArray *busyResult;
    NSMutableArray *NotinFreeNowResult;
    NSMutableArray* datDict;
    UIActivityViewController *activityVC;
    UIView *viewToAdd;
    UIView *visualEffectView;
    UIWindow *window;
    UIButton *cancelButton;
    UIApplication *app;
    BOOL isStatusBarHidden;
}
@end
@implementation ShareContacts

# pragma mark -- Life Cycle Methods

-(void)viewDidLoad{
    [super viewDidLoad];
    manager=[[CommonClass alloc]init];
    manager.delegate=self;
   appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    Array_table_Data=[[NSArray alloc]init];
    user_name=[[NSArray alloc]init];
    user_email=[[NSArray alloc]init];
    datDict=[[NSMutableArray alloc]init];
    self.user_DataDict=[[NSDictionary alloc]init];
    self.user_unique_ID=[[NSUserDefaults standardUserDefaults]valueForKey:@"uniqueid"];
    NSLog(@"key _id = %@",self.user_unique_ID);
    self.emailArray=[[NSMutableArray alloc]init];
    self.contactNumbersArray=[[NSMutableArray alloc]init];
    if(!self.arrayTableData){
        self.arrayTableData=[[NSMutableArray alloc]init];
}
    self.m_tableView.dataSource=self;
    self.m_tableView.delegate =self;
    visualEffectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    visualEffectView.backgroundColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0f];
    visualEffectView.alpha=0.8f;
    [self.view addSubview:visualEffectView];
    visualEffectView.hidden=YES;
    window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
   [self fetchDatafromAddressBook];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton=YES;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden{
    return NO;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
-(void)fetchDatafromAddressBook{
    BOOL networkCase=[CommonClass networkReachable];
    if(networkCase==YES){
        [self performSelector:@selector(contactsDetailsFromAddressBook) withObject:nil afterDelay:0.00];
    }
    else{
        [self addCustomViewOnNetworkReachability];
    }
}
# pragma mark -- tableView datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [NotinFreeNowResult count];
            break;
        case 1:
            return [arrayResult count];
            break;
    }
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier=@"cell";
    ShareContactsShell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[ShareContactsShell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(indexPath.section==0){
        cell.m_Contact_List.text= [NSString stringWithFormat:@"%@",[[NotinFreeNowResult objectAtIndex:indexPath.row]valueForKey:@"name"]];
        cell.m_Contact_List.textColor=[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:0.7];
        cell.m_button_Share.layer.borderColor=[[UIColor colorWithRed:143.0/255.0 green:195.0/255.0 blue:255.0/255.0 alpha:0.7] CGColor];
        cell.m_button_Share.layer.borderWidth=1.0;
        cell.m_button_Share.clipsToBounds=YES;
        cell.m_button_Share.tag=indexPath.row;
    }
    if(indexPath.section==1){
        cell.m_Contact_List.text= [NSString stringWithFormat:@"%@",[[arrayResult valueForKey:@"name"]objectAtIndex:indexPath.row]];
        cell.m_button_Share.layer.borderColor=[[UIColor colorWithRed:143.0/255.0 green:195.0/255.0 blue:255.0/255.0 alpha:0.7] CGColor];
        cell.m_button_Share.layer.borderWidth=1.0;
        cell.m_button_Share.clipsToBounds=YES;
        cell.m_button_Share.userInteractionEnabled=NO;
        cell.m_Contact_List.textColor=[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:0.7];
    }
    [cell.m_button_Share addTarget:self
                            action:@selector(aContentView:) forControlEvents:UIControlEventTouchUpInside];
    tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    tableView.separatorColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
// tableview Row height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}
//tableview header title
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString*Title;
    switch (section) {
        case 0:Title=@"UnRegistered Users";
            break;
        case 1: Title= @"Registered Users";
            break;
        default:Title=@"";
            break;
    }
    return Title;
}
//customize appearance of header section
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:0.7];
    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentLeft;
}
#pragma mark

#pragma mark -- Getting Contacts From AddressBook

-(void)contactsDetailsFromAddressBook{
    // for version ios 9 and later on
  CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error){
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactBirthdayKey,CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error){
                NSLog(@"error fetching contacts %@", error);
            }
            else{
                NSString *phone;
                NSString *fullName;
                NSString *firstName;
                NSString *lastName;
                UIImage *profileImage;
                NSDateComponents *birthDayComponent;
                NSString *birthDayStr;
                NSString* email = @"";
                for (CNContact *contact in cnContacts){
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    lastName = contact.familyName;
                    birthDayComponent = contact.birthday;
                    if (birthDayComponent == nil){
                        // NSLog(@"Component: %@",birthDayComponent);
                        birthDayStr = @"DOB not available";
                    }
                    else{
                        birthDayComponent = contact.birthday;
                        NSInteger day = [birthDayComponent day];
                        NSInteger month = [birthDayComponent month];
                        NSInteger year = [birthDayComponent year];
                        // NSLog(@"Year: %ld, Month: %ld, Day: %ld",(long)year,(long)month,(long)day);
                        birthDayStr = [NSString stringWithFormat:@"%ld/%ld/%ld",(long)day,(long)month,(long)year];
                    }
                    if (lastName == nil) {
                        fullName=[NSString stringWithFormat:@"%@",firstName];
                    }else if (firstName == nil){
                        fullName=[NSString stringWithFormat:@"%@",lastName];
                    }
                    else{
                        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                    }
                    //// ----------------- >>>>>>>>>>>>>>> fetching Image from contacts  <<<<<<<<<<< ---------------------
                    UIImage* image=[UIImage imageWithData:contact.imageData];
                    if (image != nil) {
                        profileImage = image;
                    }
                    else{
                        profileImage = [UIImage imageNamed:@"apple"];
                    }
                    //// --------------- >>>>>>>>>>>>>>>  Get all phone numbers from contacts  <<<<<<<<<<< -------------------
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            [self.contactNumbersArray addObject:phone];
                        }
                    }
                    //// ----------------- >>>>>>>>>>>>>>> Get all E-Mail addresses from contacts <<<<<<<<<<< ---------------------
                    for (CNLabeledValue *label in contact.emailAddresses) {
                        email = label.value;
                        if ([email length] > 0) {
                            [self.emailArray addObject:email];
                        }
                    }
                    NSDictionary* personDict = @{@"PhoneNumbers":phone,
                                                 @"fullName":fullName,
                                                 @"Birthday":birthDayStr,
                                                 @"userEmailId":email,
                                                 @"userImage":profileImage
                                                 };
                    [self.arrayTableData addObject:personDict];
                    [self.arrayTableData count];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"\abcdhuU()-"];
                    [characterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
                    Array_table_Data= [[[[[self.arrayTableData valueForKey:@"PhoneNumbers"]componentsJoinedByString:@","]componentsSeparatedByCharactersInSet:characterSet]componentsJoinedByString:@""]componentsSeparatedByString:@","];
                    user_name =[[[self.arrayTableData valueForKey:@"fullName"]componentsJoinedByString:@","]componentsSeparatedByString:@","];
                    user_email =[[[self.arrayTableData valueForKey:@"userEmailId"]componentsJoinedByString:@","]componentsSeparatedByString:@","];
                    for(int i=0;i<[self.arrayTableData count];i++){
                        self.user_DataDict=@{@"name":  [user_name objectAtIndex:i],
                                             @"email" : [user_email objectAtIndex:i],
                                             @"phoneNo": [Array_table_Data objectAtIndex:i]
                                             };
                        [datDict addObject:self.user_DataDict];
                    }
                    NSError* error;
                    jsonData2 = [NSJSONSerialization dataWithJSONObject:datDict options:kNilOptions error:&error];
                    jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
                    NSLog(@"jsonString=%@",jsonString);
                    NSLog(@"Contact details count = %lu",(unsigned long)[self.arrayTableData count]);
                    [self performSelector:@selector(ApiCallingToShowContactListing) withObject:nil afterDelay:0.01];
                });
            }
        }
    }];
}
// Activity controller Action
-(void)aContentView:(UIButton*)sender{
    if([CommonClass networkReachable]){
        NSString *textToShare = @"Let's hang!";
        NSArray *objectsToShare = @[textToShare];
        dispatch_queue_t queue = dispatch_queue_create("openActivityIndicatorQueue", NULL);
        dispatch_async(queue, ^{
            activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:activityVC animated:YES completion:nil];
                [self handlingActivityControllerAction];
            });
        });
    }
    else{
        [self addCustomViewOnNetworkReachability];
    }
}
# pragma mark ->> hitting Api's

-(void)ApiCallingToShowContactListing{
    NSDictionary *paramz = @{@"method": @"contactlistwithdetails",
                             @"userid": [NSString stringWithFormat:@"%@",self.user_unique_ID],
                             @"data"  : jsonString
                             };
    [manager executeAPIRequestForMethod:@"contactlistwithdetails" Anddictdata:paramz];
    [ProgressHUD show:@"Loading..."];
}
// Getting result from Api
-(void)GetResults:(NSDictionary *)result{
    [ProgressHUD dismiss];
    NSString *m_Success=[NSString stringWithFormat:@"%@", [result objectForKey:@"success"]];
    [[NSUserDefaults standardUserDefaults]setObject:[[result objectForKey:@"AvailableContactList"]valueForKey:@"userid"] forKey:@"uniqueUserId"];
    if([m_Success intValue]==1)
    {    [ProgressHUD dismiss];
        arrayResult=[[NSMutableArray alloc]init];
        busyResult=[[NSMutableArray alloc]init];
        NotinFreeNowResult=[[NSMutableArray alloc]init];
        for (int i=0; i<[[result valueForKey:@"AvailableContactList"] count]; i++) {
            [arrayResult addObject:[[result valueForKey:@"AvailableContactList"] objectAtIndex:i]];
        }
        for(int i=0;i<[[result valueForKey:@"BusyContactList"]count];i++){
            [busyResult addObject:[[result valueForKey:@"BusyContactList"]objectAtIndex:i]];
        }
        
        for(int i=0;i<[[result valueForKey:@"NotInFreenow"]count];i++){
            [NotinFreeNowResult addObject:[[result valueForKey:@"NotInFreenow"]objectAtIndex:i]];
        }
        [self.m_tableView reloadData];
 }
    else
    {    if([result count] == 0){
        NSLog(@"Data Count is null");
    }
    else
        [CommonClass alertView:self title:@"" message:[result objectForKey:@"message"]];
    }
}
-(void)error{
    [ProgressHUD dismiss];
    [CommonClass alertView:self title:@"!Error" message:@"Error in Network."];
}
-(void)errorResult:(NSError *)error{
    NSLog(@"Error result shown : %@",error.localizedDescription);
}
//handling Activity controller Action
-(void)handlingActivityControllerAction{
    activityVC.completionWithItemsHandler= ^(NSString *activityType,
                                             BOOL completed,
                                             NSArray *returnedItems,
                                             NSError *error){
        __weak typeof(self) weakSelf = self;
        if (completed){
            
            [weakSelf addCustomViewOnMessageSent];
        }
        else{
            FreeStatus*status=[weakSelf.storyboard instantiateViewControllerWithIdentifier:@"FreeStatus"];
            status.Available_user_id=arrayResult;
            status.Busy_user_id=busyResult;
            [weakSelf.navigationController pushViewController:status animated:YES];
        }
        if (error){
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}
//-->>>>>>>>>>>>>>>>>>>  Custom view once sharing done successfully ->>>>>>>>>>>>>>>>>>>>>>>>> //
-(void)addCustomViewOnMessageSent{
    visualEffectView.hidden=NO;
    NSArray*nib=[[NSBundle mainBundle]loadNibNamed:@"Requestsent" owner: self options:nil];
    viewToAdd=[nib objectAtIndex:0];
    viewToAdd.frame=CGRectMake(30, window.frame.size.height/2-80, window.frame.size.width-60,120);
    viewToAdd.layer.cornerRadius=10.0f;
    viewToAdd.clipsToBounds=YES;
    [self.view addSubview:viewToAdd];
    UIButton *okayDone = (UIButton *)[viewToAdd viewWithTag:114];
    [okayDone addTarget:self action:@selector(removesuperView:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)removesuperView:(UIButton*)sender{
    visualEffectView.hidden=YES;
    [self prefersStatusBarHidden];
    [viewToAdd removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)addCustomViewOnNetworkReachability{
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

-(void)contactAPIhittingtosavedetailsoverPHPwebserver{
    
    NSURL *googleURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://54.229.178.2/freenow/api/index.php"]];
    NSMutableURLRequest *mutableRequest=[[NSMutableURLRequest alloc]initWithURL:googleURL];
    [mutableRequest setHTTPMethod:@"POST"];
    [mutableRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
    NSDictionary* paramz = @{@"method": @"contactlistwithdetails",
                            @"userid": [NSString stringWithFormat:@"%@",self.user_unique_ID],
                            @"data"  : jsonString
                            };
    
    NSError *err;
    NSData *dataHandling=[NSJSONSerialization dataWithJSONObject:paramz options:0 error:&err];
    NSString *myString=[[NSString alloc]initWithData:dataHandling encoding:NSUTF8StringEncoding];
    NSLog(@"my String values =%@",myString);
   [mutableRequest setHTTPBody:myString];

    //convert back to dictionary
    
    NSError *error;
    NSData *myData=[myString dataUsingEncoding:NSUTF8StringEncoding ];
    NSDictionary *response;
    if(response!=nil){
        response= (NSDictionary*)[NSJSONSerialization  JSONObjectWithData:myData options:NSJSONReadingMutableContainers error:&error];
    }
    NSLog(@"Response Dictionary :%@",response);
    
    
    
    
    
}

@end
