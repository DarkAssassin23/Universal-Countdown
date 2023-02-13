# Universal Countdown iOS App

## About
iOS Client for Universal Countdown

## Requirements
  * iOS 16 or newer

## Installation
To install the app onto your iPhone, you will need Xcode installed
 - version: 14.x+

### Enable Developer Mode
Seeing that this app is not on the App Store and you need to install 
it manually, you need to enable developer mode on your iPhone. To do
this, go to <code>Settings</code> -> <code>Privacy & Security</code>. 
Scroll down to the bottom and select <code>Developer Mode</code> and 
toggle it on. After you do so, Settings presents an alert to warn you 
that Developer Mode reduces the security of your device. To continue 
enabling Developer Mode, tap the alert’s Restart button.

### Trusting Developer License
Again, since this app is not on the App Store and you have to manually
install it onto your iPhone, your will most likely encounter an error 
from Xcode trying install it on your phone saying it was unable to 
launch the app becaues it has an invalid code signature. 

You will also see a similiar message on your iPhone saying "Untrusted 
Developer" and "Your device management settings do not allow using 
apps from developer <Your Developer Email/ID> on this iPhone." To fix 
this, Go to <code>Settings</code> -> <code>General</code> -> 
<code>VPN & Device Management</code>. From here tap the Developer App
and then trust it on the next page. Then re-build the app to your phone

## Configuration
To configure your client, select the settings icon at the bottom of the
screen and enter the IP and Port of your server. Optionally, you can 
set the occasion too. Finally, hit <code>Save</code> to save your 
changes.
