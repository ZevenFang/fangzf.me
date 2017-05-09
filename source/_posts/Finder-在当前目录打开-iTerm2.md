---
title: Finder 在当前目录打开 iTerm2
date: 2017-04-25 17:07:08
description: "使用 Automator 编写脚本即可实现使用快捷键在当前目录开启终端："
categories: 
- Mac
---
使用 Automator 编写脚本即可实现使用快捷键在当前目录开启终端：
1. 打开Automator，选择新建，选择服务
2. 服务接受设为没有输入，位置设为Finder
![20170421](http://7xoor3.com1.z0.glb.clouddn.com/blog/QQ20170421-171914.png)
3. 从左侧的资源库中找出 运行AppleScript，拖到右侧，然后保存为Open iTerm Here
![20170421](http://7xoor3.com1.z0.glb.clouddn.com/blog/QQ20170421-172049.png)
4. 在刚刚创建的AppleScript的输入框中输入如下代码
```shell
on run {input, parameters}
		
	tell application "Finder"
		set pathList to (quoted form of POSIX path of (folder of the front window as alias))
		set command to "clear; cd " & pathList
	end tell
	
	tell application "System Events"
		# some versions might identify as "iTerm2" instead of "iTerm"
		set isRunning to (exists (processes where name is "iTerm")) or (exists (processes where name is "iTerm2"))
	end tell
	
	tell application "iTerm"
		activate
		set hasNoWindows to ((count of windows) is 0)
		if isRunning and hasNoWindows then
			create window with default profile
		end if
		select first window
    
		tell the first window
			if isRunning and hasNoWindows is false then
				create tab with default profile
			end if
			tell current session to write text command
		end tell
	end tell
	
end run
```
5. 然后通知iTerm的第一个窗口新建标签并跳到这个目录去
6. 最后再去键盘设置里改一下快捷键，然后就可以快速在Finder中通过iTerm打开当前目录了
![0170421](http://7xoor3.com1.z0.glb.clouddn.com/blog/QQ20170421-172951.png)
