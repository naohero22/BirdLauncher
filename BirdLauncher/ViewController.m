//
//  ViewController.m
//  BirdLauncher
//
//  Created by 安川 尚宏 on 2014/03/22.
//  Copyright (c) 2014年 Naohiro Yasukawa. All rights reserved.
//

#import "ViewController.h"
#import "VincluLed.h"

@interface ViewController (){
    VincluLed* waveUtil;
    int start;
    int count;
    int launch;
    int sendFrag;
}

@end

@implementation ViewController

int start = 0;
int count = 0;
int launch = 0;
int sendFrag = 0;


- (void)viewDidLoad
{
    //ウィンクルの初期化
    [super viewDidLoad];
    waveUtil = [[VincluLed alloc] initialize];

    //加速度センサーの初期化
    UIAccelerometer *ac =[UIAccelerometer sharedAccelerometer];
    ac.updateInterval = 0.02;
    ac.delegate = self;
    
    //WebSocketにつなげる。(OPENする)
    NSURL *url = [NSURL URLWithString:@"ws://nodejs.moe.hm:8899"];
    socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:url]];
    socket.delegate = self;
    [socket open];
    
    //結果の画像をデフォルト非表示にする。
    self.resultImage.hidden = YES;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    //停止
    [waveUtil uninitialize];
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    //NSLog(@"x: %g", acceleration.x);
    //NSLog(@"y: %g", acceleration.y);
    //NSLog(@"z: %g", acceleration.z);
    
    //iPhoneを横に向けるとウィンクルが光る。
    if (acceleration.x > 0.6){
        waveUtil.frequencyL = 50;
        waveUtil.frequencyR = 3;
        [waveUtil start];
        
        //結果画像を表示する。
        self.resultImage.hidden = NO;
        
        //一度だけ、WebSocketに送る
        if (sendFrag == 0){
        //WebSocketに送信する。実際に送るのは{"id":"1"}だが、\で"をエスケープしている。
        [socket send:@"{\"id\":\"1\"}"];
        sendFrag++;
        }
        
    //iPhoneを下に向けるとウィンクルが消える。
    }else if ( acceleration.x <= 0.6){
        self.resultImage.hidden = YES;
        [waveUtil stop];
    }
}

//WebSocketで送信するメッセージ
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"webSocketDidOpen");
}

//WebSocketで受信するメッセージ
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"didReceiveMessage: %@", [message description]);
    
    /*
    NSData *jsonData = message;
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonData dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    NSString *userID = [[dic objectForKey:@"user"] objectForKey:@"id"];
 
    NSString *jsonString =[message description];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUnicodeStringEncoding];
    NSError *error;
    NSArray *array = [[NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];

    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in array)
    {
        NSString *str1 = [obj objectForKey:@"id"];
    }
    
    NSString * str2 = @"A";

    if(str1 == str2){
    self.firstLabel.text  = @"YOU WIN!";
    }else{
    self.firstLabel.text  = @"YOU LOSE!";
    }
    */
}


- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"error %@",error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"close");
}






/*
- (IBAction)pressStart:(id)sender {
    waveUtil.frequencyL = 100;
    waveUtil.frequencyR = 1;
    [waveUtil start];
}

- (IBAction)pressStop:(id)sender {
     [waveUtil stop];
}
*/

@end
