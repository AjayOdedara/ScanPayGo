# Scan Pay Go

To create an iOS application capable of being able to scan barcodes (1d/2d),
and display the related item details using a dummy database in the app.

<p align="center">
  <img width=25% src="https://github.com/AjayOdedara/ScanPayGo/blob/master/Barcodes/Barcode_1.png" />
  <img width=25% src="https://github.com/AjayOdedara/ScanPayGo/blob/master/Barcodes/Barcode_2.png" />
  <img width=25% src="https://github.com/AjayOdedara/ScanPayGo/blob/master/Barcodes/Barcode_3.png" />
</p>

## Table of Contents

- [About](#about)
- [Quick Start](#quick-start)
- [Features](#features)

## About

This mobile application is built using Swift 5.0 and Xcode 11.0 for iOS devices running iOS 13.0.

If attempting to run this code on future versions of Swift, Xcode, or iOS some additional work may be required to get this code running smoothly.

## Quick Start

The following steps will guide you through the process of running this application on your local machine, and device.

1. Ensure you have [Xcode 11.0](https://developer.apple.com/download/) installed
2. Ensure you have [SwiftLint](https://github.com/realm/SwiftLint) installed
3. Checkout this repository
4. Open `WiproTest.xcodeproj` with Xcode
5. Go to the project settings, and change the code signing team to your own

Code signing settings are left at automatic here for simplicity, you can set these to manual if needed but these steps will not take you through that process.

6. Attach an iPhone running iOS 13.0
7. Ensure the iPhone has development mode enabled, from the Devices & Simulators window: <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>2</kbd>
8. Clean, build and run the application on an iPhone running iOS 13.0

## Features

Below is the set of user stories that outline the intended functionality of this mobile application.

### User Stories

1. A scanner page with the capability of scanning 1-Dimensional or 2-Dimensional barcodes.  
2. A page displaying product information of the added items, containing at least product title, price and image for each item added to the cart.   
3. An intuitive navigation between all the pages (the user should not be stuck on any page or be dependent on any phone button for navigation).  
4. Demonstration with an iOS device. 
