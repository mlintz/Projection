//
//  PRJRect.m
//  Projection
//
//  Created by Mikey Lintz on 1/30/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

#import "PRJRect.h"

#define SETTER_RETURNING_SELF(METRIC, TYPE) \
- (instancetype)METRIC:(TYPE)METRIC { \
  self.METRIC = METRIC; \
  return self; \
}


static NSString * const kOverdefinedAssertString = @"Attempting to set value on fully defined rectangle: %@";
static NSString * const kUnderdefinedAssertString = @"Attempting to read value on underdefined rectangle: %@";
static NSString * const kInvalidMetricsString = @"Rectangle has invalid metrics: %@";

static CGFloat const kMinFloatNotSet = -1;
static CGFloat gMinFloat = kMinFloatNotSet;

static CGFloat PRJCeil(CGFloat value) {
  return [PRJRect minFloat] * ceil(value / [PRJRect minFloat]);
}

static CGFloat PRJRound(CGFloat value) {
  return [PRJRect minFloat] * round(value / [PRJRect minFloat]);
}

typedef NS_ENUM(NSInteger, PRJMetricDirection) {
  kPRJMetricDirectionVertical,
  kPRJMetricDirectionHorizontal,
};

typedef NS_OPTIONS(NSUInteger, PRJMetricType) {
  kPRJMetricTypeNull   = 1 << 0,
  kPRJMetricTypeMin    = 1 << 1,
  kPRJMetricTypeMax    = 1 << 2,
  kPRJMetricTypeCenter = 1 << 3,
  kPRJMetricTypeLength = 1 << 4,
};

@interface PRJMetric : NSObject

@property(nonatomic, readonly) PRJMetricType metricType;
@property(nonatomic, readonly) CGFloat value;

+ (instancetype)metricWithType:(PRJMetricType)type value:(CGFloat)value;

- (NSString *)typeStringForDirection:(PRJMetricDirection)direction;

@end

@implementation PRJMetric

+ (instancetype)metricWithType:(PRJMetricType)type value:(CGFloat)value {
  PRJMetric *metric = [[self alloc] init];
  if (metric) {
    metric->_metricType = type;
    metric->_value = value;
  }
  return metric;
}

- (NSString *)typeStringForDirection:(PRJMetricDirection)direction {
  switch (self.metricType) {
    case kPRJMetricTypeNull:
      return @"null";
    case kPRJMetricTypeMin:
      return (direction == kPRJMetricDirectionHorizontal) ? @"left" : @"top";
    case kPRJMetricTypeMax:
      return (direction == kPRJMetricDirectionHorizontal) ? @"right" : @"bottom";
    case kPRJMetricTypeCenter:
      return (direction == kPRJMetricDirectionHorizontal) ? @"centerX" : @"centerY";
    case kPRJMetricTypeLength:
      return (direction == kPRJMetricDirectionHorizontal) ? @"width" : @"height";
  }
}

@end

@implementation PRJRect {
  PRJMetric *_horizontalMetric0;
  PRJMetric *_horizontalMetric1;
  PRJMetric *_verticalMetric0;
  PRJMetric *_verticalMetric1;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    PRJMetric *nullMetric = [self nullMetric];
    _horizontalMetric0 = nullMetric;
    _horizontalMetric1 = nullMetric;
    _verticalMetric0 = nullMetric;
    _verticalMetric1 = nullMetric;
  }
  return self;
}

- (NSString *)description {
  NSString *metricFormat = @"%@ = %.2f";
  NSMutableArray *metricDescriptions = [NSMutableArray arrayWithCapacity:4];
  if (_horizontalMetric0.metricType != kPRJMetricTypeNull) {
    [metricDescriptions addObject:[NSString stringWithFormat:metricFormat,
                                   [_horizontalMetric0 typeStringForDirection:kPRJMetricDirectionHorizontal],
                                   _horizontalMetric0.value]];
  }
  if (_horizontalMetric1.metricType != kPRJMetricTypeNull) {
    [metricDescriptions addObject:[NSString stringWithFormat:metricFormat,
                                   [_horizontalMetric1 typeStringForDirection:kPRJMetricDirectionHorizontal],
                                   _horizontalMetric1.value]];
  }
  if (_verticalMetric0.metricType != kPRJMetricTypeNull) {
    [metricDescriptions addObject:[NSString stringWithFormat:metricFormat,
                                   [_verticalMetric0 typeStringForDirection:kPRJMetricDirectionVertical],
                                   _verticalMetric0.value]];
  }
  if (_verticalMetric1.metricType != kPRJMetricTypeNull) {
    [metricDescriptions addObject:[NSString stringWithFormat:metricFormat,
                                   [_verticalMetric1 typeStringForDirection:kPRJMetricDirectionVertical],
                                   _verticalMetric1.value]];
  }
  NSString *metricDescription = [metricDescriptions count] ? [metricDescriptions componentsJoinedByString:@"; "] : @"{no metrics}";
  return [NSString stringWithFormat:@"<%@ %p; %@>", NSStringFromClass([self class]), self, metricDescription];
}

- (void)setLeft:(CGFloat)left {
  [self setHorizontalValue:left forMetricType:kPRJMetricTypeMin];
}

- (void)setRight:(CGFloat)right {
  [self setHorizontalValue:right forMetricType:kPRJMetricTypeMax];
}

- (void)setCenterX:(CGFloat)centerX {
  [self setHorizontalValue:centerX forMetricType:kPRJMetricTypeCenter];
}

- (void)setWidth:(CGFloat)width {
  NSAssert(width >= 0, @"Attempting to set negative width.");
  [self setHorizontalValue:width forMetricType:kPRJMetricTypeLength];
}

- (void)setTop:(CGFloat)top {
  [self setVerticalValue:top forMetricType:kPRJMetricTypeMin];
}

- (void)setBottom:(CGFloat)bottom {
  [self setVerticalValue:bottom forMetricType:kPRJMetricTypeMax];
}

- (void)setCenterY:(CGFloat)centerY {
  [self setVerticalValue:centerY forMetricType:kPRJMetricTypeCenter];
}

- (void)setHeight:(CGFloat)height {
  NSAssert(height >= 0, @"Attempting to set negative height.");
  [self setVerticalValue:height forMetricType:kPRJMetricTypeLength];
}

- (void)setTopLeft:(CGPoint)topLeft {
  [self setLeft:topLeft.x];
  [self setTop:topLeft.y];
}

- (void)setTopCenter:(CGPoint)topCenter {
  [self setCenterX:topCenter.x];
  [self setTop:topCenter.y];
}

- (void)setTopRight:(CGPoint)topRight {
  [self setRight:topRight.x];
  [self setTop:topRight.y];
}

- (void)setCenterRight:(CGPoint)centerRight {
  [self setRight:centerRight.x];
  [self setCenterY:centerRight.y];
}

- (void)setBottomRight:(CGPoint)bottomRight {
  [self setRight:bottomRight.x];
  [self setBottom:bottomRight.y];
}

- (void)setBottomCenter:(CGPoint)bottomCenter {
  [self setCenterX:bottomCenter.x];
  [self setBottom:bottomCenter.y];
}

- (void)setBottomLeft:(CGPoint)bottomLeft {
  [self setLeft:bottomLeft.x];
  [self setBottom:bottomLeft.y];
}

- (void)setCenterLeft:(CGPoint)centerLeft {
  [self setLeft:centerLeft.x];
  [self setCenterY:centerLeft.y];
}

- (void)setCenter:(CGPoint)center {
  [self setCenterX:center.x];
  [self setCenterY:center.y];
}

- (void)setSize:(CGSize)size {
  [self setWidth:size.width];
  [self setHeight:size.height];
}

- (void)setFrame:(CGRect)frame {
  [self setTopLeft:frame.origin];
  [self setSize:frame.size];
}

- (CGFloat)left {
  PRJMetric *matchingMetric = [self getMetricWithType:kPRJMetricTypeMin direction:kPRJMetricDirectionHorizontal];
  if (matchingMetric) {
    return matchingMetric.value;
  }
  CGFloat left;
  CGFloat width;
  [self calculateMin:&left andLength:&width forDirection:kPRJMetricDirectionHorizontal];
  return left;
}

- (CGFloat)right {
  PRJMetric *matchingMetric = [self getMetricWithType:kPRJMetricTypeMax direction:kPRJMetricDirectionHorizontal];
  if (matchingMetric) {
    return matchingMetric.value;
  }
  CGFloat left;
  CGFloat width;
  [self calculateMin:&left andLength:&width forDirection:kPRJMetricDirectionHorizontal];
  return left + width;
}

- (CGFloat)centerX {
  PRJMetric *matchingMetric = [self getMetricWithType:kPRJMetricTypeCenter direction:kPRJMetricDirectionHorizontal];
  if (matchingMetric) {
    return matchingMetric.value;
  }
  CGFloat left;
  CGFloat width;
  [self calculateMin:&left andLength:&width forDirection:kPRJMetricDirectionHorizontal];
  return left + width / 2;
}

- (CGFloat)width {
  PRJMetric *matchingMetric = [self getMetricWithType:kPRJMetricTypeLength direction:kPRJMetricDirectionHorizontal];
  if (matchingMetric) {
    return matchingMetric.value;
  }
  CGFloat left;
  CGFloat width;
  [self calculateMin:&left andLength:&width forDirection:kPRJMetricDirectionHorizontal];
  return width;
}

- (CGFloat)top {
  PRJMetric *matchingMetric = [self getMetricWithType:kPRJMetricTypeMin direction:kPRJMetricDirectionVertical];
  if (matchingMetric) {
    return matchingMetric.value;
  }
  CGFloat top;
  CGFloat height;
  [self calculateMin:&top andLength:&height forDirection:kPRJMetricDirectionVertical];
  return top;
}

- (CGFloat)bottom {
  PRJMetric *matchingMetric = [self getMetricWithType:kPRJMetricTypeMax direction:kPRJMetricDirectionVertical];
  if (matchingMetric) {
    return matchingMetric.value;
  }
  CGFloat top;
  CGFloat height;
  [self calculateMin:&top andLength:&height forDirection:kPRJMetricDirectionVertical];
  return top + height;
}

- (CGFloat)centerY {
  PRJMetric *matchingMetric = [self getMetricWithType:kPRJMetricTypeCenter direction:kPRJMetricDirectionVertical];
  if (matchingMetric) {
    return matchingMetric.value;
  }
  CGFloat top;
  CGFloat height;
  [self calculateMin:&top andLength:&height forDirection:kPRJMetricDirectionVertical];
  return top + height / 2;
}

- (CGFloat)height {
  PRJMetric *matchingMetric = [self getMetricWithType:kPRJMetricTypeLength direction:kPRJMetricDirectionVertical];
  if (matchingMetric) {
    return matchingMetric.value;
  }
  CGFloat top;
  CGFloat height;
  [self calculateMin:&top andLength:&height forDirection:kPRJMetricDirectionVertical];
  return height;
}

- (CGPoint)topLeft {
  return CGPointMake(self.left, self.top);
}

- (CGPoint)topCenter {
  return CGPointMake(self.centerX, self.top);
}

- (CGPoint)topRight {
  return CGPointMake(self.right, self.top);
}

- (CGPoint)centerRight {
  return CGPointMake(self.right, self.centerY);
}

- (CGPoint)bottomRight {
  return CGPointMake(self.right, self.bottom);
}

- (CGPoint)bottomCenter {
  return CGPointMake(self.centerX, self.bottom);
}

- (CGPoint)bottomLeft {
  return CGPointMake(self.left, self.bottom);
}

- (CGPoint)centerLeft {
  return CGPointMake(self.left, self.centerY);
}

- (CGPoint)center {
  return CGPointMake(self.centerX, self.centerY);
}

- (CGSize)size {
  return CGSizeMake(self.width, self.height);
}

- (CGRect)frame {
  CGSize size = self.size;
  CGPoint origin = self.topLeft;
  return CGRectMake(origin.x, origin.y, size.width, size.height);
}

- (CGRect)roundedFrame {
  CGFloat x = PRJRound(self.left);
  CGFloat y = PRJRound(self.top);
  CGFloat width = PRJRound(self.right) - x;
  CGFloat height = PRJRound(self.bottom) - y;
  return CGRectMake(x, y, width, height);
}

- (BOOL)isFullyDefined {
  return _horizontalMetric0.metricType != kPRJMetricTypeNull
      && _horizontalMetric1.metricType != kPRJMetricTypeNull
      && _verticalMetric0.metricType != kPRJMetricTypeNull
      && _verticalMetric1.metricType != kPRJMetricTypeNull;
}

+ (CGFloat)minFloat {
  if (gMinFloat == kMinFloatNotSet) {
    gMinFloat = 1 / [UIScreen mainScreen].scale;
  }
  return gMinFloat;
}

+ (void)debugSetMinFloat:(CGFloat)minFloat {
  gMinFloat = minFloat;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
  PRJRect *other = [[self.class allocWithZone:zone] init];
  if (other) {
    other->_horizontalMetric0 = _horizontalMetric0;
    other->_horizontalMetric1 = _horizontalMetric1;
    other->_verticalMetric0 = _verticalMetric0;
    other->_verticalMetric1 = _verticalMetric1;
  }
  return other;
}

#pragma mark Private

// TODO: cache min and length values
- (void)calculateMin:(CGFloat *)outMin
           andLength:(CGFloat *)outLength
        forDirection:(PRJMetricDirection)direction {
  PRJMetric *metric0 = (direction == kPRJMetricDirectionVertical) ? _verticalMetric0 : _horizontalMetric0;
  PRJMetric *metric1 = (direction == kPRJMetricDirectionVertical) ? _verticalMetric1 : _horizontalMetric1;
  switch (metric0.metricType | metric1.metricType) {
    case (kPRJMetricTypeMin | kPRJMetricTypeMax): {
      CGFloat minValue = (metric0.metricType == kPRJMetricTypeMin) ? metric0.value : metric1.value;
      CGFloat maxValue = (metric0.metricType == kPRJMetricTypeMax) ? metric0.value : metric1.value;
      NSAssert(maxValue >= minValue, kInvalidMetricsString, self);
      *outMin = minValue;
      *outLength = maxValue - minValue;
      break;
    }
    case (kPRJMetricTypeMin | kPRJMetricTypeCenter): {
      CGFloat minValue = (metric0.metricType == kPRJMetricTypeMin) ? metric0.value : metric1.value;
      CGFloat centerValue = (metric0.metricType == kPRJMetricTypeCenter) ? metric0.value : metric1.value;
      NSAssert(centerValue >= minValue, kInvalidMetricsString, self);
      *outMin = minValue;
      *outLength = 2 * (centerValue - minValue);
      break;
    }
    case (kPRJMetricTypeMin | kPRJMetricTypeLength): {
      CGFloat minValue = (metric0.metricType == kPRJMetricTypeMin) ? metric0.value : metric1.value;
      CGFloat lengthValue = (metric0.metricType == kPRJMetricTypeLength) ? metric0.value : metric1.value;
      NSAssert(lengthValue >= 0, kInvalidMetricsString, self);
      *outMin = minValue;
      *outLength = lengthValue;
      break;
    }
    case (kPRJMetricTypeMax | kPRJMetricTypeCenter): {
      CGFloat maxValue = (metric0.metricType == kPRJMetricTypeMax) ? metric0.value : metric1.value;
      CGFloat centerValue = (metric0.metricType == kPRJMetricTypeCenter) ? metric0.value : metric1.value;
      NSAssert(maxValue >= centerValue, kInvalidMetricsString, self);
      *outLength = 2 * (maxValue - centerValue);
      *outMin = maxValue - *outLength;
      break;
    }
    case (kPRJMetricTypeMax | kPRJMetricTypeLength): {
      CGFloat maxValue = (metric0.metricType == kPRJMetricTypeMax) ? metric0.value : metric1.value;
      CGFloat lengthValue = (metric0.metricType == kPRJMetricTypeLength) ? metric0.value : metric1.value;
      NSAssert(lengthValue >= 0, kInvalidMetricsString, self);
      *outMin = maxValue - lengthValue;
      *outLength = lengthValue;
      break;
    }
    case (kPRJMetricTypeCenter | kPRJMetricTypeLength): {
      CGFloat centerValue = (metric0.metricType == kPRJMetricTypeCenter) ? metric0.value : metric1.value;
      CGFloat lengthValue = (metric0.metricType == kPRJMetricTypeLength) ? metric0.value : metric1.value;
      NSAssert(lengthValue >= 0, kInvalidMetricsString, self);
      *outMin = centerValue - lengthValue / 2;
      *outLength = lengthValue;
      break;
    }
    default: {
      NSAssert(NO, kUnderdefinedAssertString, self);
      break;
    }
  }
}

- (PRJMetric *)getMetricWithType:(PRJMetricType)type direction:(PRJMetricDirection)direction {
  if (direction == kPRJMetricDirectionHorizontal) {
    if (_horizontalMetric0.metricType == type) {
      return _horizontalMetric0;
    }
    if (_horizontalMetric1.metricType == type) {
      return _horizontalMetric1;
    }
  } else {
    if (_verticalMetric0.metricType == type) {
      return _verticalMetric0;
    }
    if (_verticalMetric1.metricType == type) {
      return _verticalMetric1;
    }
  }
  return nil;
}

- (void)setHorizontalValue:(CGFloat)value forMetricType:(PRJMetricType)type {
  if (type == kPRJMetricTypeLength) {
    value = PRJCeil(value);
  }
  if (_horizontalMetric0.metricType == type || _horizontalMetric0.metricType == kPRJMetricTypeNull) {
    _horizontalMetric0 = [PRJMetric metricWithType:type value:value];
  } else if (_horizontalMetric1.metricType == type || _horizontalMetric1.metricType == kPRJMetricTypeNull) {
    _horizontalMetric1 = [PRJMetric metricWithType:type value:value];
  } else {
    NSAssert(NO, kOverdefinedAssertString, self);
  }
}

- (void)setVerticalValue:(CGFloat)value forMetricType:(PRJMetricType)type {
  if (type == kPRJMetricTypeLength) {
    value = PRJCeil(value);
  }
  if (_verticalMetric0.metricType == type || _verticalMetric0.metricType == kPRJMetricTypeNull) {
    _verticalMetric0 = [PRJMetric metricWithType:type value:value];
  } else if (_verticalMetric1.metricType == type || _verticalMetric1.metricType == kPRJMetricTypeNull) {
    _verticalMetric1 = [PRJMetric metricWithType:type value:value];
  } else {
    NSAssert(NO, kOverdefinedAssertString, self);
  }
}

- (PRJMetric*)nullMetric {
  static dispatch_once_t once;
  static PRJMetric *nullMetric;
  dispatch_once(&once, ^{
    nullMetric = [PRJMetric metricWithType:kPRJMetricTypeNull value:0];
  });
  return nullMetric;
}

SETTER_RETURNING_SELF(left, CGFloat)
SETTER_RETURNING_SELF(right, CGFloat)
SETTER_RETURNING_SELF(centerX, CGFloat)
SETTER_RETURNING_SELF(width, CGFloat)

SETTER_RETURNING_SELF(top, CGFloat)
SETTER_RETURNING_SELF(bottom, CGFloat)
SETTER_RETURNING_SELF(centerY, CGFloat)
SETTER_RETURNING_SELF(height, CGFloat)

SETTER_RETURNING_SELF(topLeft, CGPoint)
SETTER_RETURNING_SELF(topCenter, CGPoint)
SETTER_RETURNING_SELF(topRight, CGPoint)
SETTER_RETURNING_SELF(centerRight, CGPoint)
SETTER_RETURNING_SELF(bottomRight, CGPoint)
SETTER_RETURNING_SELF(bottomCenter, CGPoint)
SETTER_RETURNING_SELF(bottomLeft, CGPoint)
SETTER_RETURNING_SELF(centerLeft, CGPoint)
SETTER_RETURNING_SELF(center, CGPoint)

SETTER_RETURNING_SELF(size, CGSize)
SETTER_RETURNING_SELF(frame, CGRect)

- (instancetype)expandSizeWithWidth:(CGFloat)dx height:(CGFloat)dy {
  self.width += dx;
  self.height += dy;
  return self;
}

@end
