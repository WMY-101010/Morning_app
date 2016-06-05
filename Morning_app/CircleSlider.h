//
//  CircleSlider.h
//  Morning_app
//
//  Created by LiuHaowen on 16/5/21.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleSlider : UIControl

@property (nonatomic,assign) CGFloat angle;
@property (nonatomic) CGPoint handleCenter;
@property (nonatomic, copy) NSTimer *time;
@property (nonatomic, assign) IBInspectable CGFloat CirclrBackgroundAlpha;
@property (nonatomic, assign)  UIColor * BackgroundCorol;

@property (assign)   CGFloat handleAlpha;
@property (assign) CGFloat clircleAlpha;
@property (assign) BOOL kindOfSlider;  //false 为720度 true为360



-(void) move:(CGFloat)cur;
-(void) letHandleGo:(CGFloat) alpha;
-(float) sentAngle;


@end
