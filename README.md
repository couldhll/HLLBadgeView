# HLLBadgeView

Easy to set badge to UIView

* HLLBadgeView extends UIView using category.
* Use 1 method to set badge
* Can custom badge style
* Do not use?, set nil.

[![Build Status](https://travis-ci.org/couldhll/HLLBadgeView.svg)](https://travis-ci.org/couldhll/HLLBadgeView)

## Installation

### From CocoaPods

Add `pod 'HLLBadgeView'` to your Podfile or `pod 'HLLBadgeView', :head` if you're feeling adventurous.

### Manually

_**Important note if your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `UIFont+HLLFont.m` in Target Settings > Build Phases > Compile Sources._

* Drag the `HLLBadgeView` folder into your project.
* Import `UIView+HLLBadgeView.h`

## Usage

(see sample Xcode project in `/HLLBadgeViewDemo`)

### Sample Setting Badge

```objective-c
view1.badgeView.text = @"9";
```

### Setting Badge With Style

_**For exmaple:setting cornerRadius/horizontalAlignment/borderWidth/borderColor style**_

```objective-c
buttonBadgeView1.cornerRadius=5;
buttonBadgeView1.horizontalAlignment=HLLBadgeViewHorizontalAlignmentLeft;
buttonBadgeView1.borderWidth = 2.0;
buttonBadgeView1.borderColor = [UIColor blueColor];
```
