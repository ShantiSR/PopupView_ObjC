//
//  PopupView.h
//  Test
//
//  Created by Nick's Creative Studio on 10/14/15.
//  Copyright © 2015 Nick's Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    None,
    Up,
    Right,
    Down,
    Left
} ArrowDirection;

@interface PopupView : UIView

@property (nonatomic) ArrowDirection arrowDirection;
@property (nonatomic) CGFloat arrowPosition;
@property (nonatomic) CGFloat arrowSize;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) CGColorRef borderColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) BOOL masksToBounds;

@end
