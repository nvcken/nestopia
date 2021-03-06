/*
 Nestopia for iOS
 Copyright (c) 2013, Jonathan A. Zdziarski
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 
 */

#import "ControllerView.h"
#import "GameROMViewController.h"
#import "EmulatorCore.h"

@implementation ControllerView
@synthesize orientation;
@synthesize delegate;
@synthesize currentController;
@synthesize gamePlayDelegate;
@synthesize notified;

- (id)initWithFrame:(CGRect)frame {
	self = [ super initWithFrame: frame ];
	if (self != nil) {
		self.multipleTouchEnabled = YES;

		padDir = padButton = padSpecial = 0;
		orientation = [ UIApplication sharedApplication ].statusBarOrientation;
		swapAB = [[[ EmulatorCore globalSettings ] objectForKey: @"swapAB" ] boolValue ];
		stickControl = [[[ EmulatorCore globalSettings ] objectForKey: @"controllerStickControl" ] boolValue ];
        
		NSLog(@"%s initializing controller view in %s mode\n", __func__,
			  (UIInterfaceOrientationIsLandscape(orientation) == YES) ? "landscape" : "portrait");
		
		currentController = 0;
		controllerState[0] = controllerState[1] = 0;
		
		/* Landscape Controls */
        if (UIInterfaceOrientationIsLandscape(orientation) == YES) {
            if ([ self hasFourInchDisplay ]) {
                Up     = CGRectMake( 61.0, 260 - 122.0, 60.0, 60.0);
                Down   = CGRectMake( 61.0, 260 -   0.0, 60.0, 60.0);
                Left   = CGRectMake(  0.0, 260 -  61.0, 81.0, 60.0);
                Right  = CGRectMake( 82.0, 260 -  61.0, 81.0, 60.0);
                UL     = CGRectMake(  0.0, 260 - 122.0, 60.0, 60.0);
                UR     = CGRectMake(122.0, 260 - 122.0, 60.0, 60.0);
                DL     = CGRectMake(  0.0, 260 -   0.0, 60.0, 60.0);
                DR     = CGRectMake(122.0, 260 -   0.0, 60.0, 60.0);
                A      = CGRectMake(495.0,       170.0, 74.0, 70.0);
                B      = CGRectMake(418.0,       250.0, 74.0, 70.0);
                AB     = CGRectMake(495.0,       244.0, 74.0, 76.0);
                Select = CGRectMake(  0.0,        92.0, 82.0, 44.0);
                Start  = CGRectMake(487.0,        92.0, 82.0, 44.0);
                Exit   = CGRectMake(525.0,           0, 60.0, 60.0);
            } else {
                Up     = CGRectMake( 61.0, 260 - 122.0, 60.0, 60.0);
                Down   = CGRectMake( 61.0, 260 -   0.0, 60.0, 60.0);
                Left   = CGRectMake(  0.0, 260 -  61.0, 81.0, 60.0);
                Right  = CGRectMake( 82.0, 260 -  61.0, 81.0, 60.0);
                UL     = CGRectMake(  0.0, 260 - 122.0, 60.0, 60.0);
                UR     = CGRectMake(122.0, 260 - 122.0, 60.0, 60.0);
                DL     = CGRectMake(  0.0, 260 -   0.0, 60.0, 60.0);
                DR     = CGRectMake(122.0, 260 -   0.0, 60.0, 60.0);
                A      = CGRectMake(407.0,       170.0, 74.0, 70.0);
                B      = CGRectMake(330.0,       250.0, 74.0, 70.0);
                AB     = CGRectMake(407.0,       244.0, 74.0, 76.0);
                Select = CGRectMake(  0.0,        92.0, 80.0, 50.0);
                Start  = CGRectMake(402.0,        92.0, 80.0, 50.0);
                Exit   = CGRectMake(435.0,           0, 60.0, 60.0);
            }
			controllerImage = [ self getControllerImage ];
			UIImageView *imageView = [ [ UIImageView alloc ] initWithImage: controllerImage ];
			[ self addSubview: [ imageView autorelease ] ];
			
		/* Portrait Controls */
		} else {
			
			/* Indicator icons, shown only in portrait mode */
			
			indicatorUp    = [ [ UIImageView alloc ] initWithImage: [ UIImage imageNamed: @"u.png" ] ];
			indicatorDown  = [ [ UIImageView alloc ] initWithImage: [ UIImage imageNamed: @"d.png" ] ];
			indicatorLeft  = [ [ UIImageView alloc ] initWithImage: [ UIImage imageNamed: @"l.png" ] ];
			indicatorRight = [ [ UIImageView alloc ] initWithImage: [ UIImage imageNamed: @"r.png" ] ];
			indicatorA     = [ [ UIImageView alloc ] initWithImage: [ UIImage imageNamed: @"a.png" ] ];
			indicatorB     = [ [ UIImageView alloc ] initWithImage: [ UIImage imageNamed: @"b.png" ] ];
			
			indicatorUp.hidden = YES;
			indicatorDown.hidden = YES;
			indicatorLeft.hidden = YES;
			indicatorRight.hidden = YES;
			indicatorA.hidden = YES;
			indicatorB.hidden = YES;
			
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                indicatorUp.frame = CGRectMake(236.0, 10.0, 15.0, 15.0);
                indicatorDown.frame = CGRectMake(236.0, 10.0, 15.0, 15.0);
                indicatorLeft.frame = CGRectMake(251.0, 10.0, 15.0, 15.0);
                indicatorRight.frame = CGRectMake(251.0, 10.0, 15.0, 15.0);
                indicatorA.frame = CGRectMake(281.0, 10.0, 15.0, 15.0);
                indicatorB.frame = CGRectMake(266.0, 10.0, 15.0, 15.0);
            } else {
                indicatorUp.frame = CGRectMake(556.0, 10.0, 30.0, 30.0);
                indicatorDown.frame = CGRectMake(556.0, 10.0, 30.0, 30.0);
                indicatorLeft.frame = CGRectMake(596.0, 10.0, 30.0, 30.0);
                indicatorRight.frame = CGRectMake(596.0, 10.0, 30.0, 30.0);
                indicatorA.frame = CGRectMake(676.0, 10.0, 30.0, 30.0);
                indicatorB.frame = CGRectMake(636.0, 10.0, 30.0, 30.0);
            }
			
			Up     = CGRectMake(  0.0,   0.0,  94.0,  46.0);
			Down   = CGRectMake(  0.0,  69.0,  94.0,  55.0);
			Left   = CGRectMake(  0.0,  36.0,  40.0,  42.0);
			Right  = CGRectMake( 56.0,  36.0,  45.0,  42.0);
			UL     = CGRectMake(  0.0,  0.0,   32.0,  38.0);
			UR     = CGRectMake( 62.0,  0.0,   32.0,  38.0);
			DL     = CGRectMake(  0.0,  76.0,  32.0,  49.0);
			DR     = CGRectMake( 62.0,  76.0,  32.0,  49.0);
			B      = CGRectMake(210.0,  40.0,  49.0,  85.0);
			A      = CGRectMake(272.0,  40.0,  49.0,  85.0);
			AB     = CGRectMake(260.0,  40.0,  12.0,  85.0);
			Select = CGRectMake(110.0,  50.0,  36.0,  40.0);
			Start  = CGRectMake(155.0,  50.0,  36.0,  40.0);
			Exit   = CGRectMake(102.0,   0.0, 100.0,  25.0);
            
			controllerImage = [ self getControllerImage ];			
			UIImageView *imageView = [ [ UIImageView alloc ] initWithImage: controllerImage ];
			[ self addSubview: [ imageView autorelease ] ];
			
			[ self addSubview: indicatorUp ];
			[ self addSubview: indicatorDown ];
			[ self addSubview: indicatorLeft ];
			[ self addSubview: indicatorRight ];
			[ self addSubview: indicatorA ];
			[ self addSubview: indicatorB ];
		}
	}
	
	return self;
}

- (void)reloadSettings {
    swapAB = [[[ EmulatorCore globalSettings ] objectForKey: @"swapAB" ] boolValue ];
    stickControl = [[[ EmulatorCore globalSettings ] objectForKey: @"controllerStickControl" ] boolValue ];
}

- (void)updateNotifyIcons {
	
    if (UIInterfaceOrientationIsLandscape(orientation)==YES) {
		return;
	}
	
	unsigned long dwKeyPad = controllerState[currentController];

	indicatorUp.hidden = YES;
	indicatorDown.hidden = YES;
	indicatorLeft.hidden = YES;
	indicatorRight.hidden = YES;
	indicatorA.hidden = YES;
	indicatorB.hidden = YES;
		
	if (dwKeyPad & NCTL_UP) 
		indicatorUp.hidden = NO;
	else if (dwKeyPad & NCTL_DOWN)
		indicatorDown.hidden = NO;
    if (dwKeyPad & NCTL_LEFT)
		indicatorLeft.hidden = NO;
	else if (dwKeyPad & NCTL_RIGHT)
		indicatorRight.hidden = NO;
	
	if (dwKeyPad & NCTL_B)  
		indicatorB.hidden = NO;
	
	if (dwKeyPad & NCTL_A)
		indicatorA.hidden = NO;
}

- (BOOL)hasFourInchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
}

- (UIImage *)getControllerImage {
	NSString *controllerFilename;
	UIImage *image;
	
    NSLog(@"%s", __PRETTY_FUNCTION__);

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (UIInterfaceOrientationIsLandscape(orientation)==YES) {
            if ([ self hasFourInchDisplay ]) {
                controllerFilename = [ NSString stringWithFormat: @"controller_ls-568h.png" ];
            } else {
                controllerFilename = [ NSString stringWithFormat: @"controller_ls.png" ];
            }
        } else {
            controllerFilename = [ NSString stringWithFormat: @"controller_pt.png" ];
        }
	} else {
        controllerFilename = [ NSString stringWithFormat: @"controller_ipad.png" ];
    }
    
	NSLog(@"%s loading controller image %@\n", __func__, controllerFilename);
    image = [[ UIImage imageNamed: controllerFilename ] retain ];
	return image;
}

- (int)controllerButtonPressedAtPoint:(CGPoint)point {
    int button = 0;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        point.x /= 2.4;
        point.y /= 2.4;
    }
    
    if (CGRectContainsPoint(Exit, point)) {
        if (notified == NO && [ gamePlayDelegate respondsToSelector: @selector(userDidExitGamePlay) ])
        {
            [ gamePlayDelegate userDidExitGamePlay ];
            notified = YES;
        }
    }
	if (CGRectContainsPoint(AB, point)) {
		button = NCTL_A | NCTL_B;
	} else if (CGRectContainsPoint(UL, point)) {
		button = NCTL_UP | NCTL_LEFT;
	} else if (CGRectContainsPoint(UR, point)) {
		button = NCTL_UP | NCTL_RIGHT;
	} else if (CGRectContainsPoint(DL, point)) {
		button = NCTL_DOWN | NCTL_LEFT;
	} else if (CGRectContainsPoint(DR, point)) {
		button = NCTL_DOWN | NCTL_RIGHT;
	} else if (CGRectContainsPoint(Up, point)) {
		button = NCTL_UP;
	} else if (CGRectContainsPoint(Down, point)) {
		button = NCTL_DOWN;
	} else if (CGRectContainsPoint(Left, point)) {
		button = NCTL_LEFT;
	} else if (CGRectContainsPoint(Right, point)) {
		button = NCTL_RIGHT;
	} else if (CGRectContainsPoint(A, point)) {
		if (swapAB==YES) {
			button = NCTL_B;
		} else {
			button = NCTL_A;
		}
	} else if (CGRectContainsPoint(B, point)) {
		if (swapAB== YES)
			button = NCTL_A;
		else
			button = NCTL_B;
	} else if (CGRectContainsPoint(Select, point)) {
		button = NCTL_SELECT;
	} else if (CGRectContainsPoint(Start, point)) {
		button = NCTL_START;
	}

	return button;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch;
	dword lastState = controllerState[currentController];

    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
	controllerState[currentController] = 0;
	
	for (touch in touches) {
		CGPoint point = [ touch locationInView: self ];
		int button = [ self controllerButtonPressedAtPoint: point ];
		
		//NSLog(@"%s touchesBegan at %fx%f, button %d", __func__, point.x, point.y, button);
		if ((button & NCTL_A) || (button & NCTL_B)) {
			padButton = button;
		} else if ((button & NCTL_UP) || (button & NCTL_DOWN) || (button & NCTL_LEFT) || (button & NCTL_RIGHT)) {
			padDir = button;
		} else {
			padSpecial = button;
		}
		controllerState[currentController] = padButton | padDir | padSpecial;
		//NSLog(@"%s begin touch %d controller state %lu", __func__, button, controllerState[currentController]);
	}
	
	if (lastState != controllerState[currentController]) {
        //NSLog(@"%s notifying %@ of controller state change", __PRETTY_FUNCTION__, delegate);
		[ delegate gameControllerControllerDidChange:currentController controllerState: controllerState[currentController] ];
		[ self updateNotifyIcons ];
    }
    
    [ super touchesBegan: touches withEvent: event ];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch;
	dword lastState = controllerState[currentController];
	
    // NSLog(@"%s", __PRETTY_FUNCTION__);

	for (touch in touches) {
		CGPoint point = [ touch locationInView: self ];
		int button = [ self controllerButtonPressedAtPoint: point ];
		
		/* User moved off a button? Find the button they were on and cancel it */
		if (! button && stickControl != YES) {
			CGPoint oldPoint = [ touch previousLocationInView: self ];
			button = [ self controllerButtonPressedAtPoint: oldPoint ];
			if ((button & NCTL_A) || (button & NCTL_B)) {
				padButton = 0;
			} else if ((button & NCTL_UP) || (button & NCTL_DOWN) || (button & NCTL_LEFT) || (button & NCTL_RIGHT)) {
				padDir = 0;
			}
		} else if ((button & NCTL_A) || (button & NCTL_B)) {
			padButton = button;
		} else if ((button & NCTL_UP) || (button & NCTL_DOWN) || (button & NCTL_LEFT) || (button & NCTL_RIGHT)) {
			padDir = button;
		} 
		controllerState[currentController] = padButton | padDir | padSpecial;
		//	NSLog(@"%s moved touch %d controller state %d", __func__, button, controllerState[currentController]);
	}
	
	if (lastState != controllerState[currentController]) {
		[ delegate gameControllerControllerDidChange:currentController controllerState: controllerState[currentController] ];
		[ self updateNotifyIcons ];
	}
    
    [ super touchesMoved: touches withEvent: event ];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch;
	
    //NSLog(@"%s", __PRETTY_FUNCTION__);

	for (touch in touches) {
		CGPoint point = [ touch locationInView: self ];
		int button = [ self controllerButtonPressedAtPoint: point ];
		if ((button & NCTL_A) || (button & NCTL_B)) {
			padButton = 0;
		} else if ((button & NCTL_UP) || (button & NCTL_DOWN) || (button & NCTL_LEFT) || (button & NCTL_RIGHT)) {
			padDir = 0;
		} else if (button == 0) {
			if (point.x < (self.frame.size.width / 2.0))
				padDir = 0;
			else
				padButton = 0;
		} else {
			padSpecial = 0;
			
			/* If select ended, also release dirpad.
			 * If start ended, also release buttons.
			 * This prevents tracking errors sliding onto the start/sel buttons.
			 */
			if (button & NCTL_SELECT)
				padDir = 0;
			else
				padButton = 0;
		} 
		
		controllerState[currentController] = padButton | padDir | padSpecial;
		//	NSLog(@"%s end touch %d controller state %d", __func__, button, controllerState[currentController]);
	}
	
	[ delegate gameControllerControllerDidChange:currentController controllerState: controllerState[currentController] ];
	[ self updateNotifyIcons ];
    
    [ super touchesEnded: touches withEvent: event ];
}

- (void)dealloc {
	[ controllerImage release ];
	[ indicatorUp release ];
	[ indicatorDown release ];
	[ indicatorLeft release ];
	[ indicatorRight release ];
	[ indicatorA release ];
	[ indicatorB release ];
    [ super dealloc ];
}


@end
