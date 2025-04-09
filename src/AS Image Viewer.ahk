; AS Image Viewer v1.3.1
; ======================
; This application is a minimalist image viewer that uses GDI+ for rendering,
; supports multiple image formats,
; and allows easy navigation and management through a simple GUI.

; 09/04/2025
; Mesut Akcan
; makcan@gmail.com
; akcansoft.blogspot.com
; mesutakcan.blogspot.com
; github.com/akcansoft
; youtube.com/mesutakcan
; R42

; What's new in v1.3:
; - Code improvements
; - Added the ability to open an image file from the command line
; - Added the ability to open an image file by dragging and dropping it onto the GUI

; What's new in v1.3.1:
; - Minor issues fixed

; TODO:
; - Rotate image based on EXIF orientation
; - Rotate image
; - Slideshow
; - Zoom to mouse cursor
; - Save settings

#Requires AutoHotkey v2.0
#SingleInstance Off
#NoTrayIcon
#Include "gdip_all.ahk" ; Load the GDI+ library

; Start GDI+
if !pToken := Gdip_Startup() {
  MsgBox("Failed to start GDI+", , "Icon! 4096")
  ExitApp()
}

A_ScriptName := "AS Image Viewer v1.3.1"
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
Esc:: ToolTip() ; Close tooltip

#HotIf mouseIsOver(g.Hwnd) ; Mouse is over the GUI window
Down:: ; Down arrow key
RButton:: rcMenu.Show() ; right-click
WheelUp:: ZoomImage(1) ; mouse wheel up
WheelDown:: ZoomImage(-1) ; mouse wheel down
XButton1:: LoadImageByMode("prev") ; 4th mouse button
XButton2:: LoadImageByMode("next") ; 5th mouse button
~MButton:: ; Middle mouse button
{
  ; if middle button was double clicked
  if (ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < DblClickTime)
    ZoomImage(2) ; Fit image to screen
}
~LButton:: ; Left button
{
  ; if left button was double clicked
  if (ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < DblClickTime)
    ZoomImage(0) ; Original size
  else
    MoveWindow() ; Move window
}
#HotIf

; Create right-click menu
CreateMenu(){
  global rcMenu, mnuTxt

  imageres := A_WinDir "\system32\imageres.dll" ; icon file
  shell32 := A_WinDir "\system32\shell32.dll" ; icon file
  rcMenu := Menu() ; Right click menu

  ; Right click menu items
  mnuTxt := {
    open: "&Open`tCtrl+O",
    exit: "&Exit`tAlt+F4",
    first: "First I&mage`tHome",
    prev: "&Previous Image`tLeft",
    next: "&Next Image`tRight",
    last: "Last Ima&ge`tEnd",
    zoomin: "Zoom &In(+10%)`tNumpad +",
    zoomout: "Zoom O&ut(-10%)`tNumpad -",
    fit: "&Fit to Screen`tNumpad 1",
    osize: "Original &Size(100%)`tNumpad 0",
    refresh: "&Refresh`tF5",
    fileinfo: "File Info`tF1",
    fileprop: "Fi&le Properties`tF2",
    fileinfolder: "S&how File In Folder`tF3",
    aot: "Always On &Top",
    border: "&Window Border",
    shortcuts: "Short&cuts",
    about: "&About"
  }

  ; Menu items array with text, icon file, and icon number
  menuItems := [
    { text: mnuTxt.open, iconFile: imageres, iconNo: 195 }, ; Open
    { text: mnuTxt.exit, iconFile: imageres, iconNo: 94 }, ; Exit
    { separator: true }, ; Separator
    { text: mnuTxt.first }, ; First image
    { text: mnuTxt.prev }, ; Previous image
    { text: mnuTxt.next }, ; Next image
    { text: mnuTxt.last }, ; Last image
    { separator: true }, ; Separator
    { text: mnuTxt.zoomin }, ; Zoom in
    { text: mnuTxt.zoomout }, ; Zoom out
    { text: mnuTxt.fit }, ; Fit to screen
    { text: mnuTxt.osize }, ; Original size
    { separator: true }, ; Separator
    { text: mnuTxt.refresh, iconFile: shell32, iconNo: 147 }, ; Refresh
    { separator: true }, ; Separator
    { text: mnuTxt.fileinfo, iconFile: shell32, iconNo: 222 }, ; File info
    { text: mnuTxt.fileprop }, ; File properties
    { text: mnuTxt.fileinfolder }, ; Show file in folder
    { separator: true }, ; Separator
    { text: mnuTxt.aot, check: true }, ; Always on top
    { text: mnuTxt.border }, ; Window border
    { separator: true }, ; Separator
    { text: mnuTxt.shortcuts }, ; Shortcuts
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
    MsgBox("No file selected.", , "Icon! 4096")
    if !IsSet(bitmap) 
      ExitApp()
    return
  }
  
  SplitPath iFile, , , &ext ; Split the file path into extension
  ; Validate the image file
  if !ext || !InStr(extensions, ext) || !FileExist(iFile) {
    MsgBox("Invalid or unsupported file:`n" iFile, , "Icon! 4096")
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
  return FileSelect(, , "Select image file:", "Images (" extensions ")")
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
  m := "Folder: " dir "`n" ; Tooltip message
  m .= "File: " file "`n"
  m .= "Modification time: " mfd "`n"
  m .= "Creation time: " cfd "`n"
  m .= "Last Access: " afd "`n"
  m .= "Original Size: " originalWidth "x" originalHeight "`n"
  m .= "Display Size: " imgWidth "x" imgHeight "`n"
  m .= "File Size: " fs
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
  MsgBox("
(
Keyboard Shortcuts:
-------------------
Down Arrow : Menu
Home: First Image
Browser Back: Previous image
Left Arrow: Previous image
Browser Forward: Next image
Right Arrow: Next image
End: Last Image
Numpad + : Zoom in
Numpad - : Zoom out
Numpad 0 : Original size
Numpad 1 : Fit to screen

F1 : Image file info
F2: File properties
F3: Show file in folder
F5 : Refresh
Ctrl+O: Open image file
Esc: Close file info
Alt+F4: Exit App

Mouse:
------
Right click : Menu
Mouse wheel up: Zoom in
Mouse wheel down: Zoom out
4. mouse button: Previous image
5. mouse button: Next image
Left button double click: Original size
Middle button double click: Fit to screen
)", "Shortcuts", "Owner" g.Hwnd)
}

; About dialog
About(*) {
  MsgBox(Format("
(
{1}
©2025
Mesut Akcan
makcan@gmail.com

akcansoft.blogspot.com
mesutakcan.blogspot.com
github.com/akcansoft
youtube.com/mesutakcan
)", A_ScriptName), "About", "Owner" g.Hwnd)
}
