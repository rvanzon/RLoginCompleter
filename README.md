# RLoginCompleter #
Richard van Zon

http://www.relectus.com/

## Overview ##

RLoginCompleter is a small framework for Cappuccino/Objectictive-J that lets you control saved usernames and passwords in web browsers. With only a few lines (one single line actually ;) you can extend your existing login dialog with auto completion.

## Demo ##
I setup a simple demo here: 

[http://www.relectus.com/os/RLoginCompleter/](http://www.relectus.com/os/RLoginCompleter/)

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