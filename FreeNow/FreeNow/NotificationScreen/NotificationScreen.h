//
//  NotificationScreen.h
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 20/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CommonClass.h"

@interface NotificationScreen : UIViewController<SampleProtocolDelegate>
@property(nonatomic,strong)NSString*country_code;
@property(nonatomic,strong)NSString*user_phone;
@property(strong,nonatomic)NSString *user_unique_ID;

@end
