//
//  UIView+OBAAdditions.h
//  OBAKit
//
//  Created by Aaron Brethorst on 3/13/18.
//  Copyright © 2018 OneBusAway. All rights reserved.
//

@import UIKit;

@class OBACardWrapper;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (OBAAdditions)
+ (instancetype)oba_autolayoutNew;

- (OBACardWrapper*)oba_embedInCardWrapper;

- (UIView*)oba_embedInWrapperView;
- (UIView*)oba_embedInWrapperViewWithConstraints:(BOOL)constrained;

/**
 Same as the view's layoutMargins, except only the leading and trailing values.
 */
@property(nonatomic,assign,readonly) UIEdgeInsets oba_leadingTrailingMargins;

// Debug-only
- (void)printAutoLayoutTrace;
- (void)exerciseAmbiguityInLayoutRepeatedly:(BOOL)recursive;
@end

NS_ASSUME_NONNULL_END
