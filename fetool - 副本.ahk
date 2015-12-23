;;;系统常用热键
;设置窗口匹配模式(因为打开多个vs,class是不一样的)
SetTitleMatchMode RegEx
#F10::Edit
#F9:: Reload

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


^!u::
;\u4e4b\u72d0
Send, ^c
UniStr = %clipboard%
ToolTip % uxxxx2cn(UniStr)
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
UniStr = %clipboard%
CnStr =% HexEscape(UniStr)
clipboard = %CnStr%
Send, ^v

HexEscape(cnStr) ;  "爱尔兰之狐" --> "\u7231\u5C14\u5170\u4E4B\u72D0"
{ ; from tmplinshi
    OldFormat := A_FormatInteger
    SetFormat, Integer, Hex
    Loop, Parse, cnStr
        out .= "\u" . SubStr( Asc(A_LoopField), 3 )
    SetFormat, Integer, %OldFormat%
    Return out
}

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

