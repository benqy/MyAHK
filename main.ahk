;;;系统常用热键
;设置窗口匹配模式(因为打开多个vs,class是不一样的)
SetTitleMatchMode RegEx
#F10::Edit
#F9:: Reload

;;音量  
SendMode Input 
SetWorkingDir %A_ScriptDir%

;;调小  
^!WheelDown::  
Send {Volume_Down 2}
SoundGet, vol_Master, MASTER, VOLUME
ToolTip, 当前音量%vol_Master%。
SetTimer, RemoveToolTip, 1000
return

  
;;调大
^!WheelUp::   
Send {Volume_Up 2}
SoundGet, vol_Master, MASTER, VOLUME
ToolTip, 当前音量%vol_Master%。
SetTimer, RemoveToolTip, 1000
return  

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

;;静音
;^!WheelUp::  
;Send {Volume_Mute}  ; Mute/unmute the master volume.  
;return



^!u::
Send, ^c
sleep,200
UniStr = %clipboard%
CnStr = % uxxxx2cn(UniStr)
ToolTip %CnStr%
clipboard = %CnStr%
SetTimer, RemoveToolTip, 3000
return

uxxxx2cn(s) {
	i := 1
	while j := RegExMatch(s, "\\u[A-Fa-f0-9]{1,4}", m, i)
		e .= SubStr(s, i, j-i) Chr("0x" SubStr(m, 3)), i := j + StrLen(m)
	return e . SubStr(s, i)
}

^!i::
Send, ^c
sleep,200
UniStr = %clipboard%
CnStr =% cn2uxxxx(UniStr)
clipboard = %CnStr%
Send, ^v
return

cn2uxxxx(cnStr)
{ ; from tmplin = A_FormatInteger
    SetFormat, Integer, Hex
    Loop, Parse, cnStr
    {
    	;;\u4E2De
      FoundPos := RegExMatch(A_LoopField, "\p{Han}")
      ;;Msgbox %A_LoopField%
      ;;Msgbox %FoundPos%
    	;;if( A_LoopField = "a")
      if( FoundPos = 0)
      {
      	out .= A_LoopField
      }
      else
      {
        out .= "\u" . SubStr( Asc(A_LoopField), 3 )
      }
    }
    SetFormat, Integer, %OldFormat%
    Return out
}

;;当前文件夹CMD
#T:: 
OpenCmdInCurrent()
return
OpenCmdInCurrent()
{
    WinGetText, full_path, A  ; This is required to get the full path of the file from the address bar

    ; Split on newline (`n)
    StringSplit, word_array, full_path, `n
    full_path = %word_array1%   ; Take the first element from the array

    ; Just in case - remove all carriage returns (`r)
    ;;替换错误的地址字符串 "地址:x:\xx"中的地址:
    StringReplace, full_path, full_path,地址:, , all  
    StringReplace, full_path, full_path, `r, , all
    IfInString full_path, \
    {
        Run, cmd /K cd /D "%full_path%"
    }
    else
    {
        Run, cmd /K cd /D "C:\ "
    }
}




#`::  ; 将当前窗口置顶, 即始终保持窗口在其他窗口上面
WinGetActiveTitle, Title
WinSet, AlwaysOnTop, toggle, %Title%
return

#1::WinSet, Style, -0xC00000, A
return
#2::WinSet, Style, +0xC00000, A
return
#Q::
Run mstsc
return
#C:: ;复制文件的完整路径
send ^c
sleep,200
clipboard=%clipboard% 
return
#B:: ;;打开记事本
Run NotePad
return
#E::
IfWinExist, Clover
{
	WinActivate,Clover
}
else
{
	Run "C:\Program Files (x86)\Clover\clover.exe"
}
return
#x:: ;;取鼠标位置的颜色
MouseGetPos, mouseX, mouseY
        ; 获得鼠标所在坐标，把鼠标的 X 坐标赋值给变量 mouseX ，同理 mouseY
PixelGetColor, color, %mouseX%, %mouseY%, RGB
        ; 调用 PixelGetColor 函数，获得鼠标所在坐标的 RGB 值，并赋值给 color
StringRight color,color,6
        ; 截取 color（第二个 color） 右边的 6 个字符，因为获得的值是这样的：#RRGGBB，一般我们只需要 RRGGBB 部分。把截取到的值再赋给 color（第一个 color）。
clipboard = %color%
        ; 把 color 的值发送到剪贴板
return
#K:: ;;关闭指定的进程
InputBox ,winTitlek,"关闭进程","输入进程名称",,,140
if(ErrorLevel){
}
else{
	WinClose,%winTitlek%
}
return
#H:: ;;隐藏指定的进程
InputBox ,winTitleh,"隐藏窗口","输入窗口名称",,,140
if(ErrorLevel){
}
else{
	WinHide,%winTitleh%
}
return
#J:: ;;隐藏指定的进程
InputBox ,winTitlej,"显示窗口","输入窗口名称",,,140
if(ErrorLevel){
}
else{
	WinShow,%winTitlej%
}
return
#W::
Run "E:\EverBox\workspace"
return
#P:: ;;截图工具
SoundGet, master_volume
MsgBox, Master volume is %master_volume% percent.

SoundGet, master_mute, , mute
MsgBox, Master Mute is currently %master_mute%.

SoundGet, bass_level, Master, bass
if ErrorLevel
    MsgBox, Error Description: %ErrorLevel%
else
    MsgBox, The BASS level for MASTER is %bass_level% percent.

SoundGet, microphone_mute, Microphone, mute
if microphone_mute = Off
    MsgBox, The microphone is not muted.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;打开文件;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Book
#!B::
Run "E\EverBox\Book"
return
;Dropbox
#!D::
Run "H:\dropbox\Dropbox"
return
;DownLoad
#!L::
Run "E:\TDDOWNLOAD"
return
#!M::
Run "D:\workspace\demo"
return
;Book
#V::
Run "E:\EverBox"
return
#!W::
Run "E:\EverBox\workspace"
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;打开常用网页;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#G::
Run "http://www.google.com/search?q=%clipboard%"
return
#O::
Run "http://translate.google.com/#en|zh-CN|%clipboard%"
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;常用软件;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;11平台
^!1::
Run "F:\game\11game\11Game.exe"
return
;chrome
^!C::
IfWinExist, ahk_class Chrome_WidgetWin_1
{
    WinActivate,ahk_class Chrome_WidgetWin_1
}
else IfWinExist, ahk_class Chrome
{
    WinActivate,ahk_class Chrome
}
else{
       Run "C:\Users\17173\AppData\Local\Google\Chrome\Application\chrome.exe"
}
return
;HBuilder
^!D::
IfWinExist,Hexo
{
	WinActivate,Hexo
}
else
{
	Run "E:\github\hexomd\hexomd.exe"
}
return
;Firefox
^!F::
IfWinExist, foobar2000
{
    WinActivate, foobar2000
}
else
{
    Run "C:\Program Files (x86)\Fiddler2\Fiddler.exe"
}
return
;Gungnir
^!G::
IfWinExist Gungnir
{
    WinActivate, Gungnir
}
else
{
Run "E:\soft\Gungnir\nw.exe"
}
return
^!H::
IfWinExist, HEXOMD
{
	WinActivate,HEXOMD
}
else
{
	Run "E:\soft\hexomd\hexomd.exe"
}
return

;Myssh
^!M::
Run "E:\win8everybox\qiang\BitviseSSHClientPortable.exe"
return
;outlook
^!O::
Run "C:\Users\17173\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu\Microsoft Office Outlook 2007.lnk"
return
;PS
^!P::
Run "C:\Program Files\Adobe\Adobe Photoshop CS5 (64 Bit)\Photoshop.exe"
return
;QQ
^!Q::
IfWinExist ahk_class TXGuiFoundation
{
    WinActivate,ahk_class TXGuiFoundation
}
else
{
    Run "C:\Program Files (x86)\Tencent\QQ\Bin\QQ.exe"
}
return

;VS
^!V::
;;HwndWrapper
IfWinExist Studio
{
    WinActivate, Studio
}
else
{
    Run "E:\soft\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"
}
return
^!W::
IfWinExist, ahk_class IEFrame
{
    WinActivate,ahk_class IEFrame
}
else
{
    Run "c:\Program Files\Internet Explorer\iexplore.exe"
}
return
;gungnir
^!X::
IfWinExist Gungnir
{
    WinActivate, Gungnir
}
else
{
Run "E:\soft\Gungnir\nw.exe"
}
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;片段文本;;;;;;;;;;;;;;;;;;;
::/l::hmjlr123  ;输入账户
::/e::hmjlr123@gmail.com ;;输入邮箱
::/dd::  ;;输入完整日期
d = %A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%
clipboard = %d%
Send ^v
return
::/md:: ;输入月日
d = %A_MM%%A_DD%
clipboard = %d%
Send ^v
return

::/desc:: ;输入月日
d = %A_YYYY%-%A_MM%-%A_DD%
clipboard = 骑兵程序员,%d%
Send ^v
return

;;;;;;;;;;;;;;;;;;;;;;;;;;常用操作;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
^!RButton::
Send ^!{Right}