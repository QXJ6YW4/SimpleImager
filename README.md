### SimpleImager V4.3
This script has been created to ease out the process of Acquisition
Points to be considered before running the script:
```
1. Account used to log in to the machine should be Administrator account
2. Command Prompt (CMD) should be run as Administrator
3. USB ports should be enabled on the system to perform Imaging into an external drive or Mapped network drive
4. Run the D-Acquisition script 
5. Once Acquisition complete and message is displayed close the script and dismount the drive carefully
6. When the script is executed it will collect information of the host device on which the script is executed.
7. Information such as the serial number of the host, serial number of the hard drive, details of peripherals connected to the host etc.. The collected information is available in DeviceInfo.txt
8. The script also collects information on the BitLocker Key if the host drive is encrypted with bitlocker
```

To view 'DeviceInfo.txt' information properly, in Notepad++ run Replace "\x00" with ""(blank) and select search mode as Extended, this will show the contents in a proper manner without the Null character 

The command to execute the script is as follows:
```
D-Acquisition.bat <"Drive letter where the image is to be collected OR the path where you want to store the image">
```

Example 
```
D-Acquisition.bat Z:

D-Acquisition.bat D:\Work\Test_Image

```
