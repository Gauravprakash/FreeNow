//
//  NSString+CheckPoint.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 31/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "NSString+CheckPoint.h"

@implementation NSString (CheckPoint)

-(BOOL)isEmpty{
    if ([self isEqualToString:@""]){
        return YES;
    }  else{
        return NO;
    }
}

@end
