//
//  FreeStatus.h
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 22/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CommonClass.h"

// MARK  - Properties
@interface FreeStatus : UIViewController<UITableViewDelegate,UITableViewDataSource,SampleProtocolDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *m_free_SegmentControl;
-(IBAction)m_free_SegmentControl:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *m_free_tableView;
@property(strong,nonatomic)NSArray*m_Contacts_list_Array;
@property(strong,nonatomic)NSString *user_unique_ID;
@property (strong, nonatomic) IBOutlet UIView *m_transParentview;
@property(strong,nonatomic)NSArray* Available_user_id;
@property(strong,nonatomic)NSArray* Busy_user_id;
@end
