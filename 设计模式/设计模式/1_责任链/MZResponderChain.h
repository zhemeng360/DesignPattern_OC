//
//  MZResponderChain.h
//  设计模式
//
//  Created by 孟哲 on 2020/1/7.
//  Copyright © 2020 孟哲. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MZResponderChain;

typedef void(^CompletionBlock)(BOOL handled);
typedef void(^ResultBlock)(MZResponderChain *handler, BOOL handled);

@interface MZResponderChain : NSObject

// 下一个响应者(响应链构成的关键)
@property (nonatomic, strong) MZResponderChain *nextBusiness;
// 响应者的处理方法
- (void)handle:(ResultBlock)result;

// 各个业务在该方法当中做实际业务处理
- (void)handleBusiness:(CompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
