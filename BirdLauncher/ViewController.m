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
    int sendFrag;
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
