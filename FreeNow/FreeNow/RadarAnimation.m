//
//  RadarAnimation.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 28/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "RadarAnimation.h"
#import "SimpleTableCell.h"

@interface RadarAnimation (){
    NSArray* m_title;
    UITableView *tblView;
}
@end
@implementation RadarAnimation
- (void)viewDidLoad{
    [super viewDidLoad];
   self.view.backgroundColor=[UIColor redColor];
    m_title=[[NSArray alloc]initWithObjects:@"Layer",@"Table",@"Quick",@"System",@"Energy",nil];
    UINib *nib =  [UINib nibWithNibName:@"SimpleTableCell" bundle:nil];
    [self.m_TableView registerNib:nib forCellReuseIdentifier:@"CustomCellReuseID"];
    self.m_TableView=[self makeTableview];
    [self.view addSubview:self.m_TableView];
    [self.m_TableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identification=@"CustomCellReuseID";
   SimpleTableCell* cell= (SimpleTableCell* )[tableView dequeueReusableCellWithIdentifier:identification];
    if(!cell){
        cell = [[SimpleTableCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identification];
    }
    cell.lbl_apple.text=[NSString stringWithFormat:@"%@",[m_title objectAtIndex:indexPath.row]];
    cell.img_apple.image=[UIImage imageNamed:@"apple"];
    return cell; 
}
-(UITableView*)makeTableview{
    CGFloat x = 0;
    CGFloat y = 50;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - 50;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    UITableView* tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor redColor];
    tableView.rowHeight=45;
    tableView.separatorColor=[UIColor blackColor];
    tableView.sectionFooterHeight = 22;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    tableView.dataSource=self;
    tableView.delegate=self;
    return tableView;
}


@end
