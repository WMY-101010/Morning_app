//
//  CircleSlider.m
//  Morning_app
//
//  Created by LiuHaowen on 16/5/21.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//


#import "CircleSlider.h"
#import "CalculationHelp.h"


@interface CircleSlider ()
@property(nonatomic) CGFloat covAngle;
@property (nonatomic) CGFloat radius;
@property (nonatomic) BOOL snapToLabels;
@property (nonatomic, strong) NSArray *innerMarkingLabels;
@property (assign) int temAng;
@property (assign) int temCur;

@end

@implementation CircleSlider

static CGFloat handleAlpha = 0;
static int b_1 = 0;
static int b_2 = 0;
static int b_3 = 0;
static int b_4 = 0;
static int bMark = 0;

- (void)drawRect:(CGRect)rect {
    // Drawing code
    _radius= self.frame.size.height / 2 ;
    
    //画一个背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBackground:context withBackgroundAlphe:_CirclrBackgroundAlpha];
    [self drawCoverCircle:context];
    [self drawHandle:context];
    
}

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
}

-(float) sentAngle
{
    return self.angle;
}
//中心点
-(CGPoint)centerPoint
{
    return CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
}
//画背景
-(void) drawBackground:(CGContextRef) context withBackgroundAlphe:(CGFloat) alpha
{
    CGContextSaveGState(context);
    CGFloat radius = self.frame.size.width / 2;
    CGContextAddArc(context, radius, radius, radius - 15, 0, M_PI * 2, 1);
    UIColor*aColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextDrawPath(context, kCGPathFill);
}
//画覆盖的circle
-(BOOL) drawCoverCircle:(CGContextRef) context
{
    CGContextSaveGState(context);
    CGFloat i = 360;
    CGFloat coverAngle = (self.angle / i) * M_PI * 2;
    CGFloat circleAngle;
    //判断slider的种类，true转360度，false转720度
    if (_kindOfSlider == true) {
        if (coverAngle > M_PI * 2) {
            circleAngle = coverAngle - M_PI * 2;
        }
        else
        {
            circleAngle = coverAngle;
        }
    }
    else
    {
        circleAngle = coverAngle;
    }
    
    CGContextSetRGBStrokeColor(context, 255/255.0, 219/255.0, 74/255.0, _clircleAlpha);//线条颜色
    CGContextSetLineWidth(context, 8);
    CGContextAddArc(context, self.frame.size.width / 2, self.frame.size.height / 2 , self.frame.size.width / 2 - 15
                    ,-M_PI_2, circleAngle - M_PI_2, 0);
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextStrokePath(context);
    
    
    if (circleAngle > M_PI * 2)
    {
        CGFloat circleAngle_0 = coverAngle - M_PI * 2;
        CGContextSetRGBStrokeColor(context, 255/255.0, 173/255.0, 59/255.0, _clircleAlpha);//线条颜色
        CGContextSetLineWidth(context, 8);
        CGContextAddArc(context, self.frame.size.width / 2, self.frame.size.height / 2 , self.frame.size.width / 2 - 15
                        ,-M_PI_2, circleAngle_0 - M_PI_2, 0);
        CGContextSetLineCap(context,kCGLineCapRound);
        CGContextStrokePath(context);
    }
    
    return YES;
}

//通过角度找到中心点
-(CGPoint)pointOnCircleAtAngleFromNorth:(int)angle
{
    CGPoint offset = [CalculationHelp  pointOnRadius:self.radius atAngle:_angle];
    return CGPointMake(self.centerPoint.x + offset.x, self.centerPoint.y + offset.y);
}

//画handle
-(void) drawHandle:(CGContextRef) context
{
    CGContextSaveGState(context);
    //中心点
    _handleCenter = [self pointOnCircleAtAngleFromNorth:self.angle];
    [[UIColor colorWithWhite:1.0 alpha:handleAlpha]set];
    [CalculationHelp drawFilledCircleInContext:context
                                        center:_handleCenter
                                        radius:12];
    
    CGContextRestoreGState(context);
    
}
//-----------------------------------------------------------------------------------move


-(void) move:(CGFloat)cur
{
    if(cur > 270 && cur < 360) {
        b_3 = 1;
    }
    if ((cur == 360) || (cur > 360 && cur < 450)) {
        b_3 = 1;
        b_4 = 1;
    }
    if ((cur == 450) || (cur > 450 && cur < 540)) {
        b_3 = 1;
        b_4 = 1;
        b_1 = 1;
    }
    if ((cur == 540) || (cur > 540 && cur < 630)) {
        b_3 = 1;
        b_4 = 1;
        b_1 = 1;
        b_2 = 1;
    }
    if ((cur == 630) || (cur > 630 && cur < 720)) {
        b_3 = 2;
        b_4 = 1;
        b_1 = 1;
        b_2 = 1;
    }
    
    _temCur = cur;
    _temAng = 0;
    _time = [NSTimer scheduledTimerWithTimeInterval:0.0001f target:self selector:@selector(checkHandlePosition:) userInfo:nil repeats:YES];
}


//------------------------------------------------------------------------------------
-(BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
    [self moveHandle:lastPoint];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

//-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    [super endTrackingWithTouch:touch withEvent:event];
//    if(self.snapToLabels && self.innerMarkingLabels != nil)
//    {
//        CGPoint bestGuessPoint = CGPointZero;
//        float minDist = 360;
//        NSUInteger labelsCount = self.innerMarkingLabels.count;
//        for (int i = 0; i < labelsCount; i++)
//        {
//            CGFloat percentageAlongCircle = i/(float)labelsCount;
//            CGFloat degreesForLabel       = percentageAlongCircle * 360;
//            if(fabs(self.angle - degreesForLabel) < minDist)
//            {
//                minDist = fabs(self.angle - degreesForLabel);
//                bestGuessPoint = [self pointOnCircleAtAngleFromNorth:degreesForLabel];
//            }
//        }
//        self.angle = floor([Calculation angleFromPoint:self.centerPoint
//                                                   toPoint:bestGuessPoint]);
//        [self setNeedsDisplay];
//    }
//
//}



-(void)moveHandle:(CGPoint)point
{
    CGFloat angleTem = [CalculationHelp angleFromPoint:self.centerPoint toPoint:point];
    CGPoint tem = CGPointMake(point.x - self.centerPoint.x, point.y - self.centerPoint.y);
    
    if ( _kindOfSlider == true) {
        self.angle = angleTem;
    }
    else
    {
        if (b_1 == 0 && b_2 == 0 && b_3 == 0 && b_4 == 0 && tem.x < 0 && tem.y < 0)
        {
            b_3 = 1;
        }
        if (b_1 == 0 && b_2 == 0 && b_3 == 1 && b_4 == 0 && tem.x < 0 && tem.y > 0) {
            b_3 = 0;
        }
        
        
        if (b_1 == 0 && b_2 == 0 && b_3 == 1 && b_4 == 0 && tem.x > 0 && tem.y < 0)
        {
            b_4  = 1;
        }
        if (b_1 == 0 && b_2 == 0 && b_3 == 1 && b_4 == 1 && tem.x < 0 && tem.y < 0) {
            b_4 = 0;
        }
        
        
        if (b_1 == 0 && b_2 == 0 && b_3 == 1 && b_4 == 1 && tem.x > 0 && tem.y > 0)
        {
            b_1 = 1;
        }
        if (b_1 == 1 && b_2 == 0 && b_3 == 1 && b_4 == 1 && tem.x > 0 && tem.y < 0)
        {
            b_1 = 0;
        }
        
        
        
        if (b_1 == 1 && b_2 == 0 && b_3 == 1 && b_4 == 1 && tem.x < 0 && tem.y > 0)
        {
            b_2  = 1;
        }
        if (b_1 == 1 && b_2 == 1 && b_3 == 1 && b_4 == 1 && tem.x > 0 && tem.y > 0) {
            b_2 = 0;
        }
        
        if (b_1 == 1 && b_2 == 1 && b_3 == 1 && b_4 == 1 && tem.x < 0 && tem.y < 0) {
            b_3 = 2;
        }
        
        
        if (b_1 == 0 && b_2 == 0 && b_3 == 0 && b_4 == 0)
        {
            self.angle = angleTem;
        }
        
        if (b_3 == 1 )
        {
            if (b_4 == 1)
            {
                self.angle = angleTem + 360;
            }
            
            else
            {
                self.angle = angleTem;
            }
        }
        
        if (b_3 == 2)
        {
            if (tem.x > 0 && tem.y < 0)
            {
                b_1 = 0;
                b_2 = 0;
                b_3 = 0;
                b_4 = 0;
                bMark = 0;
            }
            else
            {
                self.angle = angleTem + 360;
            }
        }
    }
    
    [self setNeedsDisplay];
}


-(void)checkHandlePosition:(CGFloat) cur
{
    if (_temAng + 13 > _temCur) {
        handleAlpha = 1;
    }
    if ( _temAng > _temCur) {
        _temAng = 0;
        [_time invalidate];
    }
    else
    {
        self.angle = _temAng;
        [self setNeedsDisplay];
        _temAng += 11;
    }
}

-(void) letHandleGo:(CGFloat) alpha
{
    self.angle = 0;
    handleAlpha = alpha;
    b_1 = 0;
    b_2 = 0;
    b_3 = 0;
    b_4 = 0;
    bMark = 0;
    _clircleAlpha = 0;
    [self setNeedsDisplay];
}




@end