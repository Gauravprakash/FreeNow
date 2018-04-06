//
//  ShareContacts.h
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 22/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import "ShareContactsShell.h"
#import "FreeStatus.h"

// MARK  - Properties
@interface ShareContacts : UIViewController<UITableViewDelegate,UITableViewDataSource,SampleProtocolDelegate>
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) NSMutableArray* arrayTableData;
@property(strong, nonatomic)NSMutableArray *contactNumbersArray;
@property(strong, nonatomic)NSMutableArray *emailArray;
@property(strong,nonatomic)NSString *user_unique_ID;
@property(strong,nonatomic)NSDictionary * user_DataDict;
@end
