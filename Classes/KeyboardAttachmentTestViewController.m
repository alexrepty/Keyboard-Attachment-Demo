//
//  KeyboardAttachmentTestViewController.m
//
//  Created by Alexander Repty on 05.10.09.
// 
//  Copyright (c) 2009, Alexander Repty
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//  Neither the name of Alexander Repty nor the names of his contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "KeyboardAttachmentTestViewController.h"

@implementation KeyboardAttachmentTestViewController

@synthesize toolbar = _toolbar;
@synthesize textField = _textField;
@synthesize textFieldBarButtonItem = _textFieldBarButtonItem;
@synthesize flexibleSpaceBarButtonItem = _flexibleSpaceBarButtonItem;
@synthesize doneBarButtonItem = _doneBarButtonItem;

- (void)viewDidLoad {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	CGRect textFieldFrame = _textField.frame;
	textFieldFrame.size.width = self.view.bounds.size.width - 24.0; // 12 pixels space to either side
	_textField.frame = textFieldFrame;
	_toolbar.items = [NSArray arrayWithObject:_textFieldBarButtonItem];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	double animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	
	CGRect keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	
	[UIView beginAnimations:@"showKeyboardAnimation" context:nil];
	
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationDuration:animationDuration];
	
	self.view.frame = CGRectMake(self.view.frame.origin.x,
								 self.view.frame.origin.y,
								 self.view.frame.size.width,
								 self.view.frame.size.height - keyboardBounds.size.height);

	CGRect textFieldFrame = _textField.frame;
	textFieldFrame.size.width = keyboardBounds.size.width - 36.0 - 50.0; // Done button is 50 pixels wide, 3 times 12 pixels space
	_textField.frame = textFieldFrame;
	_toolbar.items = [NSArray arrayWithObjects:_textFieldBarButtonItem,_flexibleSpaceBarButtonItem,_doneBarButtonItem,nil];

	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	double animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	
	CGRect keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	
	[UIView beginAnimations:@"hideKeyboardAnimation" context:nil];
	
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationDuration:animationDuration];
	
	self.view.frame = CGRectMake(self.view.frame.origin.x,
								 self.view.frame.origin.y,
								 self.view.frame.size.width,
								 self.view.frame.size.height + keyboardBounds.size.height);

	CGRect textFieldFrame = _textField.frame;
	textFieldFrame.size.width = keyboardBounds.size.width - 24.0; // 12 pixels space to either side
	_textField.frame = textFieldFrame;
	_toolbar.items = [NSArray arrayWithObject:_textFieldBarButtonItem];
	
	[UIView commitAnimations];
}

- (IBAction)done:(id)sender {
	[_textField resignFirstResponder];
}

@end
