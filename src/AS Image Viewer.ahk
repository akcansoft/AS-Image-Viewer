/*
======================
AS Image Viewer
v1.6
R47
14/06/2025
======================
This application is a minimalist image viewer that uses GDI+ for rendering,
supports multiple image formats,
and allows easy navigation and management through a simple GUI.

Mesut Akcan
makcan@gmail.com
akcansoft.blogspot.com
mesutakcan.blogspot.com
github.com/akcansoft
youtube.com/mesutakcan

What's new in v1.6:
- Code improvements
- Language support optimization
- Spanish language support added
- Added keyboard shortcuts to context menu

TODO:
- Paste image from clipboard
- Rotate image
- Rotate image based on EXIF orientation
- Slideshow
- Zoom to mouse cursor
- Save settings
- Add Menu Icons
*/

#Requires AutoHotkey v2.0
#SingleInstance Off
#NoTrayIcon

#Include "gdip_all.ahk" ; Load the GDI+ library
#Include "langSupport.ahk" ; Load language support library

A_ScriptName := "AS Image Viewer v1.6"

LoadLanguage() ; Load language strings

; Start GDI+
if !pToken := Gdip_Startup() {
  MsgBox(lang["File_load_failed"], , "Icon! 4096")
  ExitApp()
}

extensions := "*.jpg; *.jpeg; *.png; *.gif; *.bmp; *.tif; *.ico; *.webp; *.wmf" ; Supported image file extensions
dropFile := "" ; Dropped file
DblClickTime := DllCall("GetDoubleClickTime", "UInt") ; Double click time
imageFiles := [] ; Image files array
imgFile := "" ; Image file
currentFolder := "" ; Current folder
lastIndex := 0 ; Last index
imgNo := 0 ; Image number

g := Gui("+OwnDialogs -Caption -Border +AlwaysOnTop -DPIScale") ; Create a GUI window
; GUI events
g.OnEvent("Close", GuiClose) ; Close event
g.OnEvent("Size", GuiSize) ; Size event
g.OnEvent("DropFiles", Gui_DropFiles) ; Drop files event

CreateMenu() ; Create right-click menu
OpenFile() ; openfile & loadimage

#HotIf WinActive(g.Hwnd)
Home:: LoadImageByMode("first") ; Home key
Browser_Back:: ; Browser back key
Left:: LoadImageByMode("prev") ; Left arrow key
Browser_Forward:: ; Browser forward key
Right:: LoadImageByMode("next") ; Right arrow key
End:: LoadImageByMode("last") ; End key
NumpadAdd:: ZoomImage(1) ; Numpad + key
NumpadSub:: ZoomImage(-1) ; Numpad - key
Numpad0:: ZoomImage(0) ; Numpad 0 key. Original size
Numpad1:: ZoomImage(2) ; Numpad 2 key. Fit to screen

F1:: FileInfo() ; File info
F2:: FileProperties() ; File properties
F3:: ShowFileInFolder() ; Show file in folder
F5:: ShowImage() ; Refresh
^o:: OpenFile() ; Ctrl+o
^c:: CopyImageToClipboard() ; Ctrl+c
Esc:: ToolTip() ; Close tooltip

#HotIf mouseIsOver(g.Hwnd) ; Mouse is over the GUI window
Down:: ; Down arrow key
RButton:: rcMenu.Show() ; right-click
WheelUp:: ZoomImage(1) ; mouse wheel up
WheelDown:: ZoomImage(-1) ; mouse wheel down
XButton1:: LoadImageByMode("prev") ; 4th mouse button
XButton2:: LoadImageByMode("next") ; 5th mouse button
~MButton:: ; Middle mouse button
~LButton:: HandleMouseClick() ; Left mouse button
#HotIf

; Hotkey to handle double-click events
HandleMouseClick() {
  if (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < DblClickTime) {
    switch A_ThisHotkey {
      case "~MButton":
        ZoomImage(2) ; Fit image to screen on middle double click
      case "~LButton":
        ZoomImage(0) ; Original size on left double click
    }
    return
  }
  if (A_ThisHotkey = "~LButton") {
    MoveWindow()
  }
}

; Create right-click menu
CreateMenu() {
  global rcMenu, mnuTxt

  imageres := A_WinDir "\system32\imageres.dll" ; icon file
  shell32 := A_WinDir "\system32\shell32.dll" ; icon file
  rcMenu := Menu() ; Right click menu

  ; Right click menu items
  mnuTxt := {
    open: lang["Menu_open"] . "`tCtrl+O", ; Open image file
    exit: lang["Menu_exit"] . "`tAlt+F4", ; Exit application
    first: lang["Menu_first"] . "`tHome", ; First image
    prev: lang["Menu_prev"] . "`tLeft", ; Previous image
    next: lang["Menu_next"] . "`tRight", ; Next image
    last: lang["Menu_last"] . "`tEnd", ; Last image
    zoomin: lang["Menu_zoomin"] . "`tNumpad +", ; Zoom in
    zoomout: lang["Menu_zoomout"] . "`tNumpad -", ; Zoom out
    fit: lang["Menu_fit"] . "`tNumpad 1", ; Fit to screen
    osize: lang["Menu_osize"] . "`tNumpad 0", ; Original size
    refresh: lang["Menu_refresh"] . "`tF5", ; Refresh image
    copy: lang["Menu_copy"] . "`tCtrl+C", ; Copy image
    ; File info and properties
    fileinfo: lang["Menu_fileinfo"] . "`tF1", ; File info
    fileprop: lang["Menu_fileprop"] . "`tF2", ; File properties
    fileinfolder: lang["Menu_fileinfolder"] . "`tF3", ; Show file in folder

    aot: lang["Menu_aot"], ; Always on top
    border: lang["Menu_border"], ; Window border
    shortcuts: lang["Menu_shortcuts"], ; Shortcuts
    about: lang["Menu_about"] ; About dialog
  }

  ; Menu items array with text, icon file, and icon number
  menuItems := [{ text: mnuTxt.open, iconFile: imageres, iconNo: 195 }, ; Open
    { text: mnuTxt.exit, iconFile: imageres, iconNo: 94 }, ; Exit
    { separator: true }, ; Separator
    { text: mnuTxt.first }, ; First image
    { text: mnuTxt.prev }, ; Previous image
    { text: mnuTxt.next, iconFile: shell32, iconNo: 298 }, ; Next image
    { text: mnuTxt.last }, ; Last image
    { separator: true }, ; Separator
    { text: mnuTxt.zoomin }, ; Zoom in
    { text: mnuTxt.zoomout }, ; Zoom out
    { text: mnuTxt.fit , iconFile: shell32, iconNo: 16 }, ; Fit to screen
    { text: mnuTxt.osize }, ; Original size
    { separator: true }, ; Separator
    { text: mnuTxt.refresh, iconFile: shell32, iconNo: 239 }, ; Refresh
    { text: mnuTxt.copy, iconFile: shell32, iconNo: 135 }, ; Copy
    { separator: true }, ; Separator
    { text: mnuTxt.fileinfo, iconFile: shell32, iconNo: 222 }, ; File info
    { text: mnuTxt.fileprop }, ; File properties
    { text: mnuTxt.fileinfolder, iconFile: shell32, iconNo: 267 }, ; Show file in folder
    { separator: true }, ; Separator
    { text: mnuTxt.aot, check: true }, ; Always on top
    { text: mnuTxt.border}, ; Window border -- iconFile: shell32, iconNo: 98
    { separator: true }, ; Separator
    { text: mnuTxt.shortcuts , iconFile: shell32, iconNo: 30 }, ; Shortcuts
    { text: mnuTxt.about, iconFile: shell32, iconNo: 155 } ; About
  ]

  ; Add menu items to the right-click menu
  for index, item in menuItems {
    ; Check if the item has a separator property
    if (item.HasOwnProp("separator")) {
      rcMenu.Add() ; add separator
      continue ; skip to the next item
    }
    ; Add the item to the right-click menu
    rcMenu.Add(item.text, menuHandler)
    ; Check if the item has an icon file and icon number
    if (item.HasOwnProp("iconFile") && item.HasOwnProp("iconNo")) {
      ; Set the icon for the item
      rcMenu.SetIcon(item.text, item.iconFile, item.iconNo)
    }
    ; Check if the item has a check property and if it is true
    if (item.HasOwnProp("check") && item.check) {
      rcMenu.Check(item.text)
    }
  }
}

; Menu handler function for right-click menu items
menuHandler(item, *) {
  global mnuTxt
  switch item {
    case mnuTxt.open: OpenFile()
    case mnuTxt.exit: GuiClose()
    case mnuTxt.first: LoadImageByMode("first")
    case mnuTxt.prev: LoadImageByMode("prev")
    case mnuTxt.next: LoadImageByMode("next")
    case mnuTxt.last: LoadImageByMode("last")
    case mnuTxt.zoomin: ZoomImage(1)
    case mnuTxt.zoomout: ZoomImage(-1)
    case mnuTxt.fit: ZoomImage(2)
    case mnuTxt.osize: ZoomImage(0)
    case mnuTxt.refresh: ShowImage()
    case mnuTxt.copy: CopyImageToClipboard()
    case mnuTxt.fileinfo: FileInfo()
    case mnuTxt.fileprop: FileProperties()
    case mnuTxt.fileinfolder: ShowFileInFolder()
    case mnuTxt.aot: toggleAOT()
    case mnuTxt.border: toggleBorder()
    case mnuTxt.shortcuts: Shortcuts()
    case mnuTxt.about: About()
  }
}

; Open image file
OpenFile() {
  global bitmap, extensions
  ; Get the file path from args, dropped file, or file dialog
  iFile := GetImageFilePath()
  if !iFile { ; Check if the file path is empty
    MsgBox(lang["File_nofile"], , "Icon! 4096")
    if !IsSet(bitmap)
      ExitApp()
    return
  }

  SplitPath iFile, , , &ext ; Split the file path into extension
  ; Validate the image file
  if !ext || !InStr(extensions, ext) || !FileExist(iFile) {
    MsgBox(lang["File_invalid_file"] ":`n" iFile, , "Icon! 4096")
    return
  }
  LoadImageFromFile(iFile) ;Load the image from the file
}

; Get the image file path from the command line arguments, dropped file, or file dialog
GetImageFilePath() {
  static argsUsed := false
  global dropFile, extensions
  if !argsUsed && A_Args.Length > 0 { ; Command line arguments
    argsUsed := true
    return A_Args[1] ; Return the first command line argument
  }
  if dropFile { ; Dropped file
    dFile := dropFile ; Dropped file path
    dropFile := "" ; Clear the dropFile variable
    return dFile ; Return the dropped file path
  }
  g.Opt("+OwnDialogs")
  return FileSelect(, , lang["File_select_image_file"], "Images (" extensions ")")
}

; Load the image from the specified file
LoadImageFromFile(lFile) {
  global imageFiles, currentFolder, imageFiles, lastIndex, imgNo
  SplitPath lFile, , &folder
  ; Check if the folder has changed or the imageFiles array is empty
  if (folder != currentFolder || imageFiles.Length = 0) {
    imageFiles := GetImageFilesInFolder(folder) ; Get all image files in the folder
    currentFolder := folder ; Update the current folder
    lastIndex := 0 ; Reset lastIndex when folder changes
  }

  imgNo := getArrayValueIndex(lFile) ; Get the index of the file in the imageFiles array
  imgFile := lFile ; Set the image file
  LoadImage(imgNo) ; Load the image
}

; Get all image files in the specified folder
GetImageFilesInFolder(folder) {
  global extensions
  files := [] ; Array to store image files
  Loop Files, folder "\*.*" { ; Loop through all files in the folder
    if InStr(extensions, A_LoopFileExt) ; Check if the file extension is supported
      files.Push(A_LoopFileFullPath) ; Add the file to the array
  }
  return files ; Return the array of image files
}

; Image loading function
LoadImage(index) {
  global
  imgFile := imageFiles[index] ; Get the image file path

  ; Check if the index is the same as the last loaded index
  if (index = lastIndex) {
    return
  }

  bitmap := Gdip_CreateBitmapFromFile(imgFile) ; Load the image file
  if !bitmap { ; Check if the image file failed to load
    MsgBox "Failed to load image file: " imgFile, , "Icon! 4096"
    return
  }

  lastIndex := index ; Update the last index

  ; Get image dimensions
  originalWidth := Gdip_GetImageWidth(bitmap)
  originalHeight := Gdip_GetImageHeight(bitmap)

  ; Check if the image is larger than the screen
  if (originalWidth > A_ScreenWidth || originalHeight > A_ScreenHeight) {
    ZoomImage(2) ; Fit to screen
    return
  }
  else {
    imgWidth := originalWidth ; Set the image width
    imgHeight := originalHeight ; Set the image height
    zoomFactor := 1 ; Reset the zoom factor
  }
  ShowGui() ; Show the image on the GUI
}

; Load the first, last, next, or previous image based on the mode
LoadImageByMode(mode) {
  global imgNo, imageFiles
  switch mode {
    case "first": imgNo := 1 ; Load the first image
    case "last": imgNo := imageFiles.Length ; Load the last image
    case "next": ; Next image
      imgNo++ ; Increment the image number
      if (imgNo > imageFiles.Length)
        imgNo := 1 ; Reset the image number
    case "prev": ; Previous image
      imgNo-- ; Decrement the image number
      if (imgNo < 1)
        imgNo := imageFiles.Length ; Reset the image number
  }
  LoadImage(imgNo) ; Load the image
}

; Show the image on the GUI
ShowImage(*) {
  global
  ToolTip() ; Close tooltip
  local hDC := DllCall("GetDC", "Ptr", g.Hwnd, "Ptr") ; Get the device context of the GUI window
  local GG := Gdip_GraphicsFromHDC(hDC) ; Create a graphics object from the device context
  ;Gdip_GraphicsClear(GG, 0xFFF0F0F0)
  Gdip_DrawImage(GG, bitmap, 0, 0, imgWidth, imgHeight) ; Draw the image on the graphics object
  Gdip_DeleteGraphics(GG) ; Delete the graphics object
  DllCall("ReleaseDC", "Ptr", g.Hwnd, "Ptr", hDC) ; Release the device context
}

ZoomImage(zoomMode) {
  global
  static prevZoomFactor := 1

  switch zoomMode {
    case 0: zoomFactor := 1 ; Original size
    case 1: zoomFactor += 0.1 ; Zoom in
    case -1: zoomFactor -= 0.1 ; Zoom out
    case 2: ; Fit to screen
      local imgAspectRatio := originalWidth / originalHeight
      ; Determine the zoom factor based on the aspect ratio
      if (imgAspectRatio > (A_ScreenWidth / A_ScreenHeight)) {
        zoomFactor := A_ScreenWidth / originalWidth
      } else {
        zoomFactor := A_ScreenHeight / originalHeight
      }
  }

  ; Ensure zoomFactor is within reasonable bounds
  if (zoomFactor < 0.1) ; Minimum zoom factor
    zoomFactor := prevZoomFactor
  else
    prevZoomFactor := zoomFactor

  ; Update image dimensions
  imgWidth := Round(originalWidth * zoomFactor)
  imgHeight := Round(originalHeight * zoomFactor)
  ShowGui() ; Show the image on the GUI
}

; Toggle Always On Top
toggleAOT(*) {
  global rcMenu, mnuTxt, g
  rcMenu.ToggleCheck(mnuTxt.aot) ; Toggle the checkmark
  WinSetAlwaysOnTop(-1, g) ; toggle aot
}

; Toggle Window Border
toggleBorder(*) {
  global rcMenu, mnuTxt, g
  rcMenu.ToggleCheck(mnuTxt.border) ; Toggle the checkmark
  WinSetStyle("^0x800000", g) ; toggle border
  g.Show()
}

; Displays the GUI window with specified dimensions and positioning.
ShowGui() {
  global imgWidth, imgHeight, g
  g.Show("w0")
  local sizeTxt := "w" imgWidth " h" imgHeight
  if imgWidth > A_ScreenWidth || imgHeight > A_ScreenHeight
    g.Show(sizeTxt)
  else
    g.Show(sizeTxt " Center")
}

; Function to get the index of a value in the imageFiles array
getArrayValueIndex(val) {
  global imageFiles
  Loop imageFiles.Length { ; Loop through the imageFiles array
    if (imageFiles[A_Index] = val) ; Check if the value matches the current index
      return A_Index ; Return the index
  }
}

; Function to check if the mouse cursor is over the GUI window
mouseIsOver(windowIdentifier) {
  MouseGetPos(, , &winHwnd)
  return (winHwnd = windowIdentifier)
}

; Function to handle GUI resizing events
GuiSize(gui, minMax, width, height) {
  if (minMax = 0) { ; 0 = Restored from minimized state
    ShowImage()
  }
}

; Clean up GDI+ resources when Gui is closed
GuiClose(*) {
  global bitmap, pToken
  Gdip_DisposeImage(bitmap) ; Dispose of the image
  Gdip_Shutdown(pToken) ; Shutdown GDI+
  ExitApp() ; Exit the application
}

; Show the image file in the folder
ShowFileInFolder() {
  global imgFile
  Run('explorer.exe /select,"' imgFile '"') ; Show the file in the folder
  ;Sleep(1000) ; Wait for the window to open
  WinWait("ahk_class CabinetWClass") ; Wait for the window to appear
  WinActivate("ahk_class CabinetWClass") ; Activate the window
  WinSetAlwaysOnTop(, "A") ; Set the window to always on top
}

; Image file info
FileInfo() {
  global imgFile, originalWidth, originalHeight, imgWidth, imgHeight
  SplitPath(imgFile, &file, &dir) ; Split the image file path into file and directory
  mfd := FileDT("M") ; Modification time
  cfd := FileDT("C") ; Creation time
  afd := FileDT("A") ; Last Access time
  fsize := FileGetSize(imgFile) ; File size
  fs := FormatByteSize(fsize) " (" RegExReplace(fsize, "(\d)(?=(\d{3})+(?!\d))", "$1.") " bytes)" ; File size
  m := lang["FileInfo_folder"] ": " dir "`n" ; Tooltip message
  m .= lang["FileInfo_file"] ": " file "`n"
  m .= lang["FileInfo_mod_time"] ": " mfd "`n"
  m .= lang["FileInfo_create_time"] ": " cfd "`n"
  m .= lang["FileInfo_access_time"] ": " afd "`n"
  m .= lang["FileInfo_orig_size"] ": " originalWidth "x" originalHeight "`n"
  m .= lang["FileInfo_disp_size"] ": " imgWidth "x" imgHeight "`n"
  m .= lang["FileInfo_file_size"] ": " fs
  CoordMode("ToolTip", "Screen")
  WinGetPos(&x, &y, , , g)
  tX := Max(0, x) ; Tooltip x pos
  tY := Max(0, y) ; Tooltip y pos
  ToolTip(m, tX + 5, tY + 5)
}

; Formatted File Date & Time
FileDT(opt) {
  global imgFile
  return FormatTime(FileGetTime(imgFile, opt), "d MMMM yyyy ddd HH:mm:ss")
}

; File Properties dialog box
FileProperties() {
  global imgFile
  Run('Properties "' imgFile '"')
  WinWait("ahk_class #32770")
  WinSetAlwaysOnTop(, "A")
}

; Converts a numeric value into a string that represents
; the number in bytes, kilobytes, megabytes, or gigabytes,
; depending on the size.
FormatByteSize(int, flags := 0x2) {
  size := VarSetStrCapacity(&buf, 0x0104)
  DllCall("shlwapi\StrFormatByteSizeEx", "int64", int, "int", flags, "str", buf, "uint", size)
  return buf
}

; Function to move the window by dragging it
MoveWindow() {
  CoordMode("Mouse")  ; Switch to screen/absolute coordinates.
  MouseGetPos &msX, &msY, &win ; Get the initial mouse position and window handle.
  if !WinGetMinMax(win)  ; Only if the window isn't maximized
    SetTimer(WatchMouse, 10) ; Track the mouse as the user drags it.

  WatchMouse() {
    if !GetKeyState("LButton", "P") {  ; Mouse left button has been released, so drag is complete.
      SetTimer(, 0) ; Stop tracking the mouse.
      ShowImage() ; Show the image
      return
    }
    ; Otherwise, reposition the window to match the change in mouse coordinates
    ; caused by the user having dragged the mouse:
    CoordMode("Mouse")
    MouseGetPos(&mX, &mY)
    WinGetPos(&wX, &wY, , , win)
    SetWinDelay(-1)   ; Makes the below move faster/smoother.
    WinMove(wX + mX - msX, wY + mY - msY, , , win)
    msX := mX  ; Update for the next timer-call to this subroutine.
    msY := mY
  }
}

; Function to handle file drag-and-drop events
Gui_DropFiles(GuiObj, GuiCtrlObj, FileArray, X, Y) {
  global dropFile
  dropFile := FileArray[1] ; Get the dropped file
  OpenFile() ; Open the dropped file
}

; Keyboard shortcuts
Shortcuts(*) {
  ; Create arrays for keyboard and mouse shortcuts
  kbShortcuts := [
    lang["Shortcuts_keyboard"],
    "-------------------",
    lang["Shortcuts_kb_down"],
    lang["Shortcuts_kb_home"],
    lang["Shortcuts_kb_back"],
    lang["Shortcuts_kb_left"],
    lang["Shortcuts_kb_forward"],
    lang["Shortcuts_kb_right"],
    lang["Shortcuts_kb_end"],
    lang["Shortcuts_kb_plus"],
    lang["Shortcuts_kb_minus"],
    lang["Shortcuts_kb_zero"],
    lang["Shortcuts_kb_one"],
    lang["Shortcuts_kb_f1"],
    lang["Shortcuts_kb_f2"],
    lang["Shortcuts_kb_f3"],
    lang["Shortcuts_kb_f5"],
    lang["Shortcuts_kb_ctrl_o"],
    lang["Shortcuts_kb_ctrl_c"],
    lang["Shortcuts_kb_esc"],
    lang["Shortcuts_kb_alt_f4"]
  ]

  mouseShortcuts := [
    lang["Shortcuts_mouse"],
    "------",
    lang["Shortcuts_mouse_right"],
    lang["Shortcuts_mouse_wheel_up"],
    lang["Shortcuts_mouse_wheel_down"],
    lang["Shortcuts_mouse_4"],
    lang["Shortcuts_mouse_5"],
    lang["Shortcuts_mouse_left_dbl"],
    lang["Shortcuts_mouse_middle_dbl"]
  ]

  ; Join arrays with newlines
  for shortcut in kbShortcuts
    txt .= shortcut "`n"
  txt .= "`n"
  for shortcut in mouseShortcuts
    txt .= shortcut "`n"

  MsgBox(txt, lang["Shortcuts_title"], "Owner" g.Hwnd)
}

; Copy the image to the clipboard at its original size
CopyImageToClipboard() {
  global bitmap
  if !IsSet(bitmap) || !bitmap {
    MsgBox(lang["File_nofile"], , "Icon! 4096")
    return
  }
  ; Copy the image to the clipboard
  Gdip_SetBitmapToClipboard(bitmap)
}

; About dialog
About(*) {
  txt := A_ScriptName "`n"
  txt .= "©2025`n"
  txt .= "Mesut Akcan`n"
  txt .= "makcan@gmail.com`n"
  txt .= "`n"
  txt .= "akcansoft.blogspot.com`n"
  txt .= "mesutakcan.blogspot.com`n"
  txt .= "github.com/akcansoft`n"
  txt .= "youtube.com/mesutakcan"
  MsgBox(txt, lang["About_about"], "Owner" g.Hwnd)
}