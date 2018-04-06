//
//  UIView+Additions.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 21/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (void)setBorderForColor:(UIColor *)color width:(float)width radius:(float)radius{
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [color CGColor];
        self.layer.borderWidth = width;
}
    

@end
