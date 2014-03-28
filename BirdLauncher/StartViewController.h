//
//  StartViewController.h
//  BirdLauncher
//
//  Created by 安川 尚宏 on 2014/03/28.
//  Copyright (c) 2014年 Naohiro Yasukawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartViewController : UIViewController <UITextFieldDelegate>{
    
    NSString *playerStr;

}


@property (weak, nonatomic) IBOutlet UITextField *textField;


- (IBAction)clickStartBtn:(id)sender;

@end
