//
//  ProgressSpeedIndicator.m
//  FashionTinder
//
//  Created by Balica S on 17/06/2014.
//  Copyright (c) 2014 Balica Stefan. All rights reserved.
//

#import "BSProgressSpeedIndicator.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

 

@interface BSProgressSpeedIndicator()
{
    CGFloat lineWidth;
    CGFloat lineHeight;
    CGFloat radiusDelta;
    
    double red1;
    double green1;
    double blue1;
    
    
}
                                               
@property (nonatomic, strong) NSMutableArray *linesViews;
@property  CGFloat radius;

@property (nonatomic, strong) UILabel *progresslbl;

@property (nonatomic, strong) UILabel *unitlbl;

@property (nonatomic, strong) UILabel *urspeedlbl;




@end

@implementation BSProgressSpeedIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
         red1 = 252;
         green1 = 255;
         blue1 = 0;
        
        // Initialization code
        [self defInit];
    }
    return self;
}

- (void) defInit
{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.angle = 250;
   
    self.radius = (self.frame.size.width / 2);
    
    //self.radius =  100;
    
    self.numberOfLines = 100;
   
    lineHeight = 7;
    lineWidth = 2.0f;
    radiusDelta = 15;
    
    _linesViews = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _numberOfLines; i++) {
        
        if (i % 5 == 0) {
            
            lineHeight = 12;
            
        }else{
            
            lineHeight = 7;
        }
       
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, lineWidth, lineHeight)];
        line.backgroundColor = [UIColor colorWithRed:0.20392156862745098 green:0.28627450980392155 blue:0.3686274509803922 alpha:1.0];
        [line.layer setAllowsEdgeAntialiasing:YES];
        CGFloat angle = [self lineAngleForIndex:i];
        line.transform = CGAffineTransformMakeRotation(angle);
        [self addSubview:line];
        line.center = [self lineCenterForIndex:i andRadius:_radius - radiusDelta];
        [_linesViews addObject:line];

    }
    
    // add label
//    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    CGFloat width = self.frame.size.width / 2;
//    CGFloat heigth = self.frame.size.height / 3;
    
   // _progresslbl = [[UILabel alloc] initWithFrame:CGRectMake(center.x - width/2 , center.y - heigth/2, width, heigth)];

    _progresslbl = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-120)/2, 60, 120, 100)];
    _progresslbl.backgroundColor = [UIColor clearColor];
    _progresslbl.font = [UIFont fontWithName:@"AlteDIN1451Mittelschrift" size:80];
    _progresslbl.textAlignment = NSTextAlignmentCenter;
   // _progresslbl.textColor = [UIColor whiteColor];
    
    UIImage *myGradient = [UIImage imageNamed:@"rect2"];
    _progresslbl.textColor   = [UIColor colorWithPatternImage:myGradient];
    
    _progresslbl.text = [NSString stringWithFormat:@"%.0f", (self.progress * 100)/0.26];
    
    [self addSubview:_progresslbl];
    
    _unitlbl = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-80)/3, 160, 180, 23)];
    _unitlbl.backgroundColor = [UIColor clearColor];
    _unitlbl.font = [UIFont fontWithName:@"AlteDIN1451Mittelschrift" size:16];
    _unitlbl.textAlignment = NSTextAlignmentCenter;
    _unitlbl.textColor =  [UIColor whiteColor];
    _unitlbl.text = @"Your Speed";
    
    [self addSubview:_unitlbl];
    
    _urspeedlbl = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-80)/2, 45, 80, 23)];
    _urspeedlbl.backgroundColor = [UIColor clearColor];
    _urspeedlbl.font = [UIFont fontWithName:@"AlteDIN1451Mittelschrift" size:20];
    _urspeedlbl.textAlignment = NSTextAlignmentCenter;
    _urspeedlbl.textColor = [UIColor colorWithRed:255 green:202 blue:0 alpha:1.0];
    
    _urspeedlbl.text = @"km/hr";
    
    [self addSubview:_urspeedlbl];
    
}


-(void)changeLabel:(NSString*)Type  {
    
    _urspeedlbl.text = Type;
    
}


- (CGFloat) lineAngleForIndex:(NSUInteger) index
{
    CGFloat angleDelta = _angle / (_numberOfLines - 1);
    CGFloat radians = DEGREES_TO_RADIANS((index * angleDelta) - _angle/2);
    return radians;
}


- (CGPoint) lineCenterForIndex:(NSUInteger) index andRadius:(CGFloat) radius
{
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat lineAngle = [self lineAngleForIndex:index];
    CGFloat x = center.x + radius * sin(lineAngle);
    CGFloat y = center.y - radius * cos(lineAngle);
    
    return CGPointMake(x, y);
}
//
//- (UIColor*) lineColorForIndex:(NSUInteger) index
//
//{
//    
//    
//  //  float hue =  (float)index/_numberOfLines + 55;
//   // NSLog(@"hue %f",hue);
//    //hue = (hue > 0.5)? hue + 0.2f: hue;
//   // UIColor *color = [UIColor colorWithHue:55
//                                 //   saturation:86
//                                  //  brightness:85
//                                   //      alpha:1.0];
//  
//    
//    return color;
//}

#pragma mark Class

- (void) showWithProgress:(CGFloat) progress onView:(UIView*) view;
{
    [view addSubview:self];
   
    [_linesViews enumerateObjectsUsingBlock:^(UIImageView *line, NSUInteger idx, BOOL *stop) {
    
        line.alpha = 0.2f;
       
                   
        [UIView animateWithDuration:1.0f delay:0.3f usingSpringWithDamping:5 initialSpringVelocity:20 options:0 animations:^{
            line.alpha = 1.0f;
            [line setCenter:[self lineCenterForIndex:idx andRadius:self->_radius]];

        } completion:nil];
        
    }];
    
    [self setBarProgress:progress animate:YES];
}

- (void) setBarProgress:(CGFloat) progress animate:(BOOL) animate
{
    
    
    
    CGFloat delay = 0;
    if (self.progress < progress) {
        //increase
       for (int i = self.progress * _numberOfLines; i < progress * _numberOfLines; i++) {
           
           red1 = red1 + 0.03;
           green1 = green1 - 2.3;
           blue1 = blue1 + 1.4;
           
           if (animate) {
               
               [UIView animateWithDuration:0.1f delay:delay options:0 animations:^{
                   UIImageView *line = [self->_linesViews objectAtIndex:i];
                   line.backgroundColor = [UIColor colorWithRed: self->red1/255 green:self->green1/255 blue:self->blue1/255 alpha:1.0];
               } completion:^(BOOL finished) {
                  
//                   NSLog(@"progress0 %@",[NSString stringWithFormat:@"%.0f", (float)i/_numberOfLines * 100]);
//
//                   self->_progresslbl.text = [NSString stringWithFormat:@"%.0f", (float)(i/self->_numberOfLines * 100)/0.26];
               }];
               delay += 0.04;
           }else {
               UIImageView *line = [_linesViews objectAtIndex:i];
               line.backgroundColor = [UIColor colorWithRed:red1/255 green:green1/255 blue:blue1/255 alpha:1.0];
           }
           
        }
        
    }else {
                
        //decrease
        for (int i = _progress * _numberOfLines; i > progress * _numberOfLines; i--) {
            
            red1 = red1 - 0.03;
            green1 = green1 + 2.3;
            blue1 = blue1 - 1.4;
            
            if (animate) {
                [UIView animateWithDuration:0.1f delay:delay options:0 animations:^{
                    UIImageView *line = [self->_linesViews objectAtIndex:i];
                    line.backgroundColor = [UIColor colorWithRed:0.20392156862745098 green:0.28627450980392155 blue:0.3686274509803922 alpha:1.0];
                } completion:^(BOOL finished) {
//                    NSLog(@"progress1 %f",(float)i/_numberOfLines * 100);
//
//                    self->_progresslbl.text = [NSString stringWithFormat:@"%.0f", (float)(i/self->_numberOfLines * 100)/0.26];
                }];
                delay += 0.04;
            }else {
                UIImageView *line = [_linesViews objectAtIndex:i];
                line.backgroundColor = [UIColor clearColor];
            }
            
        }

    }
    
    self.progress = progress;
    
 _progresslbl.text = [NSString stringWithFormat:@"%.0f", (self.progress * 100)/0.26];

    
}


@end
