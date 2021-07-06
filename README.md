# weebu

Deploy commands to multiple computers/devices at the same time.

License: `GNU AGPLv3`


<h2>What is this?</h2>
<p>weebu is a simple script that I created while developing a renderfarm using my school's computers. It lets you deploy commands to (one or) multiple computers/devices at the same time.</p>
<h2>How does it work?</h2>
<p>It's simple:</p>
<ul>
<li>You upload your commands to a server</li>
<li>The computers check for new commands</li>
<li>They fetch the commands and run them</li>
<li>That's it!</li>
</ul>
<p></p>
<h2>What does it require?</h2>
<ol>
<li>Windows 7+</li>
<li>A network connection</li>
<li>Powershell (preinstalled on Windows 10)
</li>
</ol>
<h2>How do I set it up?</h2>
<p>
<strong>1. Set your server up</strong>
<br> You just need a place on the internet where you can upload two files: 
<code>info.txt</code> and 
<code>commands.cmd</code>.
</p>


<p>
1. <code>info.txt</code>: This file contains only two lines of text. The first contains the version number of the current revision of 
<code>commands.cmd</code>. This 
<em>must</em> be a positive decimal number. The second line contains the URL to 
<code>commands.cmd</code>. The following is an example:</p>

<pre>1.6  
https://example.com/files/commands.cmd
</pre>
<p>2. <code>commands.cmd</code> : This file contains all the commands which are to be run. <em>Note that the last command MUST be 
<code>exit</code>, without the 
<code>/b</code> switch.
</em> Example:</p>
<pre>@echo off
mkdir testfolder
cd testfolder
echo testtext > testfile.txt
REM exit
exit
</pre>
<p>
<strong>2. Set up weebu</strong>
</p>
<ol>
  <li>Download <code>weebu.cmd</code></li>
<li>Edit the URL to 
<code>info.txt</code> in 
<code>weebu.cmd</code>

</li>
</ol>
<pre>set infourl=http://example.com/files/info.txt
</pre>
<p>
<strong>3. Schedule weebu</strong>
</p>
<ul>
  <li>Use <code>looper.cmd</code> to run weebu in an infinite loop, so that it's checking for new scripts on the server constantly.</li> 
<li>Schedule weebu to run using with 
<a href="https://msdn.microsoft.com/en-us/library/windows/desktop/aa383614(v=vs.85).aspx">Task Scheduler</a>
<ol>
<li>Press 
<kbd>Win</kbd>+
<kbd>R</kbd>
</li>
<li>Type 
<code>control schedtasks</code> and press 
<kbd>Enter</kbd>
</li>
<li>Go to 
<code>Action &gt; Create Basic Task...</code> in the menu
</li>
<li>Follow the instructions to schedule weebu to run at regular intervals</li>
</ol>
</li>
<li>Run on startup
<ol>
<li>You can also make weebu run on startup by placing a shortcut to it in the startup folder.</li>
<li>Open Windows Explorer and navigate to 
<code>C:\ProgramData\Microsoft\Windows\Start Menu\Programs</code> and place a shortcut to weebu here if you want it to run on startup for 
<em>all users</em>.
</li>
<li>Place the shortcut in 
<code>C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs</code> if you only want it to run on startup for the current user.
</li>
</ol>
</li>
</ul>
<h2>Now what?</h2>
<p>It's simple! Now everytime that you want to deploy a set of commands to the computers, save them in 
<code>commands.cmd</code> on your server, and increment the version number in the first line of 
<code>info.txt</code> by at least one decimal point.
<br> When the computers download 
<code>info.txt</code>, and see that the command version has increased, they will download the new set of commands and run them.
</p>
<hr>
<p></p>
<h2>Advanced Stuff &amp; Tips</h2>
<h3>Using FTP</h3>
<p>Simply save the URL to 
<code>info.txt</code> with the 
<code>ftp://</code> prefix instead of 
<code>http://</code> or 
<code>https://</code>:
</p>
<pre><code>set infourl=ftp://example.com/files/info.txt</code></pre>
<h3>Encoding Usernames and Passwords in your URLs</h3>
<p>Use the appropriate syntax in your URLs:</p>
<pre>set infourl=ftp://username:password@example.com/files/info.txt
</pre>
