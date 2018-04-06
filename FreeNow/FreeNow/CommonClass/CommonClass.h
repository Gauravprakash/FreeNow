//
//  CommonClass.h
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 20/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SampleProtocolDelegate <NSObject>
-(void)GetResults:(NSDictionary *)dict;
-(void)error;
-(void)errorResult:(NSError *)error;
@end

@interface CommonClass : NSObject
@property (nonatomic, assign) id <SampleProtocolDelegate> delegate;
+(id)sharedInstance;
+(void)addPaddingView:(UITextField *)textfield;
+(void)alertView:(UIViewController *)controller title:(NSString *)title message:(NSString *)message;
+(BOOL) networkReachable;
-(NSDictionary *)executeAPIRequestForMethod:(NSString *)methodName Anddictdata:(NSDictionary*)dict; //for simple data calling
-(NSDictionary *)executeAPIRequestMethod:(NSString *)methodName Anddictdata:(NSDictionary*)dict;    //with Imagedata calling 
@end
