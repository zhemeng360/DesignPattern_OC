//
//  MZVisitorProtocol.h
//  设计模式
//
//  Created by A5 on 2020/1/15.
//  Copyright © 2020 孟哲. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MZElementProtocol;

@protocol MZVisitorProtocol <NSObject>

@required
- (void)visitElement:(id <MZElementProtocol>)element;

@end

NS_ASSUME_NONNULL_END
