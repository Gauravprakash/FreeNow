//
//  ConfirmationScreen.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 20/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "ConfirmationScreen.h"
#import "UIView+Additions.h"
#import "CommonClass.h"
#import "AFNetworking.h"
#import "NotificationScreen.h"
#import "ProgressHUD.h"
#import "NSString+CheckPoint.h"
#import "Reachability.h"
#import "AppDelegate.h"

//MARK - properties
@interface ConfirmationScreen (){
    CommonClass *manager;
    NSDictionary* data_Dict;
    NSString*country_name;
    NSString* country_code;
    BOOL selectedPicker;
    BOOL confirmation;
    UIView *viewToAdd;
    UIButton *cancelButton;
}
@end
@implementation ConfirmationScreen

# pragma mark => Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedPicker =NO;
    self.country_list=[[NSMutableArray alloc]init];
    manager=[[CommonClass alloc]init];
    manager.delegate=self;
    data_Dict=[[NSDictionary alloc]init];
    self.lbl_country_code.hidden=YES;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self performSelector:@selector(getCountryCode) withObject:nil afterDelay:0.00];
  }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.m_text_Country.enabled=NO;
    self.m_txt_country_name.enabled=NO;
    self.m_pickerView.hidden=YES;
    self.lbl_plusSign.hidden=YES;
    self.navigationController.navigationBarHidden=YES;
    self.btn_Right_Arrow.enabled=YES;
    [CommonClass addPaddingView:self.m_txt_country_name];
    [CommonClass addPaddingView:self.m_txt_country_code];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.lbl_plusSign.hidden=YES;
    self.m_pickerView.hidden=YES;
    [ProgressHUD dismiss];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.m_txt_country_code setBorderForColor:[UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]width:1.0f radius:0.0f];
    [self.m_txt_country_name setBorderForColor:[UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]width:1.0f radius:0.0f];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

// Go button Action
- (IBAction)btn_Go:(id)sender {
    if (self.m_txt_country_code.text.isEmpty) {
        [CommonClass alertView:self title:@"Alert!" message:@"please enter your phone number"];
    }
    else{
        NotificationScreen* notification= [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationScreen"];
        notification.country_code =self.lbl_country_code.text;
        notification.user_phone=[NSString stringWithFormat:@"%@",self.m_txt_country_code.text];
        [self.navigationController pushViewController:notification animated:YES];
    }
}
// Right Arrow Button Action
- (IBAction)btn_Right_Arrow:(id)sender{
    [self.view endEditing:true];
    if (!self.country_list.count){
        [ProgressHUD show];
    }
    else{
        [ProgressHUD dismiss];
        self.m_pickerView.hidden = NO;
        [self.view bringSubviewToFront:self.m_pickerView];
    }
}
# pragma mark => PickerView datasource and delegates

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedPicker=YES;
    self.lbl_country_code.hidden=NO;
    country_name=[[self.country_list valueForKey:@"countryName"]objectAtIndex:row];
    country_code=[[self.country_list valueForKey:@"countryCode" ]objectAtIndex:row];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.country_list.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.country_list objectAtIndex:row]valueForKey:@"countryName"];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
# pragma mark => Api calling to get country code and country  name

-(void)getCountryCode{
    dispatch_queue_t queue = dispatch_queue_create("Facebook Login", NULL);
    dispatch_async(queue, ^{
    NSDictionary *paramz = @{@"method" : @"countryCode"};
//    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
    dispatch_async(dispatch_get_main_queue(),^{
    [manager executeAPIRequestForMethod:@"countryCode" Anddictdata:paramz];
    });
    });
    [ProgressHUD show:@"fetching..."];
}
-(void)GetResults:(NSDictionary *)dict{
    [ProgressHUD dismiss];
    NSString* m_success= [dict valueForKey:@"success"];
    if([m_success intValue]==1){
        self.country_list =[dict valueForKey:@"countryCode"];
        self.m_pickCountry.dataSource=self;
        self.m_pickCountry.delegate=self;
        [self.m_pickCountry reloadAllComponents];
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
    NSLog(@"Data not found");
}
//picker Done button Action
-(IBAction)btn_Done:(id)sender{
    if(selectedPicker){
        self.m_txt_country_name.text= [NSString stringWithFormat:@"%@",country_name];
        self.lbl_plusSign.hidden= NO;
        self.lbl_country_code.text=[NSString stringWithFormat:@"%@",country_code];
        self.m_pickerView.hidden =YES;
    }
    else{
        [CommonClass alertView:self title:@"Alert!" message:@"please select one component first from Picker."];
    }
}
//picker cancel Button Action
-(IBAction)btn_Cancel:(id)sender {
    self.m_pickerView.hidden=YES; 
}


@end
