//
//  ShareContactsShell.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 24/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "ShareContactsShell.h"

@implementation ShareContactsShell

- (void)awakeFromNib{
    self.m_button_Share.layer.borderColor=[[UIColor colorWithRed:143.0/255.0 green:195.0/255.0 blue:255.0/255.0 alpha:0.7] CGColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
