//
//  OGVDecoderTests.m
//  OgvDemo
//
//  Created by Brion on 11/2/13.
//  Copyright (c) 2013 Brion Vibber. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "OGVDecoder.h"

@interface OGVDecoderTests : XCTestCase

@end

@implementation OGVDecoderTests {
    OGVDecoder *decoder;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    decoder = [[OGVDecoder alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testItWorks
{
    XCTAssertNotNil(decoder, @"Decoder gets allocated!");
}

- (NSData *)loadAudioSample
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"samples/En-us-Wikipedia" ofType:@"oga"];
    return [NSData dataWithContentsOfFile:path];
}

- (void)testAudioFile
{
    NSData *data = [self loadAudioSample];
    XCTAssertEqual(data.length, (NSUInteger)13696, @"Sample file is as expected");

    XCTAssertFalse(decoder.dataReady);
    [decoder receiveInput:data];

    XCTAssertFalse(decoder.dataReady);
    while (!decoder.dataReady && [decoder process]) {
        // process that input!
    }
    XCTAssert(decoder.dataReady);

    XCTAssert(decoder.hasAudio);
    XCTAssertEqual(decoder.audioChannels, 1);
    XCTAssertEqual(decoder.audioRate, 44100);

    XCTAssertFalse(decoder.hasVideo);
}

- (NSData *)loadVideoSample
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"samples/Peacock_Mating_Call" ofType:@"ogv"];
    return [NSData dataWithContentsOfFile:path];
}

- (void)testVideoFile
{
    NSData *data = [self loadVideoSample];
    XCTAssertEqual(data.length, (NSUInteger)317364, @"Sample file is as expected");
    
    [decoder receiveInput:data];
    XCTAssertFalse(decoder.dataReady);
    while (!decoder.dataReady && [decoder process]) {
        // process that input!
    }
    XCTAssert(decoder.dataReady);
    
    XCTAssert(decoder.hasAudio);
    XCTAssertEqual(decoder.audioChannels, 1);
    XCTAssertEqual(decoder.audioRate, 44100);

    XCTAssert(decoder.hasVideo);
    XCTAssertEqual(decoder.frameWidth, 320);
    XCTAssertEqual(decoder.frameHeight, 240);
    XCTAssertEqual(decoder.frameRate, 15.0f);
    XCTAssertEqual(decoder.pictureWidth, 320);
    XCTAssertEqual(decoder.pictureHeight, 240);
    XCTAssertEqual(decoder.pictureOffsetX, 0);
    XCTAssertEqual(decoder.pictureOffsetY, 0);
    XCTAssertEqual(decoder.hDecimation, 1);
    XCTAssertEqual(decoder.vDecimation, 1);
}

- (void)testVideoFrames
{
    NSData *data = [self loadVideoSample];
    XCTAssertEqual(data.length, (NSUInteger)317364, @"Sample file is as expected");

    __block int frameCount = 0;
    decoder.onframe = ^(OGVFrameBuffer buffer) {
        frameCount++;
    };

    [decoder receiveInput:data];
    while ([decoder process]) {
        // process that input!
    }

    XCTAssertEqual(frameCount, 46, @"expect 46 frames in this file");
}

@end
