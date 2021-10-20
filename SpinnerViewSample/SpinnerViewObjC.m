//
//  SpinnerViewObjC.m
//  SpinnerViewSample
//
//  Created by HwangByungJo  on 2021/08/09.
//

#import "SpinnerViewObjC.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation Pose

- (instancetype)initWithSecondsSincePriorPose:(CFTimeInterval)secondsSincePriorPose
                                        start:(CGFloat)start
                                       length:(CGFloat)length {
    self = [super init];
    if (self) {
        _secondsSincePriorPose = secondsSincePriorPose;
        _start = start;
        _length = length;
    }
    return self;
}

+ (Pose *)secondsSincePriorPose:(CFTimeInterval)secondsSincePriorPose
                          start:(CGFloat)start
                         length:(CGFloat)length {
    
    Pose *pose = [[Pose alloc] initWithSecondsSincePriorPose:secondsSincePriorPose
                                                       start:start
                                                      length:length];
    return pose;
}

@end

@implementation SpinnerViewObjC

- (CAShapeLayer *)layer {
    [super layer];
    return (CAShapeLayer *)super.layer;
}

+ (Class)layerClass {
    return [CAShapeLayer self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.fillColor = nil;
    layer.strokeColor = [[UIColor blackColor] CGColor];
    layer.lineWidth = 3;
    [self setPath];
}

- (void)didMoveToWindow {
    [self animate];
}

- (void)setPath{
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.path =  [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds,
                                                                     layer.lineWidth / 2,
                                                                     layer.lineWidth / 2)].CGPath;
}

+ (NSArray*)poses {
    return @[
        [Pose secondsSincePriorPose:0.0 start:0.000 length:0.7],
        [Pose secondsSincePriorPose:0.6 start:0.500 length:0.5],
        [Pose secondsSincePriorPose:0.6 start:1.000 length:0.3],
        [Pose secondsSincePriorPose:0.6 start:1.500 length:0.1],
        [Pose secondsSincePriorPose:0.2 start:1.875 length:0.1],
        [Pose secondsSincePriorPose:0.2 start:2.250 length:0.3],
        [Pose secondsSincePriorPose:0.2 start:2.625 length:0.5],
        [Pose secondsSincePriorPose:0.2 start:3.000 length:0.7],
    ];
}

- (void)animate {
    
    CFTimeInterval time = 0;
    NSMutableArray *times = [[NSMutableArray alloc] init];
    CGFloat start = 0;
    NSMutableArray *rotations = [[NSMutableArray alloc] init];
    NSMutableArray *strokeEnds = [[NSMutableArray alloc] init];
    
    NSArray *poses = [SpinnerViewObjC poses];
    
    CGFloat totalSeconds = 0;
    
    for (Pose *pose in poses) {
        totalSeconds += pose.secondsSincePriorPose;
    };
    
    for (Pose *pose in poses) {
        time += pose.secondsSincePriorPose;
        [times addObject:[NSNumber numberWithFloat: time / totalSeconds]];
        start = pose.start;
        [rotations addObject:[NSNumber numberWithFloat:start * 2 * M_PI]];
        [strokeEnds addObject:[NSNumber numberWithFloat:pose.length]];
    }
    
    [times addObject:[times lastObject]];
    [rotations addObject:[rotations firstObject]];
    [strokeEnds addObject:[strokeEnds firstObject]];
    
    [self animateKeyPath:@"strokeEnd" duration:totalSeconds times:times values:strokeEnds];
    [self animateKeyPath:@"transform.rotation" duration:totalSeconds times:times values:rotations];
    
    [self animateStrokeHueWithDuration:totalSeconds * 5];
}

- (void)animateKeyPath:(NSString *)keyPath
              duration:(CFTimeInterval)duration
                 times:(NSArray *)times
                values:(NSArray *)values {
    
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.keyPath = keyPath;
    animation.keyTimes = times;
    animation.values = values;
    animation.calculationMode = kCAAnimationLinear;
    animation.duration = duration;
    animation.repeatCount = INFINITY;
       
    [self.layer addAnimation:animation forKey:animation.keyPath];
}

- (void)animateStrokeHueWithDuration:(CFTimeInterval)duration {
    
    NSInteger count = 36;
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.keyPath = @"strokeColor";
    
    NSMutableArray *keytimes = [[NSMutableArray alloc]init];
    NSMutableArray *colors = [[NSMutableArray alloc]init];
            
    for (int i = 0; i < count; i++) {
        CFTimeInterval interval =  (CGFloat)i / (CGFloat)count;
        [keytimes addObject:[NSNumber numberWithFloat:interval]];        
        CGColorRef ref = [[UIColor colorWithHue: (CGFloat)i / (CGFloat)count
                                     saturation: 1
                                     brightness: 1
                                          alpha: 1] CGColor];
        [colors addObject:(__bridge id _Nonnull)(ref)];
    }
        
    animation.keyTimes = keytimes;
    animation.values = colors;
    animation.duration = duration;
    animation.calculationMode = kCAAnimationLinear;
    animation.repeatCount = INFINITY;
    [self.layer addAnimation:animation forKey:animation.keyPath];
}

@end
