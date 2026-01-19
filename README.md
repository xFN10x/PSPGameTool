# PSPGameTool 
> [!IMPORTANT]
> This repository has been archived. I am not going to update this anymore, or pay attension to this repository.
> **However, I am working a new and improved version of this tool. https://github.com/xFN10x/PSPTools**

![logo](https://github.com/xFN10x/PSPGameTool/blob/main/images/logo.png?raw=true)
Tools for Adding/Editing Games/Saves
(Changelog at bottom)
## Features 
- Simple Save Viewer/Manager
- Extract ISO files from ZIPs
- Move ISOs without opening file explorer


### How to use PSXTOPSP
In this app, there is a button for launching PSXTOPSP. To use that button, you have to do this:
1. Download [PSXTOPSP](https://psp.brewology.com/downloads/get.php?id=9697)
2. Extract it and move the psx2psp_v.1.4.2 folder to where you downloaded [PSPGameTool](https://github.com/xFN10x/PSPGameTool/)
3. Rename the folder to "psxtopsp"
   ![image](https://github.com/xFN10x/PSPGameTool/assets/89083781/cfddff40-176c-42c6-b389-9792d4264de6)
5. Rename PSX2PSP.exe to app.exe
   ![Image2](https://github.com/xFN10x/PSPGameTool/blob/main/images/readmeimages/image2.PNG?raw=true)
    
7. Now that button should work.
## How To Install (Source Code)
1. Download [LuaRT](https://luart.org/index.html#section_download "LuaRT")
2. Download the [Source Code](https://github.com/xFN10x/PSPGameTool/archive/refs/heads/main.zip "Source Code")
3. Download the latest [VC Redist](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170#visual-studio-2015-2017-2019-and-2022)
4. Extract Both LuaRT and the Source code
5. Drag main.wlua to wrtc.exe
6. Make sure Windows Desktop is selected, and make sure "Dynamic" is also selected.
7. (Optional) Select icon.ico in the images folder
8. Click "Generate Executable"
9. Rename lua54(64bit).dll or 32bit to lua54.dll
9. Double click on main.exe, and now you are running it!

## Changelog v1.02-beta
1. FTP support 50% done
2. (Bug Fix) Selecting custom folders no longer needs a restart.
3. #### PSV SUPPORT! Select the pspemu folder in custom folder selection to use!
