//
//  RadarAnimation.h
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 28/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadarAnimation : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *pulsingImage;
@property (strong, nonatomic) UITableView* m_TableView;



@end
