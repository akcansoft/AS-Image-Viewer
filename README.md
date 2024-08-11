# AS Image Viewer

AS Image Viewer is a minimalist image viewer application. This application uses GDI+ for rendering images and supports multiple image formats. It allows for easy navigation and management through a simple GUI.

## Features

- Renders images using GDI+
- Supports multiple image formats: JPG, JPEG, PNG, GIF, BMP, TIF, ICO, WEBP, WMF
- Easy navigation: Next/previous images with right/left arrow keys
- Zoom in and out: Using Numpad + and - keys
- Refresh image with F5 key
- Simple and user-friendly interface
- Always on top option
- Quick access via right-click menu

## Requirements

Windows x64

## Installation
Download exe file to your Windows PC and run. No installation required.

## Source Code
The source code for this program is available in the src folder. To use the program source code, you'll need to have AutoHotkey v2 installed on your system. You can run the script directly using the AutoHotkey interpreter. Alternatively, you can compile the script into an executable file for easier distribution.

This application uses the library file **gdip_all.ahk**

### Gdip_All Library Source files:
* https://github.com/tariqporter/Gdip original Gdip.ahk library
* https://github.com/mmikeww/AHKv2-Gdip
* https://github.com/buliasz/AHKv2-Gdip forked

## Usage

1. **Right-Click Menu**: Right-click or `Down` arrow to access the menu and use options
2. **Open Image**: Select the "Open" option from the right-click menu.
3. **Navigation**: Navigation by keyboard shortcuts or menu
5. **Zoom In and Out**: Use the `+` and `-` keys on the Numpad to zoom in and out.
6. Use the `Numpad0` key to reset to the original size, Use the `Numpad1` key to fit to screen
7. **Refresh**: Press the `F5` key to refresh the image. 

## Shortcuts
### Keyboard Shortcuts:
`Down Arrow` : Menu

`Home`: First Image

`Browser Back`: Previous image

`Left Arrow`: Previous image

`Browser Forward`: Next image

`Right Arrow` : Next image

`End` : Last Image

`Numpad +` : Zoom in

`Numpad -` : Zoom out

`Numpad 0` : Original size

`Numpad 1` : Fit to screen

`F1` : Image file info

`F2` : File properties

`F3` : Show file in folder

`F5` : Refresh

`Ctrl+O` : Open image file

`Esc` : Close file info

`Alt+F4` : Exit App

### Mouse:
**Right click** : Menu

**Mouse wheel up**: Zoom in

**Mouse wheel down**: Zoom out

**4. mouse button**: Previous image

**5. mouse button**: Next image

**Left button double click**: Original size

**Middle button double click**: Fit to screen

## History
- v1.0: 30/07/2024 First version
- v1.1: 11/08/2024
  - Code improvements
  - Added new shortcuts for navigation
  - Zoom features have been improved

## Contact

- **Author**: Mesut Akcan
- **Email**: makcan@gmail.com
- **Blog**: [akcansoft.blogspot.com](http://akcansoft.blogspot.com) and [mesutakcan.blogspot.com](http://mesutakcan.blogspot.com)
- **GitHub**: [akcansoft](http://github.com/akcansoft)
- **YouTube**: [Mesut Akcan](http://youtube.com/mesutakcan)

## License

This project is licensed under the GPL 3.0 License. For more information, see the `LICENSE` file.

## Contributing
Contributions are welcome! If you'd like to add features, fix bugs, or improve the code, feel free to open a pull request.
