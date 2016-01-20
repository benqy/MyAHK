Autohotkey常用脚本
==

[Autohotkey](http://ahkscript.org/)是一个非常强大而简单的脚本工具,用它可以实现很多自动化的小工具,用来提高自己的工作效率.

分享下自己常用的一些脚本段.

## 常用快捷键

`#` : Win (Windows 标识键)

`!` : Alt 

`^` : Control 

`+` : Shift 

## 常用脚本段


### 音量调节

定时移除ToolTip,调节音量的脚本需要用到
```
RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return
```

`ctrl+alt+鼠标滚轮向下滚动` 调小音量
```
^!WheelDown::  
Send {Volume_Down 2}
SoundGet, vol_Master, MASTER, VOLUME
ToolTip, 当前音量%vol_Master%。
SetTimer, RemoveToolTip, 1000
return
```

`ctrl+alt+鼠标滚轮向上滚动` 调大音量
```
^!WheelUp::   
Send {Volume_Up 2}
SoundGet, vol_Master, MASTER, VOLUME
ToolTip, 当前音量%vol_Master%。
SetTimer, RemoveToolTip, 1000
return  
```

### CMD

按下`Win+T`,在当前文件夹打开CMD.

```
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
```
### 窗口置顶,

选中窗口,按`window+~`,该窗口将终保持在其他窗口上面(z-index:max)

```autohotkey
#`::
WinGetActiveTitle, Title
WinSet, AlwaysOnTop, toggle, %Title%
return
```

###  复制文件的完整路径

选中文件,按`window+C`复制文件的路径

```
#C::
send ^c
sleep,200
clipboard=%clipboard% 
return
```

### 取色
按下`window+x`取鼠标位置的颜色

```
#x::
; 获得鼠标所在坐标，把鼠标的 X 坐标赋值给变量 mouseX ，同理 mouseY
MouseGetPos, mouseX, mouseY
; 调用 PixelGetColor 函数，获得鼠标所在坐标的 RGB 值，并赋值给 color
PixelGetColor, color, %mouseX%, %mouseY%, RGB
 ; 截取 color（第二个 color） 右边的 6 个字符，因为获得的值是这样的：#RRGGBB，一般我们只需要 RRGGBB 部分。把截取到的值再赋给 color（第一个 color）。
StringRight color,color,6
; 把 color 的值发送到剪贴板
clipboard = %color%
return
```
### 窗口隐藏

按下`window+h`弹出输入框,输入想要隐藏的窗口`名称(不必完全匹配,部分即可)`,确定后该窗口即隐藏,主要用于隐藏烦人又不能屏蔽的RTX窗口

```
#H::
InputBox ,winTitleh,"隐藏窗口","输入窗口名称",,,140
if(ErrorLevel){
}
else{
	WinHide,%winTitleh%
}
return
```

### 显示窗口

主要用于恢复被上一个脚本(`window+h`)隐藏的窗口,按下`window+j`,弹出输入框,输入要显示的窗口名称,确定后该窗口显示出来.

```
#J::
InputBox ,winTitlej,"显示窗口","输入窗口名称",,,140
if(ErrorLevel){
}
else{
	WinShow,%winTitlej%
}
return
```

### UNICODE


1. 选中`\uxxxx`格式的字符串,按下`ctrl+alt+u`,会显示实际的字符,并复制到剪贴板

```
^!u::
Send, ^c
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

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return
```


2. 选中普通字符串,按下`ctrl+alt+i`,会将该字符串转为`\uxxxx`,并复制到剪贴板

```
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
      ;;正则判断是否为汉字
      FoundPos := RegExMatch(A_LoopField, "\p{Han}")
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
```



