# PopupView_ObjC
Popup bubbles are great! 
They let you display all kinds of information and menus, but sometimes a plain old UIView won't do the trick. 
Sometimes you need to have an indication of where the information or menu is stemming from, and any work-arounds to add an arrow to your existing view can get complicated, especially if your view has a border. 
![alt tag](https://cloud.githubusercontent.com/assets/15157368/10546172/80d09b22-73fa-11e5-8411-4235b3495569.png)  
PopupView is a UIView subclass that acts almost exactly like UIView, but with the added behavior of an indication arrow on one edge.

## Getting Started
It's really easy to get started!
First, create a Resources folder in your Project directory and add `PopupView.h` and `PopupView.m` to it  
![alt tag](https://cloud.githubusercontent.com/assets/15157368/10805599/4a37eb60-7da5-11e5-9cc3-44ce767271e1.png)  
Next, import the .h to your class file  
`#import PopupView.h`

## How to Use
As a subclass of UIView, PopupView may be treated as such except for a few caveats
#### Initialization
Initiaze like you would any other UIView

`PopupView popup = [[PopupView alloc] init];`  
`PopupView popup = [[PopupView alloc] initWithFrame:frame];`  
**Do not use** `initWithCoder` **as initialization in interface builder is not supported**
#### .layer Properties
PopupView disallows access the following .layer properties:  
`popup.layer.borderColor`, `popup.layer.borderWidth`, `popup.layer.cornerRadius`, `popup.layer.masksToBounds`  

These properties may be set by accessing PopupView properties: 
`popup.borderColor`, `popup.borderWidth`, `popup.cornerRadius`, `popup.masksToBounds`  
and their respecitve setter methods
#### Arrow Properties
`popup.arrowDirection` - Which direction the arrow points  
PopupView defines an enumeration of Arrow Directions. Use these to set `popup.arrowDirection`  
`typedef enum {
None,
Up,
Right,
Down,
Left
} ArrowDirection;`

`popup.arrowSize` - The number of screen points from any corner of the arrow to the center (the arrow's width is `2 x popup.arrowSize`, and it protrudes from the view by `1 x popup.arrowSize`)

`popup.arrowPosition` - The number of screen points from the view's edge to the leading edge of the arrow (on the top and bottom - the number of points to the left edge, on the sides - the number of points to the top edge)  
If your view has rounded corners, `arrowPosition` is restricted to the straight area between the curves, but the value of `arrowPosition` is not treated any differently

#### Frame
The frame of PopupView is the same with or without arrows. Arrows extend outside of the frame and does not affect the frame's origin or size  
`popup.masksToBounds = YES;` will not affect the arrow, even though it is outside of the frame. It will only affect subviews of `popup`