; AS Image Viewer v1.0
; ====================
; This application is a minimalist image viewer that uses GDI+ for rendering,
; supports multiple image formats,
; and allows easy navigation and management through a simple GUI.

; 30/07/2024
; Mesut Akcan
; makcan@gmail.com
; akcansoft.blogspot.com
; mesutakcan.blogspot.com
; github.com/akcansoft
; youtube.com/mesutakcan

;Rev: 12

#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

; Load the GDI+ library
#Include "gdip_all.ahk"

; Start GDI+
if !pToken := Gdip_Startup() {
  MsgBox "Failed to start GDI+."
  ExitApp()
}
bitmap := 0
zoomFactor := 1
myGui := Gui("-Caption -Border +AlwaysOnTop")

; Create right-click menu
rcMenu := Menu()
rcMenu.Add("&Open", MenuOpenFile)
rcMenu.SetIcon("&Open", A_WinDir "\system32\imageres.dll", 195)
rcMenu.Add("&Close", GuiClose)
rcMenu.SetIcon("&Close", A_WinDir "\system32\imageres.dll", 94)
rcMenu.Add("&Refresh", ShowImage)
rcMenu.SetIcon("&Refresh", A_WinDir "\system32\shell32.dll", 147)
rcMenu.Add("Allways On &Top", toggleAOT)
rcMenu.Check("Allways On &Top")
rcMenu.Add()
rcMenu.Add("&About", About)
rcMenu.SetIcon("&About", A_WinDir "\system32\shell32.dll", 155)

; GUI events
myGui.OnEvent("Close", GuiClose)
myGui.OnEvent("Size", GuiSize)

MenuOpenFile() ; openfile & loadimage

#HotIf WinActive(myGui.Hwnd)
Right:: LoadNextImage() ; Right arrow key
Left:: LoadPrevImage()  ; Left arrow key
NumpadAdd:: ZoomImage(1)  ; Numpad + key
NumpadSub:: ZoomImage(-1)  ; Numpad - key
Numpad0:: ZoomImage(0)  ; Numpad 0 key
F5:: ShowImage() ; F5 key

#HotIf mouseIsOver(myGui.hwnd)
Down::
RButton:: rcMenu.Show() ; right-click
#HotIf

; Mouse drag function
OnMessage(0x84, WM_NCHITTEST)
WM_NCHITTEST(wParam, lParam, msg, hwnd) {
  static HTCAPTION := 2
  if (hwnd = myGui.Hwnd)
    return HTCAPTION
}

MenuOpenFile(*) {
  OpenFile(), LoadImage()
}

; Toggle Allways On Top
toggleAOT(*) {
  static guiAOT := true
  rcMenu.ToggleCheck("Allways On &Top")
  guiAOT := !guiAOT
  myGui.Opt(guiAOT ? "+AlwaysOnTop" : "-AlwaysOnTop")
}

OpenFile() {
  global
  local folder, extensions
  ; Select image file
  extensions := "*.jpg; *.jpeg; *.png; *.gif; *.bmp; *.tif; *.ico; *.webp; *.wmf"
  imgFile := FileSelect(, , "Select image file:", "Images (" extensions ")")
  if !imgFile {
    MsgBox "No file selected.", , "T3 Owner" myGui.Hwnd
    if !bitmap
      ExitApp()
    return
  }

  ; Get the folder name of the image file
  SplitPath imgFile, , &folder
  imageFiles := []
  Loop Files, folder "\*.*" {
    if A_LoopFileExt = ""
      continue
    if InStr(extensions, A_LoopFileExt, false)
      imageFiles.Push(A_LoopFileFullPath)
  }
  imgNo := getArrayValueIndex(imgFile)
}

; Show the image on the GUI
ShowImage(*) {
  global imgWidth, imgHeight, myGui
  hDC := DllCall("GetDC", "Ptr", myGui.Hwnd, "Ptr")
  G := Gdip_GraphicsFromHDC(hDC)
  ;Gdip_GraphicsClear(G, 0xFFF0F0F0)
  Gdip_DrawImage(G, bitmap, 0, 0, imgWidth, imgHeight)
  Gdip_DeleteGraphics(G)
  DllCall("ReleaseDC", "Ptr", myGui.Hwnd, "Ptr", hDC)
}

; Load the next image
LoadNextImage(*) {
  global
  imgNo := (imgNo >= imageFiles.Length) ? 1 : imgNo + 1
  LoadImage()
}

; Load the previous image
LoadPrevImage(*) {
  global
  imgNo := (imgNo <= 1) ? imageFiles.Length : imgNo - 1
  LoadImage()
}

; Image loading function
LoadImage() {
  global imgFile, imgWidth, imgHeight, bitmap, originalWidth, originalHeight, zoomFactor
  imgFile := imageFiles[imgNo]
  bitmap := Gdip_CreateBitmapFromFile(imgFile)
  if !bitmap {
    MsgBox "Failed to load image file: " imgFile, "Owner" myGui.Hwnd
    return
  }

  ; Get the image dimensions
  originalWidth := Gdip_GetImageWidth(bitmap)
  originalHeight := Gdip_GetImageHeight(bitmap)

  ; Adjust image dimensions to fit screen
  scrWidth := SysGet(78)
  scrHeight := SysGet(79)
  if (originalWidth > scrWidth or originalHeight > scrHeight) {
    zoomFactor := Min(scrWidth / originalWidth, scrHeight / originalHeight)
    imgWidth := Round(originalWidth * zoomFactor)
    imgHeight := Round(originalHeight * zoomFactor)
  }
  else {
    imgWidth := originalWidth
    imgHeight := originalHeight
    zoomFactor := 1
  }
  ShowGui()
  ShowImage()
}

; Zoom image function
ZoomImage(a) {
  global imgWidth, imgHeight, originalWidth, originalHeight, zoomFactor
  if a = 0
    zoomFactor := 1
  else {
    prevZoomFactor := zoomFactor
    zoomFactor := zoomFactor + (a / 10)
  }

  newWidth := Round(originalWidth * zoomFactor)
  newHeight := Round(originalHeight * zoomFactor)

  if (a = -1) and (newWidth < 10 or newHeight < 10) {
    zoomFactor := prevZoomFactor
    return
  }

  imgWidth := newWidth
  imgHeight := newHeight

  ; myGui.Show("w0")
  ; myGui.Show("w" imgWidth " h" imgHeight "Center")
  ShowGui()
  ShowImage()
}

ShowGui() {
  global
  myGui.Show("w0")
  myGui.Show("w" imgWidth " h" imgHeight "Center")
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

; Clean up GDI+ resources when myGui is closed
GuiClose(*) {
  global
  Gdip_DisposeImage(bitmap)
  Gdip_Shutdown(pToken)
  ExitApp()
}

About(*) {
  MsgBox("
(
AS Image Viewer v1.0
©2024
Mesut Akcan
makcan@gmail.com

akcansoft.blogspot.com
mesutakcan.blogspot.com
github.com/akcansoft
youtube.com/mesutakcan
)", "About", "Owner" myGui.Hwnd)
}
