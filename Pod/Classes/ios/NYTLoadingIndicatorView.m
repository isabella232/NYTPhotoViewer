//
//  NYTLoadingIndicatorView.m
//  Pods
//
//  Created by Marcus Kida on 15/01/2016.
//
//

#import "NYTLoadingIndicatorView.h"

@interface NYTLoadingIndicatorView ()

@property (nonatomic) UIView *indicatorView;
@property (nonatomic) NSTimer *animationTimer;

@property (nonatomic) CGFloat animationStep;
@property (nonatomic) CGFloat animationPosition;

@end

@implementation NYTLoadingIndicatorView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.indicatorView];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateIndicatorView];
}

- (void)resetIndicatorHidden:(BOOL)hidden {
    self.indicatorView.frame = (CGRect){0, 0, self.animationPosition, self.bounds.size.height};
    self.indicatorView.hidden = hidden;
}

- (void)updateIndicatorView {
    // indefinite spinner animation
    if (self.isIndefinite) {
        return;
    }
    
    // definite spinner animation
    if (self.progress == 0.0f) {
        return [self resetIndicatorHidden:NO];
    }
    if (self.progress >= 1.0f) {
        return [self resetIndicatorHidden:YES];
    }
    self.indicatorView.frame = (CGRect){0, 0, [self progressWidth:self.progress] + self.animationPosition, self.bounds.size.height};
}

- (CGFloat)progressWidth:(CGFloat)progress {
    return ((self.bounds.size.width - self.animationPosition) / 100) * (progress * 100);
}

- (void)indefiniteAnimation:(BOOL)start {
    self.indicatorView.hidden = !start;
    if (start) {
        self.animationStep = 1;
        self.indicatorView.frame = (CGRect){0, 0, 0, self.bounds.size.height};
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 //60fps animation
                                                               target:self
                                                             selector:@selector(indefiniteAnimation)
                                                             userInfo:nil
                                                              repeats:YES];
        return;
    }
    if (self.animationTimer.isValid) {
        [self.animationTimer invalidate];
    }
    self.animationPosition = 0;
}

- (void)indefiniteAnimation {
    self.animationPosition += pow(0.8, (self.animationStep / 60));
    self.indicatorView.frame = (CGRect){0, 0, self.animationPosition, self.bounds.size.height};
    self.animationStep++;
}

#pragma mark - Accessors
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _indefinite = NO; // don't go through setter because we don't wanna force-hide the indicator
    [self.animationTimer invalidate];
    [self updateIndicatorView];
    if (progress >= 0.0f && progress < 1.0f) {
        self.indicatorView.hidden = NO;
    }
}

- (void)setIndefinite:(BOOL)indefinite {
    if (_indefinite == indefinite) {
        return;
    }
    [self indefiniteAnimation:indefinite];
    _indefinite = indefinite;
}

@end
