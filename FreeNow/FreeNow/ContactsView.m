//
//  ContactsView.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 21/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "ContactsView.h"
#import "AppDelegate.h"
#import "ShareContacts.h"

@interface ContactsView ()

@end
//MARK -Properties
@implementation ContactsView{
    UIView*visualEffectView;
}

#pragma mark => Life Cycle Methods

- (void)viewDidLoad{
    [super viewDidLoad];
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
// Button Action  to access Contacts
-(IBAction)m_access_Contacts:(id)sender{
    visualEffectView.hidden=NO;
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"FreeNow Would Like to Access Your Contacts"  message:@"To make it easier to connect with people you know and see their status please click OK"  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Don't Allow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        visualEffectView.hidden=YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        visualEffectView.hidden=YES;
        ShareContacts* share=[self.storyboard instantiateViewControllerWithIdentifier:@"ShareContacts"];
        [self.navigationController pushViewController:share animated:YES];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
