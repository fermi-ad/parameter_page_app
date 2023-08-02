Add Comment to Page
 - Enter device name starting with !, should be added as a comment
   - E.g. I:BEAM

Display Parameter Page
 - Devices with no setting property, should display reading only
   - M:OUTTMP, Z:BTE200_TEMP, PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE, PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:HUMIDITY
 - Comments, should be present and display no data
 - Device in error, should display error code for reading property
 - Device in error, should display error code for setting property
 - Device in error, should display error code for basic status property

Delete Entry from Page
 - None

Re-organize Parameters
 - None

Add Parameter to Page
 - Submit PV name, should appear at bottom of the page
   - E.g. PIP2:SSR1:SUBSYSTEMB:SUBSUBSYSTEM:DEVICE1

Cancel Page Edits
 - None

Clear All Entries
 - Tap Clear All, should be prompted to confirm
 - Tap Clear All and cancel, all parameters remain on page
 - Tap Clear All and confirm, all parameters are removed from page

Create New Parameter Page
 - None

Display Parameter Alarm Details
 - Turn on Alarm Details Display, Z:NO_ALARMS displays no alarm details

Change Display Units
 - None

Display Digital Status Detail
 - None

 Write to Parameter
 - None

 Send Command
 - None

Other
 - Re-run acceptance tests in narrow mode
 - Proof-of-Concept, integrate acceptance test suite with JAMA

