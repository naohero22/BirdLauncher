//
//  VincluLed.m
//  WaveSample
//
//  Created by 古川 信行 on 2014/02/08.
//  Copyright (c) 2014年 古川 信行. All rights reserved.
//  参考
//  http://d.hatena.ne.jp/uosoft/20110502/1304264193
//

#import "VincluLed.h"

@implementation VincluLed

@synthesize phaseL;
@synthesize phaseR;
@synthesize SampleRate;
@synthesize frequencyL;
@synthesize frequencyR;
@synthesize invertL;
@synthesize invertR;
@synthesize isPlay;

-(id) initialize{
    
    // サンプリングレートの設定
    SampleRate = 44100.0f;  // 44.1KHz
    
    // ビットレートの設定
    BitRate = 8;  // 8bit
    
    // 再生する音程の周波数
    frequencyL = 440.0;  // A(ラ)
    frequencyR = 440.0;  // A(ラ)
    
    // AudioComponentのAudioComponentDescriptionを用意する
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_RemoteIO;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    
    // AudioComponentの定義を取得
    AudioComponent ac = AudioComponentFindNext(NULL, &acd);
    
    // AudioComponentをインスタンス化
    AudioComponentInstanceNew(ac, &au);
    
    // AudioComponentを初期化
    AudioUnitInitialize(au);
    
    // コールバックの設定
    AURenderCallbackStruct CallbackStruct;
    CallbackStruct.inputProc = renderer;     // ここでコールバック時に実行するメソッドを指定
    CallbackStruct.inputProcRefCon = (__bridge void*)self;
    
    // コールバックの設定をAudioUnitへ設定
    AudioUnitSetProperty(au,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Input,
                         0,
                         &CallbackStruct,
                         sizeof(AURenderCallbackStruct));
    
    // AudioStreamBasicDescription(ASBD)の設定
    AudioStreamBasicDescription asbd;
    asbd.mSampleRate = SampleRate;
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
    asbd.mChannelsPerFrame = 2;
    asbd.mBytesPerPacket = sizeof(AudioUnitSampleType);
    asbd.mBytesPerFrame = sizeof(AudioUnitSampleType);
    asbd.mFramesPerPacket = 1;
    asbd.mBitsPerChannel = BitRate * sizeof(AudioUnitSampleType);
    asbd.mReserved = 0;
    
    // AudioUnitにASBDを設定
    AudioUnitSetProperty(au,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         0,
                         &asbd,
                         sizeof(asbd));
    
    return self;
}

-(void) start{
    // 再生開始
    AudioOutputUnitStart(au);
    isPlay = YES;
}

-(void) stop{
    // 再生停止
    AudioOutputUnitStop(au);
    isPlay = NO;
}

-(void) uninitialize {
    [self stop];
    
    // AudioUnitの解放
    AudioUnitUninitialize(au);
    AudioComponentInstanceDispose(au);
}

static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData) {
    
    //RenderOutputのインスタンスにキャストする
    VincluLed* def = (__bridge VincluLed*)inRef;
    
    // サイン波の計算に使う数値の用意
    float freqL = def.frequencyL * 2.0 * M_PI / def.SampleRate;
    // 値を書き込むポインタ
    AudioUnitSampleType *outL = ioData->mBuffers[0].mData;
    for (int i = 0; i < inNumberFrames; i++) {
        // 周波数を計算
        float wave = sin(def.phaseL);
        AudioUnitSampleType sample = wave * (1 << kAudioUnitSampleFractionBits);
        *outL++ = (def.invertL == NO)?sample:sample*-1.0f;
        
        def.phaseL += freqL;
    }
    
    // サイン波の計算に使う数値の用意
    float freqR = def.frequencyR * 2.0 * M_PI / def.SampleRate;
    
    // 値を書き込むポインタ
    AudioUnitSampleType *outR = ioData->mBuffers[1].mData;
    for (int i = 0; i < inNumberFrames; i++) {
        // 周波数を計算
        float wave = sin(def.phaseR);
        AudioUnitSampleType sample = wave * (1 << kAudioUnitSampleFractionBits);
        *outR++ = (def.invertR == NO)?sample:sample*-1.0f;
        def.phaseR += freqR;
    }
    
    return noErr;
    
};
@end
