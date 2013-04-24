/*
 * RLoginCompleter.j
 * RLoginCompleter
 *
 * Created by Richard van Zon on April 20, 2013.
 *
 * The MIT License
 *
 * Copyright (c) 2013 Richard van Zon
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

var RLoginCompleterDelay = 0.2,
	RLoginCompleterHTML = "Frameworks/RLoginCompleter/login.html";

@implementation RLoginCompleter : CPObject
{
    DOMElement      	loginFrame;
    DOMElement      	form;

	BOOL				hasLoginCompleterRestored;
	BOOL				hasLoginCompleterCredentials;

	CPWebView			webview;
	CPWindow			window;

	@outlet	CPTextField usernameField;
	@outlet	CPTextField passwordField;
	@outlet id			delegate;
}

- (id)initWithDelegate:(id)aDelegate
{
	self = [super init];

	if (self)
	{
		[self setDelegate:aDelegate];
	}

	return self;
}

/*
 * Add the webview to the mainWindow and hide it
 */
- (void)setup
{
	if (webview)
		return;

	// create a window
	window = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 1, 1) styleMask:CPBorderlessBridgeWindowMask];
	[window orderFront:self];

	if (!window)
	{
		CPLog.error('No main window found! Please use RAutoLoginCompleter after the application finished loading.');
		return;
	}

	webview = [[CPWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

	// too bad we have to use an external HTML-file
	// I some tests, and found this is the only way of making it work
	// in all browsers
	[webview setMainFrameURL:RLoginCompleterHTML];
	[webview setFrameLoadDelegate:self];
	[webview setHidden:YES];

	// add to the mainWindow (maybe it's to let the developer decide)
	[[window contentView] addSubview:webview];
}

- (void)setDelegate:(id)aDelegate
{
	delegate = aDelegate;

	[self setup];
}

/*
 * Request username and password from the delegate
 * place them in the form of the WebView and submit it
 */
- (void)storeUsername:(CPString)username andPassword:(CPString)password
{
	if (!form)
	{
		CPLog.error('No form found in Webview!');
		return;
	}

	form.username.value = username;
	form.password.value = password;
	form.submit();
}

- (void)store
{
	[self storeUsername:[usernameField stringValue] andPassword:[passwordField stringValue]]
}

- (void)webView:(CPWebView)aWebView didFinishLoadForFrame:(id)aFrame
{
	/*
	 * no frames found, wait a bit, then cleanup
	 */
	if (![aWebView DOMWindow].document.forms[0])
	{
		[CPTimer scheduledTimerWithTimeInterval:RLoginCompleterDelay
									   callback:function() { [window close]; }
										repeats:NO];
		return;
	}

	form = [aWebView DOMWindow].document.forms[0];
	if (!form)
	{
		CPLog.error('No form found in Webview!');
		return;
	}

	/*
	 * give the browser some time to fill out the credentials
	 * then send username and password to the delegate
	 */
	{
		[CPTimer scheduledTimerWithTimeInterval:RLoginCompleterDelay
									   callback:function() {
											if (hasLoginCompleterRestored)
									   			[delegate loginCompleterRestored:self username:form.username.value password:form.password.value];

									   		if (usernameField)
									   			[usernameField setStringValue:form.username.value];

									   		if (passwordField)
									   			[passwordField setStringValue:form.password.value];
									   	}
										repeats:NO];
	}
}

@end
