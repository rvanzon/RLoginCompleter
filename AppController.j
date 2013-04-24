/*
 * AppController.j
 * RLoginCompleter
 *
 * Created by Richard van Zon on April 23, 2013.
 * Copyright 2013, Relectus All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <AppKit/AppKit.j>

@import <RLoginCompleter/RLoginCompleter.j>

@implementation AppController : CPObject
{
    @outlet CPWindow    	theWindow;
    @outlet CPWindow    	loginWindow;

    @outlet RLoginCompleter	loginCompleter;

    @outlet CPTextField		usernameField;
    @outlet CPTextField		passwordField;
}

- (CPArray)loginCompleterCredentials:(RLoginCompleter)loginCompleter
{
	return [[usernameField stringValue], [passwordField stringValue]];
}

- (void)loginCompleterRestored:(RLoginCompleter)loginCompleter username:(CPString)username password:(CPString)password
{
	// you can manually set username and password here, if you like:
	//	[usernameField setStringValue:username];
	//	[passwordField setStringValue:password];

	CPLog(@"stored credentials: %@, %@", username, password);
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	// setup manually if you don't want to use Interface Builder
	// loginCompleter = [[RLoginCompleter alloc] initWithDelegate:self];
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:YES];
}

- (void)loginToServer
{
	// let's fake a login
	[loginWindow orderOut:nil];

	// tell RLoginCompleter the credentials are correct and to store them
	[loginCompleter store];

	var alert = [CPAlert alertWithMessageText:@"Login successful!"
					defaultButton:@"OK"
				  alternateButton:nil
				  	  otherButton:nil
		informativeTextWithFormat:@"Now, tell your browser to save the password, then reload the page to see the results."];

	[alert runModal];
}

-(IBAction)loginClicked:(id)sender
{
	if ([[usernameField stringValue] length] && [[passwordField stringValue] length])
		[self loginToServer];
}

@end
