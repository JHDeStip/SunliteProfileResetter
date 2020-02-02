# Sunlite Profiles Resetter
Run the *Setup.ps1* script as administrator to install.  
This will create the *C:\SunliteProfilesResetter* directory and a scheduled task that runs on every logon.

The task will scan for *.shw* files in this directory, remove the corresponding profiles from Sunlite Suite 2, and finally recreate them from the provided *.shw* files.  
Thus the state of the profiles that are in this directory will be reset on every logon.  
Also, if a profile named *Standaard* is found, Sunlite Suite will automatically open this when it starts without prompting.

The actual profiles can be found on *Google Drive*.