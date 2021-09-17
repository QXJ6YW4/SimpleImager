# SimpleImager
This script has been created to ease out the process of Acquisition
Points to be considered before running the script:
```
1. Account used to log in to the machine should be Administrator account
2. Command Prompt (CMD) should be run as Administrator
3. USB ports should be enabled on the system to perform Imaging into an external drive or Mapped network drive
4. Run the D-Acquisition script 
5. Once Acquisition complete and message is displayed close the script and dismount the drive carefully
```

To view 'DeviceInfo.txt' information properly, in Notepad++ run Replace "\x00" with ""(blank) and select search mode as Extended, this will show the contents in a proper manner without the Null character 

The command to execute the script is as follows:
```
D-Acquisition.bat <"Drive letter where the image is to be collected">
```

Example 
```
D-Acquisition.bat Z:
```