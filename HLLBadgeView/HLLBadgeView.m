//
//  HLLBadgeView.m
//  HLLBadge
//
//  Created by CouldHll on 14-6-30.
//  Copyright (c) 2014年 CouldHll. All rights reserved.
//

#import "HLLBadgeView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HLLBadgeView
{
    BOOL autoSetCornerRadius;
    CATextLayer *textLayer;
    CAShapeLayer *borderLayer;
    CAShapeLayer *backgroundLayer;
    CAShapeLayer *glossMaskLayer;
    CAGradientLayer *glossLayer;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //Set the view properties
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.clipsToBounds = NO;
    
    //Set the default
    _textColor = [UIColor whiteColor];
    _font = [UIFont systemFontOfSize:16.0];
    _badgeBackgroundColor = [UIColor redColor];
    _showGloss = NO;
    autoSetCornerRadius=YES;
    _cornerRadius = self.frame.size.height / 2;
    _horizontalAlignment = HLLBadgeViewHorizontalAlignmentRight;
    _verticalAlignment = HLLBadgeViewVerticalAlignmentTop;
    _alignmentShift = CGSizeMake(0, 0);
    _animateChanges = YES;
    _animationDuration = 0.2;
    _borderWidth = 0.0;
    _borderColor = [UIColor whiteColor];
    _shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    _shadowOffset = CGSizeMake(1.0, 1.0);
    _shadowRadius = 1.0;
    _shadowText = NO;
    _shadowBorder = NO;
    _shadowBadge = NO;
    
    //Set the minimum width / height if necessary;
    if (self.frame.size.height == 0 ) {
        CGRect frame = self.frame;
        frame.size.height = 24.0;
        _minimumWidth = 24.0;
        self.frame = frame;
    } else {
        _minimumWidth = self.frame.size.height;
    }
    
    _maximumWidth = CGFLOAT_MAX;
    
    //Create the text layer
    textLayer = [CATextLayer layer];
    textLayer.foregroundColor = _textColor.CGColor;
    textLayer.font = (__bridge CFTypeRef)(_font.fontName);
    textLayer.fontSize = _font.pointSize;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.truncationMode = kCATruncationEnd;
    textLayer.wrapped = NO;
    textLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //Create the border layer
    borderLayer = [CAShapeLayer layer];
    borderLayer.strokeColor = _borderColor.CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.lineWidth = _borderWidth;
    borderLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    borderLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //Create the background layer
    backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.fillColor = _badgeBackgroundColor.CGColor;
    backgroundLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    backgroundLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //Create the gloss layer
    glossLayer = [CAGradientLayer layer];
    glossLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    glossLayer.contentsScale = [UIScreen mainScreen].scale;
    glossLayer.colors = @[(id)[UIColor colorWithWhite:1 alpha:.8].CGColor,(id)[UIColor colorWithWhite:1 alpha:.25].CGColor, (id)[UIColor colorWithWhite:1 alpha:0].CGColor];
    glossLayer.startPoint = CGPointMake(0, 0);
    glossLayer.endPoint = CGPointMake(0, .6);
    glossLayer.locations = @[@0, @0.8, @1];
    glossLayer.type = kCAGradientLayerAxial;
    
    //Ctreate the mask for the gloss layer
    glossMaskLayer = [CAShapeLayer layer];
    glossMaskLayer.fillColor = [UIColor blackColor].CGColor;
    glossMaskLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    glossMaskLayer.contentsScale = [UIScreen mainScreen].scale;
    glossLayer.mask = glossMaskLayer;
    
    [self.layer addSublayer:backgroundLayer];
    [self.layer addSublayer:borderLayer];
    [self.layer addSublayer:textLayer];
    
    //Setup animations
    CABasicAnimation *frameAnimation = [CABasicAnimation animation];
    frameAnimation.duration = _animationDuration;
    frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSDictionary *actions = @{@"path": frameAnimation};
    
    //Animate the path changes
    backgroundLayer.actions = actions;
    borderLayer.actions = actions;
    glossMaskLayer.actions = actions;
}

#pragma mark layout

- (void)autoSetBadgeFrame
{
    CGRect frame = self.frame;
    
    //Get the width for the current string
    frame.size.width = [self sizeForString:_text includeBuffer:YES].width;
    if (frame.size.width < _minimumWidth) {
        frame.size.width = _minimumWidth;
    } else if (frame.size.width > _maximumWidth) {
        frame.size.width = _maximumWidth;
    }
    
    //Height doesn't need changing
    
    //Fix horizontal alignment if necessary
    if (_horizontalAlignment == HLLBadgeViewHorizontalAlignmentLeft) {
        frame.origin.x = 0 - (frame.size.width / 2) + _alignmentShift.width;
    } else if (_horizontalAlignment == HLLBadgeViewHorizontalAlignmentCenter) {
        frame.origin.x = (self.superview.bounds.size.width / 2) - (frame.size.width / 2) + _alignmentShift.width;
    } else if (_horizontalAlignment == HLLBadgeViewHorizontalAlignmentRight) {
        frame.origin.x = self.superview.bounds.size.width - (frame.size.width / 2) + _alignmentShift.width;
    }
    
    //Fix vertical alignment if necessary
    if (_verticalAlignment == HLLBadgeViewVerticalAlignmentTop) {
        frame.origin.y = 0 - (frame.size.height / 2) + _alignmentShift.height;
    } else if (_verticalAlignment == HLLBadgeViewVerticalAlignmentMiddle) {
        frame.origin.y = (self.superview.bounds.size.height / 2) - (frame.size.height / 2.0) + _alignmentShift.height;
    } else if (_verticalAlignment == HLLBadgeViewVerticalAlignmentBottom) {
        frame.origin.y = self.superview.bounds.size.height - (frame.size.height / 2.0) + _alignmentShift.height;
    }
    
    //Set the corner radius
    if (autoSetCornerRadius) {
        _cornerRadius = self.frame.size.height / 2;
    }
    
    //Constrain to integers
    frame = CGRectIntegral(frame);
    
    //Change the frame
    self.frame = frame;
    CGRect tempFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    backgroundLayer.frame = tempFrame;
    CGRect textFrame = CGRectMake(0, (ceilf(self.frame.size.height - _font.lineHeight) / 2), self.frame.size.width, _font.lineHeight);
    textLayer.frame = textFrame;
    glossLayer.frame = tempFrame;
    glossMaskLayer.frame = tempFrame;
    borderLayer.frame = tempFrame;
    //Update the paths of the layers
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tempFrame cornerRadius:_cornerRadius];
    backgroundLayer.path = path.CGPath;
    borderLayer.path = path.CGPath;
    //Inset to not show the gloss over the border
    glossMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, _borderWidth / 2.0, _borderWidth / 2.0) cornerRadius:_cornerRadius].CGPath;
}

- (CGSize)sizeForString:(NSString *)string includeBuffer:(BOOL)include
{
    if (!_font) {
        return CGSizeMake(0, 0);
    }
    //Calculate the width of the text
    CGFloat widthPadding = ceilf(_font.pointSize * .375);
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:(string ? string : @"") attributes:@{NSFontAttributeName : _font}];
    
    CGSize textSize = [attributedString boundingRectWithSize:(CGSize){CGFLOAT_MAX, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    if (include) {
        textSize.width += widthPadding * 2;
    }
    //Constrain to integers
    textSize.width = ceilf(textSize.width);
    textSize.height = ceilf(textSize.height);
    return textSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //Update the frames of the layers
    CGRect textFrame = CGRectMake(0, (ceilf(self.frame.size.height - _font.lineHeight) / 2), self.frame.size.width, _font.lineHeight);
    textLayer.frame = textFrame;
    backgroundLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    glossLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    glossMaskLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    borderLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);;
    
    //Update the layer's paths
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius];
    backgroundLayer.path = path.CGPath;
    borderLayer.path = path.CGPath;
    glossMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, _borderWidth/2, _borderWidth/2) cornerRadius:_cornerRadius].CGPath;
}

#pragma mark setting

- (void)setText:(NSString *)text
{
    _text = text;
    //If the new text is shorter, display the new text before shrinking
    if ([self sizeForString:textLayer.string includeBuffer:YES].width >= [self sizeForString:text includeBuffer:YES].width) {
        textLayer.string = text;
        [self setNeedsDisplay];
    } else {
        //If longer display new text after the animation
        if (_animateChanges) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_animationDuration * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                textLayer.string = text;
            });
        } else {
            textLayer.string = text;
        }
    }
    //Update the frame
    [self autoSetBadgeFrame];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    textLayer.foregroundColor = _textColor.CGColor;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    textLayer.fontSize = font.pointSize;
    textLayer.font = (__bridge CFTypeRef)(font.fontName);
    //Frame size needs to be changed to match the new font
    [self autoSetBadgeFrame];
}

- (void)setAnimateChanges:(BOOL)animateChanges
{
    _animateChanges = animateChanges;
    if (_animateChanges) {
        //Setup animations
        CABasicAnimation *frameAnimation = [CABasicAnimation animation];
        frameAnimation.duration = _animationDuration;
        frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        NSDictionary *actions = @{@"path": frameAnimation};
        
        //Animate the path changes
        backgroundLayer.actions = actions;
        borderLayer.actions = actions;
        glossMaskLayer.actions = actions;
    } else {
        backgroundLayer.actions = nil;
        borderLayer.actions = nil;
        glossMaskLayer.actions = nil;
    }
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    _badgeBackgroundColor = badgeBackgroundColor;
    backgroundLayer.fillColor = _badgeBackgroundColor.CGColor;
}

- (void)setShowGloss:(BOOL)showGloss
{
    _showGloss = showGloss;
    if (_showGloss) {
        [self.layer addSublayer:glossLayer];
    } else {
        [glossLayer removeFromSuperlayer];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    autoSetCornerRadius = NO;
    //Update boackground
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius];
    backgroundLayer.path = path.CGPath;
    glossMaskLayer.path = path.CGPath;
    borderLayer.path = path.CGPath;
}

- (void)setHorizontalAlignment:(HLLBadgeViewHorizontalAlignment)horizontalAlignment
{
    _horizontalAlignment = horizontalAlignment;
    [self autoSetBadgeFrame];
}

- (void)setVerticalAlignment:(HLLBadgeViewVerticalAlignment)verticalAlignment
{
    _verticalAlignment = verticalAlignment;
    [self autoSetBadgeFrame];
}

- (void)setAlignmentShift:(CGSize)alignmentShift
{
    _alignmentShift = alignmentShift;
    [self autoSetBadgeFrame];
}

- (void)setMinimumWidth:(CGFloat)minimumWidth
{
    _minimumWidth = minimumWidth;
    [self autoSetBadgeFrame];
}

- (void)setMaximumWidth:(CGFloat)maximumWidth
{
    if (maximumWidth < self.frame.size.height) {
        maximumWidth = self.frame.size.height;
    }
    _maximumWidth = maximumWidth;
    [self autoSetBadgeFrame];
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    borderLayer.lineWidth = borderWidth;
    [self setNeedsLayout];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    borderLayer.strokeColor = _borderColor.CGColor;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    self.shadowBadge = _shadowBadge;
    self.shadowText = _shadowText;
    self.shadowBorder = _shadowBorder;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowOffset = shadowOffset;
    self.shadowBadge = _shadowBadge;
    self.shadowText = _shadowText;
    self.shadowBorder = _shadowBorder;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowRadius = shadowRadius;
    self.shadowBadge = _shadowBadge;
    self.shadowText = _shadowText;
    self.shadowBorder = _shadowBorder;
}

- (void)setShadowText:(BOOL)shadowText
{
    _shadowText = shadowText;
    
    if (_shadowText) {
        textLayer.shadowColor = _shadowColor.CGColor;
        textLayer.shadowOffset = _shadowOffset;
        textLayer.shadowRadius = _shadowRadius;
        textLayer.shadowOpacity = 1.0;
    } else {
        textLayer.shadowColor = nil;
        textLayer.shadowOpacity = 0.0;
    }
}

- (void)setShadowBorder:(BOOL)shadowBorder
{
    _shadowBorder = shadowBorder;
    
    if (_shadowBorder) {
        borderLayer.shadowColor = _shadowColor.CGColor;
        borderLayer.shadowOffset = _shadowOffset;
        borderLayer.shadowRadius = _shadowRadius;
        borderLayer.shadowOpacity = 1.0;
    } else {
        borderLayer.shadowColor = nil;
        borderLayer.shadowOpacity = 0.0;
    }
}

- (void)setShadowBadge:(BOOL)shadowBadge
{
    _shadowBadge = shadowBadge;
    if (_shadowBadge) {
        backgroundLayer.shadowColor = _shadowColor.CGColor;
        backgroundLayer.shadowOffset = _shadowOffset;
        backgroundLayer.shadowRadius = _shadowRadius;
        backgroundLayer.shadowOpacity = 1.0;
    } else {
        backgroundLayer.shadowColor = nil;
        backgroundLayer.shadowOpacity = 0.0;
    }
}

@end
