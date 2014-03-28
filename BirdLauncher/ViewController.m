//
//  ViewController.m
//  BirdLauncher
//
//  Created by 安川 尚宏 on 2014/03/22.
//  Copyright (c) 2014年 Naohiro Yasukawa. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "StartViewController.h"
#import "VincluLed.h"

@interface ViewController (){
    VincluLed* waveUtil;
    int sendFrag;
    NSMutableArray *results;
}

@end

@implementation ViewController


- (void)viewDidLoad
{
    //ウィンクルの初期化
    [super viewDidLoad];
    waveUtil = [[VincluLed alloc] initialize];

    //WebSocket送信フラグの初期化
    sendFrag = 0;
    
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
    
    //結果配列の初期化
    results = [[NSMutableArray alloc] init];
    
    //
    //NSString* name = StartViewController.playerStr;
    
    
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
        //self.resultImage.hidden = NO;
        
        //一度だけ、WebSocketに送る
        if (sendFrag == 0){
        //WebSocketに送信する。実際に送るのは{"id":"1"}だが、\で"をエスケープしている。
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:delegate.playerName forKey:@"person"];
        //DicionaryをJSONに変換
        NSError *error = nil;
        NSData *data = nil;
        if([NSJSONSerialization isValidJSONObject:dict]){
        data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"%@",data);
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
        [socket send:data];
        //[socket send:@"{\"person\":\"1\"}"];
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
    NSString *jsonString =[message description];
    
    // JSON 文字列をそのまま NSJSONSerialization に渡せないのでNSData に変換する
    //NSData *jsonData = [jsonString dataUsingEncoding:NSUnicodeStringEncoding];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    // JSON を NSDictionary に変換する
    NSError *error;
    NSDictionary *jsonParser = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
    
    NSDictionary *dic1 = [jsonParser objectForKey:@"person"];
    NSLog(@"%@", dic1);

    NSDictionary *dic2 = [jsonParser objectForKey:@"time"];
    NSLog(@"%@", dic2);

    //結果を格納
    [results addObject:jsonParser];
    
    
    NSString *rank1 = [[results objectAtIndex:0]objectForKey:@"person"];
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    //結果のラベル表示
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(120, 220, 300, 300);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor yellowColor];
    label.font = [UIFont fontWithName:@"AppleGothic" size:50];
    //label.textAlignment = UITextAlignmentCenter;
    label.transform = CGAffineTransformMakeRotation(M_PI * 270 / 180.0);  // 90度回転
    
    //自分と同じ名前の場合、PlayerName WIN!
    if([rank1 isEqualToString:delegate.playerName])
    {
        NSString *strResult = [NSString stringWithFormat:@"%@ WIN!",delegate.playerName];
        label.text = strResult;
        [self.view addSubview:label];
        
    //自分の名前と違う場合、PlayerName LOSE!
    }else{
        NSString *strResult = [NSString stringWithFormat:@"%@ LOSE!",delegate.playerName];
        label.text = strResult;
        [self.view addSubview:label];
    }

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
