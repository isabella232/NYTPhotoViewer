//
//  NYTLoadingIndicatorView.m
//  Pods
//
//  Created by Marcus Kida on 15/01/2016.
//
//

#import "NYTLoadingIndicatorView.h"
#define kIndefiniteLoaderWidth 10

typedef NS_ENUM(NSInteger, NYTLoadingAnimationDirection) {
    NYTLoadingAnimationDirectionRight,
    NYTLoadingAnimationDirectionLeft
};

@interface NYTLoadingIndicatorView ()

@property (nonatomic) UIView *indicatorView;
@property (nonatomic) NSTimer *animationTimer;

@property (nonatomic) NYTLoadingAnimationDirection animationDirection;
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
    self.indicatorView.frame = (CGRect){0, 0, 0, self.bounds.size.height};
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
    self.indicatorView.frame = (CGRect){0, 0, [self progressWidth:self.progress], self.bounds.size.height};
}

- (CGFloat)progressWidth:(CGFloat)progress {
    return (self.bounds.size.width / 100) * (progress * 100);
}

- (void)indefiniteAnimation:(BOOL)start {
    self.indicatorView.hidden = !start;
    if (start) {
        self.indicatorView.frame = (CGRect){0, 0, kIndefiniteLoaderWidth, self.bounds.size.height};
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60
                                                               target:self
                                                             selector:@selector(indefiniteAnimation)
                                                             userInfo:nil
                                                              repeats:YES];
        return;
    }
    if (self.animationTimer.isValid) {
        [self.animationTimer invalidate];
    }
}

- (void)indefiniteAnimation {
    if (self.indicatorView.frame.origin.x >= self.bounds.size.width + kIndefiniteLoaderWidth) {
        self.animationDirection = NYTLoadingAnimationDirectionLeft;
    } else if (self.indicatorView.frame.origin.x <= 0 - kIndefiniteLoaderWidth) {
        self.animationDirection = NYTLoadingAnimationDirectionRight;
    }
    
    if (self.animationDirection == NYTLoadingAnimationDirectionRight) {
        self.animationPosition += self.bounds.size.width / (kIndefiniteLoaderWidth * 10);
    } else {
        self.animationPosition -= self.bounds.size.width/ (kIndefiniteLoaderWidth * 10);
    }
    self.indicatorView.frame = (CGRect){self.animationPosition, 0, kIndefiniteLoaderWidth, self.bounds.size.height};
}

#pragma mark - Accessors
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setIndefinite:NO];
    [self updateIndicatorView];
}

- (void)setIndefinite:(BOOL)indefinite {
    if (_indefinite == indefinite) {
        return;
    }
    [self indefiniteAnimation:indefinite];
    _indefinite = indefinite;
}

@end
