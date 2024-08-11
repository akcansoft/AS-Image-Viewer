; AS Image Viewer v1.1
; ====================
; This application is a minimalist image viewer that uses GDI+ for rendering,
; supports multiple image formats,
; and allows easy navigation and management through a simple GUI.

; 11/08/2024
; Mesut Akcan
; makcan@gmail.com
; akcansoft.blogspot.com
; mesutakcan.blogspot.com
; github.com/akcansoft
; youtube.com/mesutakcan
; R29

#Requires AutoHotkey v2.0
#SingleInstance Off
#NoTrayIcon
#Include "gdip_all.ahk" ; Load the GDI+ library

; Start GDI+
if !pToken := Gdip_Startup() {
  MsgBox("Failed to start GDI+", , "Icon! 4096")
  ExitApp()
}

bitmap := 0
scrAspectRatio := A_ScreenWidth / A_ScreenHeight
DblClickTime := DllCall("GetDoubleClickTime", "UInt")

;Create Gui
g := Gui("+OwnDialogs -Caption -Border +AlwaysOnTop -DPIScale")

; GUI events
g.OnEvent("Close", GuiClose)
g.OnEvent("Size", GuiSize)

; Right click menu items
mnu := Map()
mnu["open"] := "&Open`tCtrl+O"
mnu["exit"] := "&Exit`tAlt+F4"
mnu["first"] := "First I&mage`tHome"
mnu["prev"] := "&Previous Image`tLeft"
mnu["next"] := "&Next Image`tRight"
mnu["last"] := "Last Ima&ge`tEnd"
mnu["zoomin"] := "Zoom &In(+10%)`tNumpad +"
mnu["zoomout"] := "Zoom O&ut(-10%)`tNumpad -"
mnu["fit"] := "&Fit to Screen`tNumpad 1"
mnu["osize"] := "Original &Size(100%)`tNumpad 0"
mnu["refresh"] := "&Refresh`tF5"
mnu["fileinfo"] := "File Info`tF1"
mnu["fileprop"] := "Fi&le Properties`tF2"
mnu["fileinfolder"] := "S&how File In Folder`tF3"
mnu["aot"] := "Always On &Top"
mnu["border"] := "&Window Border"
mnu["shortcuts"] := "Short&cuts"
mnu["about"] := "&About"

; Create right-click menu
imageres := A_WinDir "\system32\imageres.dll"
shell32 := A_WinDir "\system32\shell32.dll"
rcMenu := Menu()
rcMenu.Add(mnu["open"], menuHandler)
rcMenu.SetIcon(mnu["open"], imageres, 195)
rcMenu.Add(mnu["exit"], menuHandler)
rcMenu.SetIcon(mnu["exit"], imageres, 94)
rcMenu.Add()
rcMenu.Add(mnu["first"], menuHandler)
rcMenu.Add(mnu["prev"], menuHandler)
rcMenu.Add(mnu["next"], menuHandler)
rcMenu.Add(mnu["last"], menuHandler)
rcMenu.Add()
rcMenu.Add(mnu["zoomin"], menuHandler)
rcMenu.Add(mnu["zoomout"], menuHandler)
rcMenu.Add(mnu["fit"], menuHandler)
rcMenu.Add(mnu["osize"], menuHandler)
rcMenu.Add()
rcMenu.Add(mnu["refresh"], menuHandler)
rcMenu.SetIcon(mnu["refresh"], shell32, 147)
rcMenu.Add()
rcMenu.Add(mnu["fileinfo"], menuHandler)
rcMenu.SetIcon(mnu["fileinfo"], shell32, 222)
rcMenu.Add(mnu["fileprop"], menuHandler)
rcMenu.Add(mnu["fileinfolder"], menuHandler)
rcMenu.Add()
rcMenu.Add(mnu["aot"], menuHandler)
rcMenu.Check(mnu["aot"])
rcMenu.Add(mnu["border"], menuHandler)
rcMenu.Add()
rcMenu.Add(mnu["shortcuts"], menuHandler)
rcMenu.Add(mnu["about"], menuHandler)
rcMenu.SetIcon(mnu["about"], shell32, 155)

OpenFile() ; openfile & loadimage

#HotIf WinActive(g.Hwnd)
Home:: LoadFirstImage()
Browser_Back::
Left:: LoadPrevImage()  ; Left arrow key
Browser_Forward::
Right:: LoadNextImage() ; Right arrow key
End:: LoadLastImage()
NumpadAdd:: ZoomImage(1)  ; Numpad + key
NumpadSub:: ZoomImage(-1) ; Numpad - key
Numpad0:: ZoomImage(0)    ; Numpad 0 key. Original size
Numpad1:: ZoomImage(2)    ; Numpad 2 key. Fit to screen

F1:: FileInfo()
F2:: FileProperties()
F3:: ShowFileInFolder()
F5:: ShowImage() ; Refresh
^o:: OpenFile() ; Ctrl+o
Esc:: ToolTip()

#HotIf mouseIsOver(g.Hwnd)
Down:: ; Down arrow key
RButton:: rcMenu.Show() ; right-click
WheelUp:: ZoomImage(1) ; mouse wheel up
WheelDown:: ZoomImage(-1) ; mouse wheel down
XButton1:: LoadPrevImage() ; 4th mouse button
XButton2:: LoadNextImage() ; 5th mouse button
~LButton::
~MButton::
{
  if (ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < DblClickTime)
  {
    if (A_ThisHotkey = "~LButton")
      ZoomImage(0) ; Original size
    else if (A_ThisHotkey = "~MButton")
      ZoomImage(2) ; Fit to screen
  }
}
#HotIf

OnMessage(0x84, WM_NCHITTEST) ; Mouse drag function
OnMessage(0x0232, WM_EXITSIZEMOVE)
WM_NCHITTEST(wParam, lParam, msg, hwnd) {
  static HTCAPTION := 2
  if (hwnd = g.Hwnd)
    return HTCAPTION
}
WM_EXITSIZEMOVE(wParam, lParam, msg, hwnd) {
  ShowImage()
}

menuHandler(Item, *) {
  switch Item {
    case mnu["open"]: OpenFile()
    case mnu["exit"]: GuiClose()
    case mnu["first"]: LoadFirstImage()
    case mnu["prev"]: LoadPrevImage()
    case mnu["next"]: LoadNextImage()
    case mnu["last"]: LoadLastImage()
    case mnu["zoomin"]: ZoomImage(1)
    case mnu["zoomout"]: ZoomImage(-1)
    case mnu["fit"]: ZoomImage(2)
    case mnu["osize"]: ZoomImage(0)
    case mnu["refresh"]: ShowImage()
    case mnu["fileinfo"]: FileInfo()
    case mnu["fileprop"]: FileProperties()
    case mnu["fileinfolder"]: ShowFileInFolder()
    case mnu["aot"]: toggleAOT()
    case mnu["border"]: toggleBorder()
    case mnu["shortcuts"]: Shortcuts()
    case mnu["about"]: About()
  }
}

OpenFile() {
  global
  local folder, extensions
  ; Select image file
  extensions := "*.jpg; *.jpeg; *.png; *.gif; *.bmp; *.tif; *.ico; *.webp; *.wmf"
  g.Opt("+OwnDialogs")
  imgFile := FileSelect(, , "Select image file:", "Images (" extensions ")")
  if !imgFile {
    MsgBox("No file selected.", , "Icon! 4096")
    if !bitmap
      ExitApp()
    return
  }

  SplitPath imgFile, , &folder
  imageFiles := []
  Loop Files, folder "\*.*" {
    if A_LoopFileExt = ""
      continue
    if InStr(extensions, A_LoopFileExt, false)
      imageFiles.Push(A_LoopFileFullPath)
  }
  imgNo := getArrayValueIndex(imgFile)
  LoadImage()
}

; Image loading function
LoadImage() {
  global
  imgFile := imageFiles[imgNo]
  bitmap := Gdip_CreateBitmapFromFile(imgFile)
  if !bitmap {
    MsgBox "Failed to load image file: " imgFile, , "Icon! 4096"
    return
  }

  ; Get image dimensions
  originalWidth := Gdip_GetImageWidth(bitmap)
  originalHeight := Gdip_GetImageHeight(bitmap)

  if (originalWidth > A_ScreenWidth or originalHeight > A_ScreenHeight) {
    ZoomImage(2) ; Fit
    return
  }
  else {
    imgWidth := originalWidth
    imgHeight := originalHeight
    zoomFactor := 1
  }
  ShowGui()
}

; Load the first image
LoadFirstImage(*) {
  global imgNo := 1
  LoadImage()
}

; Load the first image
LoadLastImage(*) {
  global imgNo := imageFiles.Length
  LoadImage()
}

; Load the next image
LoadNextImage(*) {
  global imgNo := (imgNo >= imageFiles.Length) ? 1 : imgNo + 1
  LoadImage()
}

; Load the previous image
LoadPrevImage(*) {
  global imgNo := (imgNo <= 1) ? imageFiles.Length : imgNo - 1
  LoadImage()
}

; Show the image on the GUI
ShowImage(*) {
  global imgWidth, imgHeight, g
  ToolTip() ; Close tooltip
  hDC := DllCall("GetDC", "Ptr", g.Hwnd, "Ptr")
  GG := Gdip_GraphicsFromHDC(hDC)
  ;Gdip_GraphicsClear(GG, 0xFFF0F0F0)
  Gdip_DrawImage(GG, bitmap, 0, 0, imgWidth, imgHeight)
  Gdip_DeleteGraphics(GG)
  DllCall("ReleaseDC", "Ptr", g.Hwnd, "Ptr", hDC)
}

; Zoom image function
ZoomImage(a) {
  global
  local newWidth, newHeight
  switch a {
    case 0: ; Original size
      zoomFactor := 1
    case 1, -1: ; Zoom in/out
      if a = -1
        local prevZoomFactor := zoomFactor
      zoomFactor := zoomFactor + (a / 10)
    case 2: ; Fit to screen
      ; Adjust image dimensions to fit screen
      local imgAspectRatio := originalWidth / originalHeight
      if (imgAspectRatio > scrAspectRatio) {
        newWidth := A_ScreenWidth
        newHeight := Round(A_ScreenWidth / imgAspectRatio)
      } else {
        newHeight := A_ScreenHeight
        newWidth := Round(A_ScreenHeight * imgAspectRatio)
      }
      zoomFactor := newWidth / originalWidth
  }
  newWidth := Round(originalWidth * zoomFactor)
  newHeight := Round(originalHeight * zoomFactor)
  if (a = -1) and (newWidth < 10 or newHeight < 10) {
    zoomFactor := prevZoomFactor
    return
  }
  imgWidth := newWidth
  imgHeight := newHeight
  ShowGui()
}

; Toggle Allways On Top
toggleAOT(*) {
  static guiAOT := true
  rcMenu.ToggleCheck(mnu["aot"])
  g.Opt(((guiAOT := !guiAOT) ? "+" : "-") . "AlwaysOnTop")
}

; Toggle Window Border
toggleBorder(*) {
  static guiBorder := false
  rcMenu.ToggleCheck(mnu["border"])
  g.Opt(((guiBorder := !guiBorder) ? "+" : "-") . "Border")
  g.Show()
}

ShowGui() {
  g.Show("w0")
  g.Show("w" imgWidth " h" imgHeight " xCenter yCenter")
}

; Function to get the index of a value in the imageFiles array
getArrayValueIndex(val) {
  global
  Loop imageFiles.Length {
    if (imageFiles[A_Index] == val)
      return A_Index
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
  global
  Gdip_DisposeImage(bitmap)
  Gdip_Shutdown(pToken)
  ExitApp()
}

ShowFileInFolder() {
  Run('explorer.exe /select,"' imgFile '"')
  Sleep(1000)
  WinWait("ahk_class CabinetWClass")
  WinSetAlwaysOnTop(, "A")
}

; Image file info
FileInfo() {
  SplitPath(imgFile, &file, &dir)
  mfd := FileDT("M") ; Modification
  cfd := FileDT("C") ; Creation
  afd := FileDT("A") ; Last Access
  fsize := FileGetSize(imgFile)
  fs := FormatByteSize(fsize) " (" RegExReplace(fsize, "(\d)(?=(\d{3})+(?!\d))", "$1.") " bytes)"
  m := "Folder: " dir "`n"
  m .= "File: " file "`n"
  m .= "Modification time: " mfd "`n"
  m .= "Creation time: " cfd "`n"
  m .= "Last Access: " afd "`n"
  m .= "Original Size: " originalWidth "x" originalHeight "`n"
  m .= "Display Size: " imgWidth "x" imgHeight "`n"
  m .= "File Size: " fs
  ToolTip(m, 5, 5)
}

; Formatted File Date & Time
FileDT(opt) {
  return FormatTime(FileGetTime(imgFile, opt), "d MMMM yyyy ddd HH:mm:ss")
}

FileProperties() {
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

About(*) {
  MsgBox("
(
AS Image Viewer v1.1
©2024
Mesut Akcan
makcan@gmail.com

akcansoft.blogspot.com
mesutakcan.blogspot.com
github.com/akcansoft
youtube.com/mesutakcan
)", "About", "Owner" g.Hwnd)
}
