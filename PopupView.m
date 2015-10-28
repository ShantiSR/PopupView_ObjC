//
//  PopupView.m
//  Test
//
//  Created by Nick's Creative Studio on 10/14/15.
//  Copyright © 2015 Nick's Creative Studio. All rights reserved.
//

#import "PopupView.h"

@interface PopupView() {
    BOOL _changed;
    CGFloat frameWidth, frameHeight;
}

@property (nonatomic) CAShapeLayer *popupBubble;
@property (nonatomic) UIView *containerView;

@end

@implementation PopupView

#pragma mark - Initializers

//Initializes an instance of PopupView
- (instancetype)init {
    self = [super init];

    [self setupVariables];
    [self drawPopupBubble];
    [self addLayerObservers];

    return self;
}

//Initializes an instance of PopupView with a given frame
//Sets values dependent on frame
//Parameter frame: The frame PopupView is given
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    [self setupVariables];
    frameWidth = frame.size.width;
    frameHeight = frame.size.height;
    self.containerView.frame = CGRectMake(0, 0, frameWidth, frameHeight);
    [self drawPopupBubble];
    [self addLayerObservers];

    return self;
}

//PopupView does not support initWithCoder because it should not be created in interface builder

#pragma mark - Draw

//Draws the underlying graphic that gives PopupView its appearance
//Follows a different draw sequence for each ArrowPosition
- (void)drawPopupBubble {
    [self.popupBubble removeFromSuperlayer];
    CGMutablePathRef path = CGPathCreateMutable();

    switch (self.arrowDirection) {
        case None: {
            path = [self drawTop:path];
            path = [self drawRight:path];
            path = [self drawBottom:path];
            path = [self drawLeft:path];
        } break;
        case Up: {
            path = [self drawTopWithArrow:path];
            path = [self drawRight:path];
            path = [self drawBottom:path];
            path = [self drawLeft:path];
        } break;
        case Right: {
            path = [self drawTop:path];
            path = [self drawRightWithArrow:path];
            path = [self drawBottom:path];
            path = [self drawLeft:path];
        } break;
        case Down: {
            path = [self drawTop:path];
            path = [self drawRight:path];
            path = [self drawBottomWithArrow:path];
            path = [self drawLeft:path];
        } break;
        case Left: {
            path = [self drawTop:path];
            path = [self drawRight:path];
            path = [self drawBottom:path];
            path = [self drawLeftWithArrow:path];
        }
    }

    self.popupBubble.path = path;
    [self.layer addSublayer:self.popupBubble];
    [self bringSubviewToFront:self.containerView];
}

//Draws the top line and top right curve of popupBubble
//Should only be called by drawPopupBubble
//Should be first in draw sequence if called
//Parameter path: The new path for popupBubble
//Return: The edited path
- (CGMutablePathRef)drawTop:(CGMutablePathRef)path {
    CGPathMoveToPoint(path, nil, self.cornerRadius, 0);
    CGPathAddLineToPoint(path, nil, frameWidth - self.cornerRadius, 0);
    CGPathAddArcToPoint(path, nil, frameWidth, 0, frameWidth, self.cornerRadius, self.cornerRadius);
    return path;
}

//Draws the top line, arrow, and top right curve of popupBubble
//Should only be called by drawPopupBubble
//Should be first in draw sequence if called
//Parameter path: The new path for popupBubble
//Return: The edited path
- (CGMutablePathRef)drawTopWithArrow:(CGMutablePathRef)path {
    CGPathMoveToPoint(path, nil, self.cornerRadius, 0);
    CGPathAddLineToPoint(path, nil, self.arrowPosition, 0);
    CGPathAddLineToPoint(path, nil, self.arrowPosition + self.arrowSize, -self.arrowSize);
    CGPathAddLineToPoint(path, nil, self.arrowPosition + 2 * self.arrowSize, 0);
    CGPathAddLineToPoint(path, nil, frameWidth - self.cornerRadius, 0);
    CGPathAddArcToPoint(path, nil, frameWidth, 0, frameWidth, self.cornerRadius, self.cornerRadius);
    return path;
}

//Draws the right line and bottom right curve of popupBubble
//Should only be called by drawPopupBubble
//Should be second in draw sequence if called
//Parameter path: The new path for popupBubble
//Return: The edited path
- (CGMutablePathRef)drawRight:(CGMutablePathRef)path {
    CGPathAddLineToPoint(path, nil, frameWidth, frameHeight - self.cornerRadius);
    CGPathAddArcToPoint(path, nil, frameWidth, frameHeight, frameWidth - self.cornerRadius, frameHeight, self.cornerRadius);
    return path;
}

//Draws the right line, arrow, and bottom right curve of popupBubble
//Should only be called by drawPopupBubble
//Should be second in draw sequence if called
//Parameter path: The new path for popupBubble
//Return: The edited path
- (CGMutablePathRef)drawRightWithArrow:(CGMutablePathRef)path {
    CGPathAddLineToPoint(path, nil, frameWidth, self.arrowPosition);
    CGPathAddLineToPoint(path, nil, frameWidth + self.arrowSize, self.arrowPosition + self.arrowSize);
    CGPathAddLineToPoint(path, nil, frameWidth, self.arrowPosition + 2 * self.arrowSize);
    CGPathAddLineToPoint(path, nil, frameWidth, frameHeight-self.cornerRadius);
    CGPathAddArcToPoint(path, nil, frameWidth, frameHeight, frameWidth - self.cornerRadius, frameHeight, self.cornerRadius);
    return path;
}

//Draws the bottom line and bottom left curve of popupBubble
//Should only be called by drawPopupBubble
//Should be third in draw sequence if called
//Parameter path: The new path for popupBubble
//Return: The edited path
- (CGMutablePathRef)drawBottom:(CGMutablePathRef)path {
    CGPathAddLineToPoint(path, nil, self.cornerRadius, frameHeight);
    CGPathAddArcToPoint(path, nil, 0, frameHeight, 0, frameHeight - self.cornerRadius, self.cornerRadius);
    return path;
}

//Draws the bottom line, arrow, and bottom left curve of popupBubble
//Should only be called by drawPopupBubble
//Should be third in draw sequence if called
//Parameter path: The new path for popupBubble
//Return: The edited path
- (CGMutablePathRef)drawBottomWithArrow:(CGMutablePathRef)path {
    CGPathAddLineToPoint(path, nil, self.arrowPosition + 2 * self.arrowSize, frameHeight);
    CGPathAddLineToPoint(path, nil, self.arrowPosition + self.arrowSize, frameHeight + self.arrowSize);
    CGPathAddLineToPoint(path, nil, self.arrowPosition, frameHeight);
    CGPathAddLineToPoint(path, nil, self.cornerRadius, frameHeight);
    CGPathAddArcToPoint(path, nil, 0, frameHeight, 0, frameHeight - self.cornerRadius, self.cornerRadius);
    return path;
}

//Draws the left line and top left curve of popupBubble
//Draws extra line to close gap if needed
//Should only be called by drawPopupBubble
//Should be fourth and last in draw sequence if called
//Parameter path: The new path for popupBubble
//Return: The edited path
- (CGMutablePathRef)drawLeft:(CGMutablePathRef)path {
    CGPathAddLineToPoint(path, nil, 0, self.cornerRadius);
    CGPathAddArcToPoint(path, nil, 0, 0, self.cornerRadius, 0, self.cornerRadius);
    if (self.cornerRadius == 0) {
        CGPathAddLineToPoint(path, nil, 1, 0);
    } else if (self.arrowPosition == self.cornerRadius) {
        CGPathAddLineToPoint(path, nil, self.arrowPosition + 1, 0);
    }
    return path;
}

//Draws the left line, arrow, and top left curve of popupBubble
//Draws extra line to close gap if needed
//Should only be called by drawPopupBubble
//Should be fourth and last in draw sequence if called
//Parameter path: The new path for popupBubble
//Return: The edited path
- (CGMutablePathRef)drawLeftWithArrow:(CGMutablePathRef)path {
    CGPathAddLineToPoint(path, nil, 0, self.arrowPosition + 2 * self.arrowSize);
    CGPathAddLineToPoint(path, nil, -self.arrowSize, self.arrowPosition + self.arrowSize);
    CGPathAddLineToPoint(path, nil, 0, self.arrowPosition);
    CGPathAddLineToPoint(path, nil, 0, self.cornerRadius);
    CGPathAddArcToPoint(path, nil, 0, 0, self.cornerRadius, 0, self.cornerRadius);
    if (self.cornerRadius == 0) {
        CGPathAddLineToPoint(path, nil, 1, 0);
    } else if (self.arrowPosition == self.cornerRadius) {
        CGPathAddLineToPoint(path, nil, self.arrowPosition + 1, 0);
    }
    return path;
}

#pragma mark - Setters and Override

//Prevents subviews from being added directly to PopupView
//Redirects added subviews to containerView
//Parameter subview: The subview being redirected
- (void)didAddSubview:(UIView *)subview {
    if (subview != self.containerView) {
        [subview removeFromSuperview];
        [self.containerView addSubview:subview];
    }
}

//Sets arrow direction, redraws popupBubble with new arrow
//Parameter arrowDirection: The new arrow direction
- (void)setArrowDirection:(ArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
    [self drawPopupBubble];
}

//Sets postion of arrow's leading edge and enforces boundaries between corners, redraws popupBubble with new arrow
//Parameter The new position for the leading edge of the arrow
- (void)setArrowPosition:(CGFloat)arrowPosition {
    if (arrowPosition < self.cornerRadius) {
        _arrowPosition = self.cornerRadius;
        NSLog(@"Warning! Arrow position out of bounds! arrowPosition has been changed to %f", self.arrowPosition);
    } else if ((self.arrowDirection == Up || self.arrowDirection == Down) && arrowPosition > frameWidth - self.cornerRadius - self.arrowSize) {
        _arrowPosition = frameWidth - self.cornerRadius - 2 * self.arrowSize;
        NSLog(@"Warning! Arrow position out of bounds! arrowPosition has been changed to %f", self.arrowPosition);
    } else if ((self.arrowDirection == Right || self.arrowDirection == Left)
               && arrowPosition > frameHeight - self.cornerRadius - self.arrowSize) {
        _arrowPosition = frameHeight - self.cornerRadius - 2 * self.arrowSize;
        NSLog(@"Warning! Arrow position out of bounds! arrowPosition has been changed to %f", self.arrowPosition);
    } else {
        _arrowPosition = arrowPosition;
    }
    [self drawPopupBubble];
}

//Sets size from corner to center of arrow, redraws popupBubble with new arrow
//Parameter arrowSize: The new size from corner to center of arrow
- (void)setArrowSize:(CGFloat)arrowSize {
    _arrowSize = arrowSize;
    [self drawPopupBubble];
}

//Prevents PopupView's background color from being changed
//Redirects background color to popupBubble
//Stored for user reference
//Parameter backgroundColor: The background color being redirected
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.popupBubble.fillColor = (backgroundColor).CGColor;
}

//Prevents PopupView's border color from being changed
//Redirects border color to popupBubble
//Stored for user reference
//Parameter borderColor: The border color being redireced
- (void)setBorderColor:(CGColorRef)borderColor {
    _borderColor = borderColor;
    self.popupBubble.strokeColor = borderColor;
}

//Prevents PopupView's border width from being changed
//Redirects border width to popupBubble
//Stored for user reference
//Parameter borderWidth: The border width being redireced
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.popupBubble.lineWidth = borderWidth;
}

//Prevents PopupView's corner radius from being changed
//Redirects corner radius to containerView
//Stored for use in popupBubble and user reference
//Calls setArrowPosition to enforce new boundaries
//Parameter cornerRadius: The corner radius being redireced
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.containerView.layer.cornerRadius = cornerRadius;
    self.arrowPosition = self.arrowPosition;
    [self drawPopupBubble];
}

//Sets frame and other values dependent on it
//Redraws popupBubble with new frame
- (void)setFrame:(CGRect)frame {
    super.frame = frame;
    frameWidth = frame.size.width;
    frameHeight = frame.size.height;
    self.containerView.frame = CGRectMake(0, 0, frameWidth, frameHeight);
    [self drawPopupBubble];
}

//Prevents PopupView.layer.masksToBounds from being changed as this would cut off the arrow
//Redirects masksToBounds to containerView
//Stored for user reference
//Parameter masksToBounds: The property being redirected
- (void)setMasksToBounds:(BOOL)masksToBounds {
    _masksToBounds = masksToBounds;
    self.containerView.layer.masksToBounds = masksToBounds;
}

#pragma mark - Helpers

//Adds observers that catch users attempting to change certain .layer properties
- (void)addLayerObservers {
    [self.layer addObserver:self forKeyPath:@"borderColor" options:NSKeyValueObservingOptionOld context:nil];
    [self.layer addObserver:self forKeyPath:@"borderWidth" options:NSKeyValueObservingOptionOld context:nil];
    [self.layer addObserver:self forKeyPath:@"cornerRadius" options:NSKeyValueObservingOptionOld context:nil];
    [self.layer addObserver:self forKeyPath:@"masksToBounds" options:NSKeyValueObservingOptionOld context:nil];
}

//Initializes and sets default values for all instance variables
- (void)setupVariables {
    _changed = NO;

    self.popupBubble = [[CAShapeLayer alloc] init];

    self.arrowDirection = None;
    self.arrowPosition = 0;
    self.arrowSize = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.borderColor = [UIColor blackColor].CGColor;
    self.borderWidth = 0.5f;
    self.cornerRadius = 0.0f;
    self.masksToBounds = NO;

    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.containerView];
}

#pragma mark - Observation

//Observes and catches users attempting to change certain .layer properties
//Changes those properties back to their default values and warns the user of the proper way to change these properties
//Uses globally stored boolean to prevent infinite or doubled loop of setting these values
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!_changed){
        _changed = YES;
        if ([keyPath isEqualToString:@"borderColor"]) {
            self.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor;
        } else if ([keyPath isEqualToString:@"borderWidth"]) {
            self.layer.borderWidth = 0;
        } else if ([keyPath isEqualToString:@"cornerRadius"]) {
            self.layer.cornerRadius = 0;
        } else if ([keyPath isEqualToString:@"masksToBounds"]) {
            self.layer.masksToBounds = NO;
        }
        NSLog(@"Warning! PopupView requires %@ to be set with PopupView.%@", keyPath, keyPath);
        NSLog(@"PopupView.layer.%@ was not changed", keyPath);
        _changed = NO;
    }
}

@end
