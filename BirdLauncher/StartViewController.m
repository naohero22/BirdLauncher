//
//  StartViewController.m
//  BirdLauncher
//
//  Created by 安川 尚宏 on 2014/03/28.
//  Copyright (c) 2014年 Naohiro Yasukawa. All rights reserved.
//

#import "AppDelegate.h"
#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController
@synthesize textField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //テキストフィールドの初期化
    textField.delegate = self;
    textField.placeholder = @"プレイヤー名を入力して下さい";
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; //消去ボタン
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //[textField resignFirstResponder];
    [self.view endEditing:YES];
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    delegate.playerName = textField.text;
    NSLog(@"%@",delegate.playerName);
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickStartBtn:(id)sender {
    
    
}
@end
