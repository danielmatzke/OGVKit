//
//  OGVAudioBuffer.h
//  OgvDemo
//
//  Created by Brion on 11/5/13.
//  Copyright (c) 2013 Brion Vibber. All rights reserved.
//

@interface OGVAudioBuffer : NSObject

@property NSArray *pcm;
@property unsigned int channels;
@property unsigned int samples;

- (id)initWithPCM:(float **)pcm channels:(unsigned int)channels samples:(unsigned int)samples;
- (const float *)PCMForChannel:(unsigned int)channel;

@end
