//
//  ViewController.h
//  BirdLauncher
//
//  Created by 安川 尚宏 on 2014/03/22.
//  Copyright (c) 2014年 Naohiro Yasukawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "SRWebSocket.h"

@interface ViewController : UIViewController<UIAccelerometerDelegate,SRWebSocketDelegate>
{
    SRWebSocket *socket;
}

@property (weak, nonatomic) IBOutlet UIImageView *resultImage;


@end
