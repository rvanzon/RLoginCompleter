**WARNING: UNMAINTAINED AND PROBABLY NOT WORKING ANYMORE**

# RLoginCompleter #
by Richard van Zon

http://www.relectus.com/

## Overview ##

RLoginCompleter is a small framework for Cappuccino/Objectictive-J that lets you control saved usernames and passwords in web browsers. With only a few lines (one single line actually ;) you can extend your existing login dialog with auto completion.

## Demo ##
I setup a simple demo here: 
[http://www.relectus.com/os/RLoginCompleter/](http://www.relectus.com/os/RLoginCompleter/)

### How does this work? ###
The lack of login completion for Cappuccino apps irritated me for a while ;) So one day I decided to look for a solution. Realizing it probably would be hackish I started testing. First thing I though of was to create an iframe, set username and password, then try to read it from the parent frame with Objective-J. I expected the password would be protected by the browser, but it wasn't.

When your app logs in (this you do yourself) and the server grants access you tell RLoginCompleter to store the username and password. RLoginCompleter creates a webview and loads login.html. This file contains HTML code to create a form with username and password fields. The forms action is a non-existing URL. RLoginCompleter places the username and password in the form fields and submits the form. Your app is going to it's main screen directly. The browser now triggers the save password dialog. The user decides to store it or not.

Your webapp is awesome, so it's no suprise the user returns the next day. When you create the RLoginCompleter it will create the webview again. The browser detects the form fields and fills it with the username and password saved the previous day. RLoginCompleter waits a bit and reads the form fields. Then calls the delegate username and password are restored or places it in CPTextFields if you connected them in Interface Builder.

This technique seems to work great in Chrome. In Firefox it works, but if the user changes the username and saves it, it stops working, because Firefox let's the user choose the username to login with. Safari saves the password, but RLoginCompleter can't retrieve it (I think it's not filled out automaticly). I still have to look for these problems. Internet Explorer is not tested yet, and I will probably postpone this as long as possible ;)

Any suggestions, tips, test reports are very welcome.

## Getting Started ##
To get started clone the GitHub repository with:

	$ git clone https://github.com/rvanzon/RLoginCompleter.git

If you want to check out the example, go to directory RLoginCompleter and add the Cappuccino frameworks:

	$ capp gen -f --symlink

Now open index-debug.html in your browser.

## Implementation ##
It's easy to add RLoginCompleter to your existing project. RLoginCompleter does two things: 

1. storing username and password, typically done after the login on the backend succeeded.
2. retrieving username and password from the web browser, and (optionally) place it in CPTextFields.

You can use the delegate methods yourself or add RLoginCompleter to your project in Interface Builder.

### Interface Builder ###
When using Interface Builder RLoginCompleter can do most of the work for you, the only thing you have to do in code is including the framework and telling RLoginCompleter to store the credentials when the login succeeded.

First add RLoginCompleter to your login controller, like:

	@outlet RLoginCompleter	loginCompleter;

Now open Interface Builder and

1. Add a new Object and set the Class to **RLoginCompleter**
2. Connect **loginCompleter** to RLoginCompleter object you just created 
2. Connect the **delegate** to your controller
3. Connect **usernameField** to your login username text field
4. Connect **passwordField** to your login password text field

The last thing you have to is telling RLoginCompleter to store the username and password. By adding

	[RLoginCompleter store];
	
at the place in your code where logging in succeeded.
That's it!

### Manually ###
You can also use the delegate method yourself. First add:

	RLoginCompleter	loginCompleter;

Initialize the object (typically in your awakeFromCib)

	loginCompleter = [[RLoginCompleter alloc] initWithDelegate:self];

Then add the delegate method that is called when a username and password is filled out by web browser:

	- (void)loginCompleterRestored:(RLoginCompleter)loginCompleter 
						  username:(CPString)username 
						  password:(CPString)password
	{
		[yourUsernameField setStringValue:username];
		[yourPasswordField setStringValue:password];
	}

When the login is succeeded call:

	[loginCompleter storeUsername:[yourUsernameField stringValue] 
					  andPassword:[yourPasswordField stringValue]];
That's it!

### Known issues ###
Safari saves the password, but RLoginCompleter can't restore it

Multiple passwords in Firefox are not (yet) supported

## License ##

The MIT License

Copyright (c) 2013 Richard van Zon / Relectus

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
