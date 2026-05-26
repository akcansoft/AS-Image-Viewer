/*
======================
AS Image Viewer
v1.7
26/05/2026
======================
Mesut Akcan
makcan@gmail.com
mesutakcan.blogspot.com
github.com/mesutakcan
youtube.com/mesutakcan
*/

;@Ahk2Exe-SetMainIcon app_icon.ico
;@Ahk2Exe-ExeName AS Image Viewer.exe
;@Ahk2Exe-SetName AS Image Viewer
;@Ahk2Exe-Bin C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe
;@Ahk2Exe-SetDescription A simple and fast image viewer
;@Ahk2Exe-SetFileVersion 1.7
;@Ahk2Exe-SetCompanyName akcanSoft
;@Ahk2Exe-SetCopyright ©2026 Mesut Akcan

#Requires AutoHotkey v2.0
#SingleInstance Off
#NoTrayIcon

#Include "gdip_all.ahk"
#Include "langSupport.ahk"

A_ScriptName := "AS Image Viewer v1.7"

LoadLanguage()

if !pToken := Gdip_Startup() {
	MsgBox(lang["File_load_failed"], , "Icon! 4096")
	ExitApp()
}

extensions := "*.jpg; *.jpeg; *.png; *.gif; *.bmp; *.tif; *.ico; *.webp; *.wmf"
dropFile := ""
DblClickTime := DllCall("GetDoubleClickTime", "UInt")
imageFiles := []
imgFile := ""
currentFolder := ""
lastIndex := 0
imgNo := 0
isClipboardImage := false
settingsFile := A_ScriptDir "\settings.ini"
centerImage := true
windowX := 0
windowY := 0
windowPositionLoaded := false

g := Gui("+OwnDialogs -Caption -Border +AlwaysOnTop -DPIScale")
g.OnEvent("Close", GuiClose)
g.OnEvent("Size", GuiSize)
g.OnEvent("DropFiles", Gui_DropFiles)

CreateMenu()
LoadSettings()
OpenFile()

#HotIf WinActive(g.Hwnd)
Home:: LoadImageByMode("first")
Browser_Back::
Left:: LoadImageByMode("prev")
Browser_Forward::
Right:: LoadImageByMode("next")
End:: LoadImageByMode("last")
NumpadAdd:: ZoomImage(1)
NumpadSub:: ZoomImage(-1)
Numpad0:: ZoomImage(0)
Numpad1:: ZoomImage(2)
Delete:: DeleteCurrentImage()

F1:: FileInfo()
F2:: FileProperties()
F3:: ShowFileInFolder()
F5:: ShowImage()
^o:: OpenFile()
^c:: CopyImageToClipboard()
^v:: PasteImageFromClipboard()
Esc:: ToolTip()

#HotIf mouseIsOver(g.Hwnd)
Down::
RButton:: rcMenu.Show()
WheelUp:: ZoomImage(1)
WheelDown:: ZoomImage(-1)
XButton1:: LoadImageByMode("prev")
XButton2:: LoadImageByMode("next")
~MButton::
~LButton:: HandleMouseClick()
#HotIf

HandleMouseClick() {
	if (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < DblClickTime) {
		switch A_ThisHotkey {
			case "~MButton":
				ZoomImage(2)
			case "~LButton":
				ZoomImage(0)
		}
		return
	}
	if (A_ThisHotkey = "~LButton") {
		MoveWindow()
	}
}

CreateMenu() {
	global rcMenu, mnuTxt

	imageres := A_WinDir "\system32\imageres.dll"
	shell32 := A_WinDir "\system32\shell32.dll"
	rcMenu := Menu()

	mnuTxt := {
		open: lang["Menu_open"] . "`tCtrl+O",
		exit: lang["Menu_exit"] . "`tAlt+F4",
		first: lang["Menu_first"] . "`tHome",
		prev: lang["Menu_prev"] . "`tLeft",
		next: lang["Menu_next"] . "`tRight",
		last: lang["Menu_last"] . "`tEnd",
		delete: lang["Menu_delete"] . "`tDel",
		zoomin: lang["Menu_zoomin"] . "`tNumpad +",
		zoomout: lang["Menu_zoomout"] . "`tNumpad -",
		fit: lang["Menu_fit"] . "`tNumpad 1",
		osize: lang["Menu_osize"] . "`tNumpad 0",
		refresh: lang["Menu_refresh"] . "`tF5",
		copy: lang["Menu_copy"] . "`tCtrl+C",
		paste: lang["Menu_paste"] . "`tCtrl+V",
		fileinfo: lang["Menu_fileinfo"] . "`tF1",
		fileprop: lang["Menu_fileprop"] . "`tF2",
		fileinfolder: lang["Menu_fileinfolder"] . "`tF3",
		aot: lang["Menu_aot"],
		border: lang["Menu_border"],
		center: lang["Menu_center"],
		shortcuts: lang["Menu_shortcuts"],
		about: lang["Menu_about"]
	}

	menuItems := [{ text: mnuTxt.open, iconFile: imageres, iconNo: 195 }, { text: mnuTxt.exit, iconFile: imageres, iconNo: 94 }, { separator: true }, { text: mnuTxt.first }, { text: mnuTxt.prev }, { text: mnuTxt.next, iconFile: shell32, iconNo: 298 }, { text: mnuTxt.last }, { separator: true }, { text: mnuTxt.delete, iconFile: shell32, iconNo: 63 }, { separator: true }, { text: mnuTxt.zoomin }, { text: mnuTxt.zoomout }, { text: mnuTxt.fit, iconFile: shell32, iconNo: 16 }, { text: mnuTxt.osize }, { separator: true }, { text: mnuTxt.refresh, iconFile: imageres, iconNo: 230 }, { text: mnuTxt.copy, iconFile: shell32, iconNo: 135 }, { text: mnuTxt.paste, iconFile: shell32, iconNo: 261 }, { separator: true }, { text: mnuTxt.fileinfo, iconFile: shell32, iconNo: 222 }, { text: mnuTxt.fileprop, iconFile: shell32, iconNo: 283 }, { text: mnuTxt.fileinfolder, iconFile: shell32, iconNo: 267 }, { separator: true }, { text: mnuTxt.aot, check: true }, { text: mnuTxt.border }, { text: mnuTxt.center, check: true }, { separator: true }, { text: mnuTxt.shortcuts, iconFile: shell32, iconNo: 30 }, { text: mnuTxt.about, iconFile: shell32, iconNo: 155 }
	]

	for index, item in menuItems {
		if (item.HasOwnProp("separator")) {
			rcMenu.Add()
			continue
		}
		rcMenu.Add(item.text, menuHandler)
		if (item.HasOwnProp("iconFile") && item.HasOwnProp("iconNo")) {
			rcMenu.SetIcon(item.text, item.iconFile, item.iconNo)
		}
		if (item.HasOwnProp("check") && item.check) {
			rcMenu.Check(item.text)
		}
	}
}

menuHandler(item, *) {
	global mnuTxt
	switch item {
		case mnuTxt.open: OpenFile()
		case mnuTxt.exit: GuiClose()
		case mnuTxt.first: LoadImageByMode("first")
		case mnuTxt.prev: LoadImageByMode("prev")
		case mnuTxt.next: LoadImageByMode("next")
		case mnuTxt.last: LoadImageByMode("last")
		case mnuTxt.delete: DeleteCurrentImage()
		case mnuTxt.zoomin: ZoomImage(1)
		case mnuTxt.zoomout: ZoomImage(-1)
		case mnuTxt.fit: ZoomImage(2)
		case mnuTxt.osize: ZoomImage(0)
		case mnuTxt.refresh: ShowImage()
		case mnuTxt.copy: CopyImageToClipboard()
		case mnuTxt.paste: PasteImageFromClipboard()
		case mnuTxt.fileinfo: FileInfo()
		case mnuTxt.fileprop: FileProperties()
		case mnuTxt.fileinfolder: ShowFileInFolder()
		case mnuTxt.aot: toggleAOT()
		case mnuTxt.border: toggleBorder()
		case mnuTxt.center: toggleCenterImage()
		case mnuTxt.shortcuts: Shortcuts()
		case mnuTxt.about: About()
	}
}

LoadSettings() {
	global settingsFile, rcMenu, mnuTxt, g, currentFolder, centerImage, windowX, windowY, windowPositionLoaded

	; Always on Top setting
	aotSetting := IniRead(settingsFile, "Settings", "AlwaysOnTop", "1")
	if (aotSetting = "0") {
		WinSetAlwaysOnTop(0, g)
		rcMenu.Uncheck(mnuTxt.aot)
	}

	; Window Border setting
	borderSetting := IniRead(settingsFile, "Settings", "WindowBorder", "0")
	if (borderSetting = "1") {
		WinSetStyle("+0x800000", g)
		rcMenu.Check(mnuTxt.border)
	}

	; Center image setting
	centerImage := IniRead(settingsFile, "Settings", "CenterImage", "1") != "0"
	if !centerImage
		rcMenu.Uncheck(mnuTxt.center)

	; Last window position
	savedWindowX := IniRead(settingsFile, "Settings", "WindowX", "")
	savedWindowY := IniRead(settingsFile, "Settings", "WindowY", "")
	if (RegExMatch(savedWindowX, "^-?\d+$") && RegExMatch(savedWindowY, "^-?\d+$")) {
		windowX := Integer(savedWindowX)
		windowY := Integer(savedWindowY)
		windowPositionLoaded := true
	}

	; Last folder setting
	currentFolder := IniRead(settingsFile, "Settings", "LastFolder", A_MyDocuments)
	if !DirExist(currentFolder)
		currentFolder := A_MyDocuments
}

SaveSettings() {
	global settingsFile, currentFolder, g, centerImage

	; Save Always on Top setting
	try
		IniWrite((WinGetExStyle(g) & 0x8) ? "1" : "0", settingsFile, "Settings", "AlwaysOnTop")
	catch
		IniWrite("1", settingsFile, "Settings", "AlwaysOnTop")

	; Save Window Border setting
	try
		IniWrite((WinGetStyle(g) & 0x800000) ? "1" : "0", settingsFile, "Settings", "WindowBorder")
	catch
		IniWrite("0", settingsFile, "Settings", "WindowBorder")

	; Save center image setting
	IniWrite(centerImage ? "1" : "0", settingsFile, "Settings", "CenterImage")

	; Save last window position
	try {
		WinGetPos(&x, &y, , , g)
		IniWrite(x, settingsFile, "Settings", "WindowX")
		IniWrite(y, settingsFile, "Settings", "WindowY")
	}

	; Save last folder
	if (currentFolder != "" && DirExist(currentFolder))
		IniWrite(currentFolder, settingsFile, "Settings", "LastFolder")
}

OpenFile() {
	global bitmap, extensions
	iFile := GetImageFilePath()
	if !iFile {
		if !IsSet(bitmap) {
			MsgBox(lang["File_nofile"], , "Icon! 4096")
			ExitApp()
		}
		return
	}

	SplitPath iFile, , , &ext
	if !ext || !InStr(extensions, ext) || !FileExist(iFile) {
		MsgBox(lang["File_invalid_file"] ":`n" iFile, , "Icon! 4096")
		return
	}
	LoadImageFromFile(iFile)
}

GetImageFilePath() {
	static argsUsed := false
	global dropFile, extensions, currentFolder
	if !argsUsed && A_Args.Length > 0 {
		argsUsed := true
		return A_Args[1]
	}
	if dropFile {
		dFile := dropFile
		dropFile := ""
		return dFile
	}
	g.Opt("+OwnDialogs")

	startFolder := (currentFolder != "" && DirExist(currentFolder)) ? currentFolder : ""

	return FileSelect(, startFolder, lang["File_select_image_file"], "Images (" extensions ")")
}

LoadImageFromFile(lFile) {
	global imageFiles, currentFolder, lastIndex, imgNo, isClipboardImage
	isClipboardImage := false
	SplitPath lFile, , &folder
	if (folder != currentFolder || imageFiles.Length = 0) {
		imageFiles := GetImageFilesInFolder(folder)
		currentFolder := folder
		lastIndex := 0
	}

	imgNo := getArrayValueIndex(lFile)
	imgFile := lFile
	LoadImage(imgNo)
}

GetImageFilesInFolder(folder) {
	global extensions
	files := []
	Loop Files, folder "\*.*" {
		if InStr(extensions, A_LoopFileExt)
			files.Push(A_LoopFileFullPath)
	}
	return files
}

LoadImage(index) {
	global
	if (index < 1 || index > imageFiles.Length) {
		MsgBox(lang["File_invalid_file"], , "Icon! 4096")
		return
	}

	imgFile := imageFiles[index]

	if (index = lastIndex) {
		return
	}

	; Try loading image from memory stream to avoid locking the file on disk
	newBitmap := CreateBitmapFromFileMemory(imgFile)
	if !IsValidBitmap(newBitmap)
		newBitmap := Gdip_CreateBitmapFromFile(imgFile)
	if !IsValidBitmap(newBitmap) {
		MsgBox(lang["Error_load_failed_msg"] " " imgFile, , "Icon! 4096")
		return
	}

	; Clone the bitmap into a new GDI+ bitmap to ensure no underlying file handles remain
	try {
		cloned := CloneBitmap(newBitmap)
		if cloned {
			SafeDisposeBitmap(&newBitmap)
			newBitmap := cloned
		}
	} catch {
		; If cloning fails, keep original bitmap
	}

	SafeDisposeBitmap(&bitmap)
	bitmap := newBitmap
	lastIndex := index

	originalWidth := Gdip_GetImageWidth(bitmap)
	originalHeight := Gdip_GetImageHeight(bitmap)

	if (originalWidth > A_ScreenWidth || originalHeight > A_ScreenHeight) {
		ZoomImage(2)
		return
	}
	else {
		imgWidth := originalWidth
		imgHeight := originalHeight
		zoomFactor := 1
	}
	ShowGui()
}

CreateBitmapFromFileMemory(sFile) {
	; Create a GDI+ bitmap from a file's raw bytes to avoid keeping the file handle open
	if !FileExist(sFile)
		return 0

	; Open file for read
	hFile := DllCall("Kernel32\CreateFileW", "WStr", sFile, "UInt", 0x80000000, "UInt", 3, "Ptr", 0, "UInt", 3, "UInt", 0x80, "Ptr", 0, "Ptr")
	if (hFile = -1 || hFile = 0)
		return 0

	if !DllCall("Kernel32\GetFileSizeEx", "Ptr", hFile, "Int64*", &size := 0) {
		DllCall("Kernel32\CloseHandle", "Ptr", hFile)
		return 0
	}
	if (size = 0) {
		DllCall("Kernel32\CloseHandle", "Ptr", hFile)
		return 0
	}

	; Allocate global memory and read file contents into it
	hMem := DllCall("GlobalAlloc", "UInt", 2, "Ptr", size, "Ptr")
	pData := DllCall("GlobalLock", "Ptr", hMem, "Ptr")
	if (!hMem || !pData) {
		if pData
			DllCall("GlobalUnlock", "Ptr", hMem)
		if hMem
			DllCall("GlobalFree", "Ptr", hMem)
		DllCall("Kernel32\CloseHandle", "Ptr", hFile)
		return 0
	}
	if !DllCall("Kernel32\ReadFile", "Ptr", hFile, "Ptr", pData, "UInt", size, "UInt*", &bytesRead := 0, "Ptr", 0) {
		DllCall("GlobalUnlock", "Ptr", hMem)
		DllCall("GlobalFree", "Ptr", hMem)
		DllCall("Kernel32\CloseHandle", "Ptr", hFile)
		return 0
	}
	if (bytesRead != size) {
		DllCall("GlobalUnlock", "Ptr", hMem)
		DllCall("GlobalFree", "Ptr", hMem)
		DllCall("Kernel32\CloseHandle", "Ptr", hFile)
		return 0
	}
	DllCall("GlobalUnlock", "Ptr", hMem)
	DllCall("Kernel32\CloseHandle", "Ptr", hFile)

	; Create an IStream on the HGLOBAL and make a bitmap from it
	if !(DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hMem, "Int", 1, "Ptr*", &pStream := 0)) {
		DllCall("GlobalFree", "Ptr", hMem)
		return 0
	}

	status := DllCall("gdiplus\GdipCreateBitmapFromStreamICM", "UPtr", pStream, "Ptr*", &pBitmap := 0)
	ObjRelease(pStream)

	return (status = 0 && pBitmap) ? pBitmap : 0
}

IsValidBitmap(pBitmap) {
	if !IsSet(pBitmap) || pBitmap <= 0
		return false
	try {
		DllCall("gdiplus\GdipGetImageWidth", "UPtr", pBitmap, "UInt*", &width := 0)
		DllCall("gdiplus\GdipGetImageHeight", "UPtr", pBitmap, "UInt*", &height := 0)
		return width > 0 && height > 0
	} catch {
		return false
	}
}

SafeDisposeBitmap(&pBitmap) {
	if IsSet(pBitmap) && pBitmap > 0 {
		try Gdip_DisposeImage(pBitmap)
		pBitmap := 0
	}
}

CloneBitmap(pSrcBitmap) {
	if !IsValidBitmap(pSrcBitmap)
		return 0
	w := Gdip_GetImageWidth(pSrcBitmap)
	h := Gdip_GetImageHeight(pSrcBitmap)
	if (w <= 0 || h <= 0)
		return 0

	pNew := Gdip_CreateBitmap(w, h)
	if !pNew
		return 0

	G := Gdip_GraphicsFromImage(pNew)
	if !G {
		Gdip_DisposeImage(pNew)
		return 0
	}

	; Draw source into new bitmap
	Gdip_DrawImage(G, pSrcBitmap, 0, 0, w, h)
	Gdip_DeleteGraphics(G)

	return pNew
}

LoadImageByMode(mode) {
	global imgNo, imageFiles, isClipboardImage

	if isClipboardImage {
		isClipboardImage := false
	}

	switch mode {
		case "first": imgNo := 1
		case "last": imgNo := imageFiles.Length
		case "next":
			imgNo++
			if (imgNo > imageFiles.Length)
				imgNo := 1
		case "prev":
			imgNo--
			if (imgNo < 1)
				imgNo := imageFiles.Length
	}
	LoadImage(imgNo)
}

ShowImage(*) {
	global
	if !IsSet(bitmap) || !IsValidBitmap(bitmap)
		return
	ToolTip()
	local hDC := DllCall("GetDC", "Ptr", g.Hwnd, "Ptr")
	local GG := Gdip_GraphicsFromHDC(hDC)
	Gdip_DrawImage(GG, bitmap, 0, 0, imgWidth, imgHeight)
	Gdip_DeleteGraphics(GG)
	DllCall("ReleaseDC", "Ptr", g.Hwnd, "Ptr", hDC)
}

ZoomImage(zoomMode) {
	global
	static prevZoomFactor := 1

	switch zoomMode {
		case 0: zoomFactor := 1
		case 1: zoomFactor += 0.1
		case -1: zoomFactor -= 0.1
		case 2:
			local mNo := GetActiveMonitor()
			local mWidth := A_ScreenWidth
			local mHeight := A_ScreenHeight
			try {
				MonitorGet(mNo, &mLeft, &mTop, &mRight, &mBottom)
				mWidth := mRight - mLeft
				mHeight := mBottom - mTop
			}
			local imgAspectRatio := originalWidth / originalHeight
			if (imgAspectRatio > (mWidth / mHeight)) {
				zoomFactor := mWidth / originalWidth
			} else {
				zoomFactor := mHeight / originalHeight
			}
	}

	if (zoomFactor < 0.1)
		zoomFactor := prevZoomFactor
	else
		prevZoomFactor := zoomFactor

	imgWidth := Round(originalWidth * zoomFactor)
	imgHeight := Round(originalHeight * zoomFactor)
	ShowGui()
}

toggleAOT(*) {
	global rcMenu, mnuTxt, g
	rcMenu.ToggleCheck(mnuTxt.aot)
	WinSetAlwaysOnTop(-1, g)
}

toggleBorder(*) {
	global rcMenu, mnuTxt, g
	rcMenu.ToggleCheck(mnuTxt.border)
	WinSetStyle("^0x800000", g)
	g.Show()
}

toggleCenterImage(*) {
	global centerImage, rcMenu, mnuTxt
	centerImage := !centerImage
	rcMenu.ToggleCheck(mnuTxt.center)
	if centerImage
		ShowGui()
}

ShowGui() {
	global imgWidth, imgHeight, g, centerImage, windowX, windowY, windowPositionLoaded
	local sizeTxt := "w" imgWidth " h" imgHeight

	if centerImage {
		g.Show("w0")
		g.Show(sizeTxt " Center")
		return
	}

	if DllCall("IsWindowVisible", "Ptr", g.Hwnd) {
		WinGetPos(&x, &y, , , g)
	} else {
		x := windowPositionLoaded ? windowX : 0
		y := windowPositionLoaded ? windowY : 0
		if !IsWindowPositionOnScreen(x, y) {
			x := 0
			y := 0
		}
	}

	local posTxt := " x" x " y" y
	g.Show("w0" posTxt)
	g.Show(sizeTxt posTxt)
}

IsWindowPositionOnScreen(x, y) {
	try {
		Loop MonitorGetCount() {
			MonitorGet(A_Index, &left, &top, &right, &bottom)
			if (x >= left && x < right && y >= top && y < bottom)
				return true
		}
	} catch {
		return (x >= 0 && x < A_ScreenWidth && y >= 0 && y < A_ScreenHeight)
	}
	return false
}

GetActiveMonitor() {
	global g
	if !DllCall("IsWindowVisible", "Ptr", g.Hwnd)
		return 1
	WinGetPos(&wx, &wy, &ww, &wh, g)
	centerX := wx + ww / 2
	centerY := wy + wh / 2
	try {
		Loop MonitorGetCount() {
			MonitorGet(A_Index, &left, &top, &right, &bottom)
			if (centerX >= left && centerX < right && centerY >= top && centerY < bottom)
				return A_Index
		}
	}
	return 1
}

getArrayValueIndex(val) {
	global imageFiles
	Loop imageFiles.Length {
		if (imageFiles[A_Index] = val)
			return A_Index
	}
}

mouseIsOver(windowIdentifier) {
	MouseGetPos(, , &winHwnd)
	return (winHwnd = windowIdentifier)
}

GuiSize(gui, minMax, width, height) {
	if (minMax = 0) {
		ShowImage()
	}
}

GuiClose(*) {
	global bitmap, pToken
	SaveSettings()
	SafeDisposeBitmap(&bitmap)
	Gdip_Shutdown(pToken)
	ExitApp()
}

ShowFileInFolder() {
	global imgFile, isClipboardImage

	if isClipboardImage {
		MsgBox(lang["File_clipboard_image"], , "Icon! 4096")
		return
	}

	Run('explorer.exe /select,"' imgFile '"')
	WinWait("ahk_class CabinetWClass")
	WinActivate("ahk_class CabinetWClass")
	WinSetAlwaysOnTop(, "A")
}

DeleteCurrentImage() {
	global imgFile, isClipboardImage, imageFiles, imgNo, bitmap, lastIndex, g

	; Image pasted from clipboard cannot be deleted
	if isClipboardImage {
		MsgBox(lang["File_clipboard_image"], , "Icon! 4096")
		return
	}

	; Deletion confirmation
	result := MsgBox(lang["File_delete_confirm"] "`n`n" imgFile,
		lang["File_delete_title"], "YesNo Icon! 4096")

	if (result != "Yes")
		return

	fileToDelete := imgFile
	; Hide GUI and release bitmap
	g.Hide()
	SafeDisposeBitmap(&bitmap)
	Sleep(100)  ; Short wait for GDI+

	; Send file to recycle bin
	try {
		FileRecycle(fileToDelete)

		; Deletion successful - remove from list and move to next image
		imageFiles.RemoveAt(imgNo)
		lastIndex := 0

		if (imageFiles.Length > 0) {
			if (imgNo > imageFiles.Length)
				imgNo := imageFiles.Length
			; If the current image was the last one, load the new last image
			; Otherwise, load the image at the current index (which is now the next image)
			LoadImage(imgNo)
		} else {
			GuiClose()
		}

	} catch as err {
		; Deletion failed - show error message
		errorMsg := lang["File_delete_error_msg"] "`n" fileToDelete "`n`n"
		errorMsg .= lang["File_delete_error_reasons"] "`n"
		errorMsg .= lang["File_delete_error_in_use"] "`n"
		errorMsg .= lang["File_delete_error_readonly"] "`n"
		errorMsg .= lang["File_delete_error_no_permission"] "`n`n"
		errorMsg .= lang["File_delete_error_label"] " " err.Message

		MsgBox(errorMsg, lang["File_delete_error_title"], "Icon! 16")

		; Reload image in case of error
		LoadImage(imgNo)
	}
}

FileInfo() {
	global imgFile, originalWidth, originalHeight, imgWidth, imgHeight, isClipboardImage

	if isClipboardImage {
		m := lang["FileInfo_source"] ": " lang["FileInfo_clipboard"] "`n"
		m .= lang["FileInfo_orig_size"] ": " originalWidth "x" originalHeight "`n"
		m .= lang["FileInfo_disp_size"] ": " imgWidth "x" imgHeight
	}
	else {
		SplitPath(imgFile, &file, &dir)
		mfd := FileDT("M")
		cfd := FileDT("C")
		afd := FileDT("A")
		try {
			fsize := FileGetSize(imgFile)
			fs := FormatByteSize(fsize) " (" RegExReplace(fsize, "(\d)(?=(\d{3})+(?!\d))", "$1.") " bytes)"
		} catch {
			fs := "N/A"
		}
		m := lang["FileInfo_folder"] ": " dir "`n"
		m .= lang["FileInfo_file"] ": " file "`n"
		m .= lang["FileInfo_mod_time"] ": " mfd "`n"
		m .= lang["FileInfo_create_time"] ": " cfd "`n"
		m .= lang["FileInfo_access_time"] ": " afd "`n"
		m .= lang["FileInfo_orig_size"] ": " originalWidth "x" originalHeight "`n"
		m .= lang["FileInfo_disp_size"] ": " imgWidth "x" imgHeight "`n"
		m .= lang["FileInfo_file_size"] ": " fs
	}

	CoordMode("ToolTip", "Screen")
	WinGetPos(&x, &y, , , g)
	tX := Max(0, x)
	tY := Max(0, y)
	ToolTip(m, tX + 5, tY + 5)
}

FileDT(opt) {
	global imgFile
	try {
		return FormatTime(FileGetTime(imgFile, opt), "d MMMM yyyy ddd HH:mm:ss")
	} catch {
		return "N/A"
	}
}

FileProperties() {
	global imgFile, isClipboardImage

	if isClipboardImage {
		MsgBox(lang["File_clipboard_image"], , "Icon! 4096")
		return
	}

	Run('Properties "' imgFile '"')
	WinWait("ahk_class #32770")
	WinSetAlwaysOnTop(, "A")
}

FormatByteSize(int, flags := 0x2) {
	size := VarSetStrCapacity(&buf, 0x0104)
	DllCall("shlwapi\StrFormatByteSizeEx", "int64", int, "int", flags, "str", buf, "uint", size)
	return buf
}

MoveWindow() {
	CoordMode("Mouse")
	MouseGetPos &msX, &msY, &win
	if !WinGetMinMax(win)
		SetTimer(WatchMouse, 10)

	WatchMouse() {
		if !GetKeyState("LButton", "P") {
			SetTimer(, 0)
			ShowImage()
			return
		}
		CoordMode("Mouse")
		MouseGetPos(&mX, &mY)
		WinGetPos(&wX, &wY, , , win)
		SetWinDelay(-1)
		WinMove(wX + mX - msX, wY + mY - msY, , , win)
		msX := mX
		msY := mY
	}
}

Gui_DropFiles(GuiObj, GuiCtrlObj, FileArray, X, Y) {
	global dropFile
	dropFile := FileArray[1]
	OpenFile()
}

PasteImageFromClipboard() {
	global bitmap, originalWidth, originalHeight, imgWidth, imgHeight
	global zoomFactor, isClipboardImage, imgFile, lastIndex

	pBitmap := Gdip_CreateBitmapFromClipboard()

	if !IsValidBitmap(pBitmap) {
		MsgBox(lang["File_no_clipboard_image"], , "Icon! 4096")
		return
	}

	SafeDisposeBitmap(&bitmap)
	bitmap := pBitmap
	isClipboardImage := true
	imgFile := lang["FileInfo_clipboard"]
	lastIndex := 0

	originalWidth := Gdip_GetImageWidth(bitmap)
	originalHeight := Gdip_GetImageHeight(bitmap)

	if (originalWidth > A_ScreenWidth || originalHeight > A_ScreenHeight) {
		ZoomImage(2)
	}
	else {
		imgWidth := originalWidth
		imgHeight := originalHeight
		zoomFactor := 1
		ShowGui()
	}
}

Shortcuts(*) {
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
		lang["Shortcuts_kb_delete"],
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
		lang["Shortcuts_kb_ctrl_v"],
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

	for shortcut in kbShortcuts
		txt .= shortcut "`n"
	txt .= "`n"
	for shortcut in mouseShortcuts
		txt .= shortcut "`n"

	MsgBox(txt, lang["Shortcuts_title"], "Owner" g.Hwnd)
}

CopyImageToClipboard() {
	global bitmap
	if !IsSet(bitmap) || !bitmap {
		MsgBox(lang["File_nofile"], , "Icon! 4096")
		return
	}
	Gdip_SetBitmapToClipboard(bitmap)
}

About(*) {
	txt := A_ScriptName "`n"
	txt .= "©2026`n"
	txt .= "Mesut Akcan`n"
	txt .= "makcan@gmail.com`n"
	txt .= "`n"
	txt .= "mesutakcan.blogspot.com`n"
	txt .= "github.com/mesutakcan`n"
	txt .= "youtube.com/mesutakcan"
	MsgBox(txt, lang["About_about"], "Owner" g.Hwnd)
}
