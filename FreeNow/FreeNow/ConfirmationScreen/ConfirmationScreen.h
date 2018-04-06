//
//  ConfirmationScreen.h
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 20/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClass.h"

@interface ConfirmationScreen : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,SampleProtocolDelegate>
@property (strong, nonatomic) IBOutlet UITextField *m_txt_country_name;
@property (strong, nonatomic) IBOutlet UITextField *m_txt_country_code;
@property (strong, nonatomic) IBOutlet UIButton *btn_Go;
- (IBAction)btn_Go:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_Right_Arrow;
- (IBAction)btn_Right_Arrow:(id)sender;
@property (strong, nonatomic) NSMutableArray*country_list;
@property (strong, nonatomic) IBOutlet UILabel *lbl_country_code;
@property (strong, nonatomic) IBOutlet UIView *m_pickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *m_pickCountry;
@property (strong, nonatomic) IBOutlet UITextField *m_text_Country;
@property (strong, nonatomic) IBOutlet UIButton *btn_Cancel;
@property (strong, nonatomic) IBOutlet UIButton *btn_Done;
@property (strong, nonatomic) IBOutlet UILabel *lbl_selectCountry;
@property (strong, nonatomic) IBOutlet UILabel *lbl_plusSign;
- (IBAction)btn_Done:(id)sender;
- (IBAction)btn_Cancel:(id)sender;


@end
