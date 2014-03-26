//
//  VincluLed.h
//  WaveSample
//
//  Created by 古川 信行 on 2014/02/08.
//  Copyright (c) 2014年 古川 信行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

@interface VincluLed : NSObject{
    AudioUnit au;           // AudioUnit
    double    phaseL;       // 位相の保存
    double    phaseR;       // 位相の保存
    Float64   SampleRate;   // サンプリングレート
    UInt32    BitRate;      // ビットレート
    Float64   frequencyL;   // 再生する音程の周波数L
    Float64   frequencyR;   // 再生する音程の周波数R
    BOOL invertL,invertR;
    BOOL isPlay;
}

@property (nonatomic) double phaseL;
@property (nonatomic) double phaseR;
@property (nonatomic) Float64 SampleRate;
@property (nonatomic) Float64 frequencyL;
@property (nonatomic) Float64 frequencyR;
@property (nonatomic) BOOL invertL;
@property (nonatomic) BOOL invertR;
@property (nonatomic) BOOL isPlay;

-(id) initialize;
-(void) start;
-(void) stop;
-(void) uninitialize;

@end
