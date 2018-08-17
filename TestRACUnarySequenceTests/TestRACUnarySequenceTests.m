//
//  TestRACUnarySequenceTests.m
//  TestRACUnarySequenceTests
//
//  Created by ys on 2018/8/16.
//  Copyright © 2018年 ys. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <ReactiveCocoa.h>
#import <RACUnarySequence.h>

@interface TestRACUnarySequenceTests : XCTestCase

@end

@implementation TestRACUnarySequenceTests

- (void)test_return
{
    RACUnarySequence *sequence = [RACUnarySequence return:@"xxx"];
    NSLog(@"return -- %@", sequence);
    
    // 打印日志：
    /*
     2018-08-16 17:21:03.940582+0800 TestRACUnarySequence[15973:17015192] return -- <RACUnarySequence: 0x600000238820>{ name = , head = xxx }
     */
}

- (void)test_tail
{
    RACUnarySequence *sequence = [RACUnarySequence return:@[@1, @2, @3]];
    NSLog(@"tail -- %@", sequence.tail);
    
    // 打印日志：
    /*
     2018-08-16 17:22:49.841689+0800 TestRACUnarySequence[16078:17019928] tail -- (null)
     */
}

- (void)test_bind
{
    RACUnarySequence *sequence = [RACUnarySequence return:@(1)];
    RACSequence *s = [sequence bind:^RACStreamBindBlock{
        return ^(id value, BOOL *stop) {
            return [RACUnarySequence return:@(100)];
        };
    }];
    NSLog(@"bind -- %@", s);
    
    // 打印日志：
    /*
     2018-08-16 17:25:01.532451+0800 TestRACUnarySequence[16176:17026442] bind -- <RACUnarySequence: 0x6000002341c0>{ name = , head = 100 }
     */
}

@end
