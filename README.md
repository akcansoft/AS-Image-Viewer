# AS Image Viewer v1.3.1

AS Image Viewer is a minimalist image viewer application that uses GDI+ for rendering. It supports multiple image formats and allows easy navigation and management through a simple GUI interface.

![Screenshot v1.1](https://github.com/akcansoft/AS-Image-Viewer/blob/main/src/ss-v1.1.jpg "Screenshot v1.1")

## Features

- Image rendering with GDI+
- Supported formats: JPG, JPEG, PNG, GIF, BMP, TIF, ICO, WEBP, WMF
- Easy navigation: Previous/next image with left/right arrow keys
- Zoom in and out: Using Numpad + and - keys
- Refresh image with F5 key
- Simple and user-friendly interface
- Always on top option
- Quick access via right-click menu
- Drag and drop support
- Command line support for opening images
- File information display
- Window border toggle option

## Requirements

- Windows x64
- [AutoHotkey v2](https://www.autohotkey.com/) (for running source code)

## Installation

Download the [AS Image Viewer.exe](https://github.com/akcansoft/AS-Image-Viewer/blob/main/AS%20Image%20Viewer.exe) file to your Windows PC and run it. No installation required.

## Source Code

The source code for this program is available in the [src](https://github.com/akcansoft/AS-Image-Viewer/tree/main/src) folder. To use the program source code, you'll need to have AutoHotkey v2 installed on your system. You can run the script directly using the AutoHotkey interpreter. Alternatively, you can compile the script into an executable file for easier distribution.

This application uses the library file [Gdip_All.ahk](https://github.com/buliasz/AHKv2-Gdip/blob/master/Gdip_All.ahk)

## Opening Image File

- **Command Line**: Launch the application with an image file path as a parameter to open it directly.
- **Drag and Drop to Exe File**: Drag an image file onto the AS Image Viewer exe file to open it immediately.

### Opening File While Running

- **Menu**: Right-click to open the menu and select "Open" to browse for an image file.
- **Keyboard Shortcut**: Press `Ctrl+O` to open the file selection dialog.
- **Drag and Drop**: Drag image files directly onto the application window to open them.

## Usage

1. **Right-Click Menu**: Right-click or press the `Down` arrow key to access the menu and use options
2. **Open Image**: Select "Open" from the right-click menu or drag and drop an image onto the window
3. **Navigation**: Navigate using keyboard shortcuts or menu
4. **Zoom In and Out**: Use the `+` and `-` keys on the Numpad to zoom in and out
5. Use `Numpad0` to return to original size, `Numpad1` to fit to screen
6. **Refresh**: Press the `F5` key to refresh the image

## Shortcuts

### Keyboard Shortcuts

`Down Arrow` : Menu\
`Home`: First Image\
`Browser Back`: Previous image\
`Left Arrow`: Previous image\
`Browser Forward`: Next image\
`Right Arrow`: Next image\
`End`: Last Image\
`Numpad +`: Zoom in\
`Numpad -`: Zoom out\
`Numpad 0`: Original size\
`Numpad 1`: Fit to screen\
`F1`: Image file info\
`F2`: File properties\
`F3`: Show file in folder\
`F5`: Refresh\
`Ctrl+O`: Open image file\
`Esc`: Close file info\
`Alt+F4`: Exit App

### Mouse:

**Right click**: Menu\
**Mouse wheel up**: Zoom in\
**Mouse wheel down**: Zoom out\
**4th mouse button**: Previous image\
**5th mouse button**: Next image\
**Left button double click**: Original size\
**Middle button double click**: Fit to screen

## History

- v1.0: 30/07/2024 First version
- v1.1: 11/08/2024
  - Code improvements
  - Added new shortcuts for navigation
  - Improved zoom features
- v1.2: 18/08/2024
  - Code improvements
- v1.3: 25/03/2025
  - Code improvements
  - Added command line support for opening images
  - Added drag and drop support
- v1.3.1: 09/04/2025
  - Minor issues fixed

## Contact

- **Author**: Mesut Akcan
- **Email**: <makcan@gmail.com>
- **Blog**: [akcansoft.blogspot.com](http://akcansoft.blogspot.com) and [mesutakcan.blogspot.com](http://mesutakcan.blogspot.com)
- **GitHub**: [akcansoft](http://github.com/akcansoft)
- **YouTube**: [Mesut Akcan](http://youtube.com/mesutakcan)

## License

This project is licensed under the GPL 3.0 License. For more information, see the `LICENSE` file.

## Contributing

Contributions are welcome! If you'd like to add features, fix bugs, or improve the code, feel free to open a pull request.
