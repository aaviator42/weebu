# weebu 

Deploy commands to multiple computers/devices at the same time.  

License: `GNU AGPLv3`  
Current version: `3.1`


What is this?
-------------

**weebu** is a simple script that I created while developing a renderfarm using my school's computers. It allows you remotely deploy commands as many computers as you want, simultaneously.

How does it work?
-----------------

It's simple:

*   You upload your commands to a server
*   The computers check for new commands
*   They fetch the commands and run them
*   That's it!

What does it require?
---------------------

1.  Windows 7+
2.  A network connection
3.  Powershell (preinstalled on Windows 10)

How do I set it up?
-------------------

**1\. Set your server up**  
You just need a place on the internet where you can upload two files: `info.txt` and `commands.cmd`.

1. `info.txt`: This file contains only two lines of text. The first contains the version number of the current revision of `commands.cmd`. This _must_ be a positive decimal number. The second line contains the URL to `commands.cmd`.  
The following is an example:
    ```
    1.6  
    https://example.com/files/commands.cmd
    ```

2. `commands.cmd` : This file contains all the commands which are to be run.  
_**Note that the last command MUST be `exit`, without the `/b` switch.**_  
Example:
    ```
    @echo off
    mkdir testfolder
    cd testfolder
    echo testtext > testfile.txt
    REM exit
    exit
    ```
**2\. Set up weebu**

1.  Download `weebu.cmd`
2.  Edit the URL to `info.txt` in `weebu.cmd`

    ```
    set infourl=http://example.com/files/info.txt
    ```
**3\. Schedule weebu**
You have three options:
*   Use `looper.cmd` to run weebu in an infinite loop, so that it's checking for new scripts on the server constantly.
*   Schedule weebu to run  with [Task Scheduler](https://msdn.microsoft.com/en-us/library/windows/desktop/aa383614(v=vs.85).aspx)
    1.  Press Win\+ R
    2.  Type `control schedtasks` and press Enter
    3.  Go to `Action > Create Basic Task...` in the menu
    4.  Follow the instructions to schedule weebu to run at regular intervals
*   Run on startup
    1.  You can also make weebu run on startup by placing a shortcut to it in the startup folder.
    2.  Open Windows Explorer and navigate to `C:\ProgramData\Microsoft\Windows\Start Menu\Programs` and place a shortcut to weebu here if you want it to run on startup for _all users_.
    3.  Place the shortcut in `C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs` if you only want it to run on startup for the current user.

Now what?
---------

It's simple! Now everytime that you want to deploy a set of commands to the computers, save them in `commands.cmd` on your server, and increment the version number in the first line of `info.txt` by at least one decimal point.  

When the computers download `info.txt`, and see that the command version has increased, they will download the new set of commands and run them.

Logs are stored in `weebu_log.txt`. The `info.txt` file from the last run is saved as `oldinfo.txt`. Deleting this file will run `commands.cmd` on next execution regardless of what the version is.

* * *

Advanced Stuff & Tips
---------------------

### Deploying from the local network?

Delete the `::internetcheck` code block from `weebu.cmd`.

### Using FTP

Simply save the URL to `info.txt` with the `ftp://` prefix instead of `http://` or `https://`:

    set infourl=ftp://example.com/files/info.txt

### Encoding Usernames and Passwords in your URLs

Use the appropriate syntax in your URLs:

    set infourl=ftp://username:password@example.com/files/info.txt
