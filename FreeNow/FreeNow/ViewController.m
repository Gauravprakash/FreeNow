//
//  ViewController.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 20/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "ViewController.h"
#import "LoginScreen.h"
@interface ViewController ()
@end
@implementation ViewController{
LoginScreen* screen;
}
# pragma mark => Life Cycle Methods

- (void)viewDidLoad{
    [super viewDidLoad];
    screen=[[LoginScreen alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
