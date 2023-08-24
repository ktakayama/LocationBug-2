# Location Bug2

Similar bug:
https://github.com/ktakayama/LocationBug

## Problem Description:

When using Xcode15-beta6 and iOS17beta6, there is an issue that randomly occurs on a physical device (in this case, iPhone 11 Pro was used for testing) and not in the simulator. When EKEvent holds the specific event location and EKEventViewController is displayed, it may appear briefly and then the screen closes instantly.

## Steps to Reproduce:

1. Run this project on a physical device
2. Tap the 'Create/Edit event' button
3. Select 'Location' and choose a place
4. Manually enter 'Tokyo Tower'
5. Select 'Tokyo Tower' from 'Map Locations'
6. Save the event
7. Tap 'Show event'
8. Notice that the EKEventViewController may display briefly before instantly closing, although it might sometimes work as expected

## Expected Results:

When the EKEventViewController is opened, it should remain open, allowing the user to interact with the event details.

## Actual Results:

The EKEventViewController may randomly display briefly and then close instantly.

## Screen Recording:

https://github.com/ktakayama/LocationBug2/assets/42468/c181d338-bf0b-47b4-8b75-25d659997881

