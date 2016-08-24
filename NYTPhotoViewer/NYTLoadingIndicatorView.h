//
//  NYTLoadingIndicatorView.h
//  Pods
//
//  Created by Marcus Kida on 15/01/2016.
//
//

@import UIKit;

@interface NYTLoadingIndicatorView : UIView

/**
 *  The progress to be shown, ranging 0.0 to 1.0
 */
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, getter=isIndefinite) BOOL indefinite;

@end
