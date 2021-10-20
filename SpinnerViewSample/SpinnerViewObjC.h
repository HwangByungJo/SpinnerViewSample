//
//  SpinnerViewObjC.h
//  SpinnerViewSample
//
//  Created by HwangByungJo  on 2021/08/09.
//

#import <UIKit/UIKit.h>


@interface Pose : NSObject

@property (nonatomic) CFTimeInterval secondsSincePriorPose;
@property (nonatomic) CGFloat start;
@property (nonatomic) CGFloat length;

- (instancetype)initWithSecondsSincePriorPose:(CFTimeInterval)secondsSincePriorPose
                                        start:(CGFloat)start
                                       length:(CGFloat)length;

+ (Pose *)secondsSincePriorPose:(CFTimeInterval)secondsSincePriorPose
                          start:(CGFloat)start
                         length:(CGFloat)length;

@end

IB_DESIGNABLE
@interface SpinnerViewObjC : UIView

+ (NSArray*)poses;
- (void)animate;

@end

