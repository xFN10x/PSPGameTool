ui = require("ui")
sys = require("sys")
com = require("compression")
ini = require("ini")
settings = sys.File("settings.ini")
window = ui.Window("PSP Game Tools: Main Menu","fixed",504,212)
window:loadicon(sys.currentdir.."/images/icon.ico")
pspimage = ui.Picture(window,sys.currentdir.."/images/psp.png")
pspimage:center()
ps1button = ui.Button(window,"PS1 Game Tool",131,23,116,33)
ps1button:tofront()
isoadderbutton = ui.Button(window,"ISO Adder",269,23,116,33)
isoadderbutton:show()
savelistbutton = ui.Button(window,"Savedata List",131,77,116,33)
savelistbutton:show()
gamelistbutton = ui.Button(window,"Game List",131,131,116,33)
gamelistbutton:show()
reselectdrivebutton = ui.Button(window,"Reselect Drive",300,185,110,22)
reselectdrivebutton:show()
window:show() 
gamedatabase = sys.File(sys.currentdir.."/data/gamedatabase.txt")
ldl = ini.decode(settings:open("read","utf8"):read()).sets.drive
function reselectdrivebutton.onClick()
  ui.msg("Reselecting Drive")
  reselecingdrive = true
  local driveinini = ini.decode(settings:open("read","utf8"):read())
  driveinini["sets"]["drive"] = "none"
  ini.save(settings,driveinini)
  drivewindow = ui.Window("PSP Game Tools: Drive Selection","single",265,100)
  drivewindow:loadicon(sys.currentdir.."/images/icon.ico")
  window:showmodal(drivewindow)
  customdirbutton = ui.Button(drivewindow,"...",92,9,25,25)
  driveselect = ui.Combobox(drivewindow,false,{"D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"},9,9,80)
  driveshowbutton = ui.Button(drivewindow,"Show Connected Drives",120,9,140)
  driveclosebutton = ui.Button(drivewindow,"Done",0,40,265,60)
  function driveshowbutton.onClick()
    sys.cmd("explorer ")
    --file:\\
  end
  function customdirbutton.onClick()
    local dir = ui.dirdialog("Open Directory with PSP and ISO folders")
    if not dir == false then
      print(dir.fullpath)
      if sys.Directory(dir.fullpath.."/".. "PSP").exists == true and sys.Directory(dir.fullpath.."/".. "ISO").exists == true then
        ui.msg("Selected PSP at "..dir.fullpath.."/")
        local driveinini = ini.decode(settings:open("read","utf8"):read())
        driveinini["sets"]["drive"] = dir.fullpath.."/"
        ini.save(settings,driveinini)
        drivewindow:hide()
        print(ldl)
        print(ldl.."PSP/GAME")
      else
        ui.error("Still not a psp...")
      end
      drivewindow:tofront()
    end
  end
  function driveclosebutton.onClick()
    if driveselect.selected == nil then
      ui.error("Please Select a letter")
    else
      if sys.Directory(driveselect.selected.text..":/".. "PSP").exists == true and sys.Directory(driveselect.selected.text..":/".. "ISO").exists == true then
        ui.msg("Selected PSP at "..driveselect.selected.text..":/")
        local driveinini = ini.decode(settings:open("read","utf8"):read())
        driveinini["sets"]["drive"] = driveselect.selected.text..":/"
        ini.save(settings,driveinini)
        drivewindow:hide()
      else
        ui.error("Still not a psp...")
      end
    drivewindow:tofront()
    end
  end 
  function drivewindow.onClose()
    if not reselecingdrive then
      if ui.confirm("The only program you can use without a drive selected, is PSXTOPSP, would you like to open it?") == "yes" then
        sys.cmd(sys.currentdir.."/psxtopsp/app.exe")
        return false
      else
        if ui.confirm("Would you like to exit?") == "yes" then
          window:hide()
        else
          return false
        end
      end
    end
  end
end
if ldl == "none" or sys.Directory(ldl.."PSP").exists == false then
  if ldl == "none" then
    ui.msg("Select Drive Letter", "First Time Setup")
  else
    ui.error("The selected drive doesn't have the PSP/ISO folder, or is not a PSP")
  end
  drivewindow = ui.Window("PSP Game Tools: Drive Selection","single",265,100)
  drivewindow:loadicon(sys.currentdir.."/images/icon.ico")
  window:showmodal(drivewindow)
  customdirbutton = ui.Button(drivewindow,"...",92,9,25,25)
  driveselect = ui.Combobox(drivewindow,false,{"D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"},9,9,80)
  driveshowbutton = ui.Button(drivewindow,"Show Connected Drives",120,9,140)
  driveclosebutton = ui.Button(drivewindow,"Done",0,40,265,60)
  function driveshowbutton.onClick()
    sys.cmd("explorer file:\\")
  end
  function customdirbutton.onClick()
    local dir = ui.dirdialog("Open Directory with PSP and ISO folders")
    if not dir == false then
      print(dir.fullpath)
      if sys.Directory(dir.fullpath.."/".. "PSP").exists == true and sys.Directory(dir.fullpath.."/".. "ISO").exists == true then
        ui.msg("Selected PSP at "..dir.fullpath.."/")
        local driveinini = ini.decode(settings:open("read","utf8"):read())
        driveinini["sets"]["drive"] = dir.fullpath.."/"
        ini.save(settings,driveinini)
        drivewindow:hide()
        print(ldl)
        print(ldl.."PSP/GAME")
      else
        ui.error("Still not a psp...")
      end
      drivewindow:tofront()
    end
  end
  function driveclosebutton.onClick()
    if driveselect.selected == nil then
      ui.error("Please Select a letter")
    else
      if sys.Directory(driveselect.selected.text..":/".. "PSP").exists == true and sys.Directory(driveselect.selected.text..":/".. "ISO").exists == true then
        ui.msg("Selected PSP at "..driveselect.selected.text..":/")
        local driveinini = ini.decode(settings:open("read","utf8"):read())
        driveinini["sets"]["drive"] = driveselect.selected.text..":/"
        ini.save(settings,driveinini)
        drivewindow:hide()
        print(ldl)
        print(ldl.."PSP/GAME")
      else
        ui.error("Still not a psp...")
      end
    drivewindow:tofront()
    end
  end 
  function drivewindow.onClose()
    if ui.confirm("The only program you can use without a drive selected, is PSXTOPSP, would you like to open it?") == "yes" then
      sys.cmd(sys.currentdir.."/psxtopsp/app.exe")
      return false
    else
      if ui.confirm("Would you like to exit?") == "yes" then
        window:hide()
      else
        return false
      end
    end
  end
else
  ui.msg("Selected PSP at "..ldl)
end
ldl = ini.decode(settings:open("read","utf8"):read()).sets.drive
function ps1button.onClick()
  if ui.confirm("This will open PSXTOPSP, Do you wish to continue?","Open Other App") == "yes" then
    print(sys.cmd(sys.currentdir.."/psxtopsp/app.exe",false,true))
  end
end
function isoadderbutton.onClick()
  ui.msg("You can add ISO or ZIP files with ISOs in them! (7z support coming soon!)")
  local file = ui.opendialog("Open ISO or ZIP with ISO",false,"ISO Archives(*.iso,*.ISO)|*.iso|ZIP Archives|*.zip")
  print(file.extension)
  if file.extension == ".iso" or file.extension == ".ISO" then
    local copy = ui.confirm('Do you wish to copy the file?')
    if copy == "cancel" then
      return false
    end
    local progress = ui.Progressbar(window,0,200,504,20)
    progress:show()
    progress.toback(pspimage)
    progress:advance(1)
    if copy == "yes" then
      local existingfile = sys.File(ldl.."ISO/"..file.name)
      if existingfile.exists then
        ui.msg("File "..ldl.."ISO/"..file.name.." already exists.\nReplacing the file.")
       if existingfile:remove() == false then
          ui.error("Failed to remove existing file.")
          progress:hide()
       else
         progress:advance(10)
       end
      end
      progress:advance(1)
      print(ldl.."ISO/"..file.name)
      sleep(1000)
      local copyedfile = file:copy(ldl.."ISO/"..file.name)
      
      progress:advance(99999)
      sleep(1000)
      if copyedfile == nil then
        ui.error("Can't Move File")
        progress:hide()
      else
        sleep(1000)
        ui.msg("Moved File to "..copyedfile.fullpath)
        progress:hide()
      end
    else
      local existingfile = sys.File(ldl.."ISO/"..file.name)
      if existingfile.exists then
        ui.msg("File "..ldl.."ISO/"..file.name.." already exists.\nReplacing the file.")
       if existingfile:remove() == false then
          ui.error("Failed to remove existing file.")
          progress:hide()
       else
         progress:advance(10)
       end
      end
      progress:advance(1)
      if file:move(ldl.."ISO/"..file.name) then
        progress:advance(199999999999999)
        sleep(1000)
        ui.msg("Moved File to "..ldl.."ISO/"..file.name)
        progress:hide()
      else
        ui.error("Couldn't move file.")
        progress:hide()
      end
    end
  else
    ui.msg("Sadly, LuaRT does not support 7z files, so you can not use them.")
    local tempdir = sys.tempdir("pgt")
    local zip = com.Zip(file,"read")
    local progress = ui.Progressbar(window,0,200,504,20)
    progress:show()
    progress.toback(pspimage)
    progress:advance(1)
    sleep(1000)
    ui.msg("Extracting ZIPS does take a while, so dont think the app crashed or anything!")
    print(tempdir.fullpath)
    if zip:extractall(tempdir) == false then
      ui.error("Extracting failed with error: "..zip.error)
      progress:hide()
      tempdir:removeall()
      return false
    end
    progress:advance(50)
    for entry in each(tempdir) do
      print(entry.name)
      if entry.extension == ".iso" then
        progress:advance(10)
        sleep(2000)
        local existingfile = sys.File(ldl.."ISO/"..entry.name)
        if existingfile.exists then
          ui.msg("File "..ldl.."ISO/"..entry.name.." already exists.\nReplacing the file.")
          if existingfile:remove() == false then
            ui.error("Failed to remove existing file.")
            progress:hide()
       else
         progress:advance(10)
       end
      end
        if entry:move(ldl.."ISO/"..entry.name) then
          sleep(4000)
          ui.msg("Extracted "..entry.name.." to "..ldl.."ISO/"..entry.name)
          progress:advance(59999999999999990)
          progress:hide()
          tempdir:removeall()
        else
          ui.error("Failed to move ISO")
          progress:advance(59999999999999990)
          progress:hide()
          tempdir:removeall()
        end
      end
    end
  end
end

function savelistbutton.onClick()
  local list = { }
  for entry in each(sys.Directory(ldl.."PSP/SAVEDATA")) do
    list[#list+1] = entry.name
  end
  print(ldl)
  ui.msg("You can look at the saves on your PSP!")
  local listwindow = ui.Window("PSP Game Tools: Save List","fixed",500,300)
  window:showmodal(listwindow)
  local isolist = ui.List(listwindow,list,0,0,150,300)
  gameimage = ui.Picture(listwindow,sys.currentdir.."/images/noneselected.png",160,50,288,160)
  gameimage:show()
  gamedes = ui.Label(listwindow,"No Save Selected",160,210,260,90)
  local gametitle = ui.Label(listwindow,"No Save Selected",160,10,1000000,20)
  local savetitle = ui.Label(listwindow,"No Save Selected",160,30)
  gametitle.textalign = "left"
  gametitle.fgcolor = 0xc0c0c0
  savetitle.textalign = "left"
  gamedes.textalign = "left"
  local deletebutton = ui.Button(listwindow,"Delete Save",420,270,70)
  deletebutton.enabled = false
  function deletebutton.onClick()
    item = isolist.selected
    if ui.confirm("Are you sure you want to delete this save?") == "yes" then
      if sys.Directory(ldl.."PSP/SAVEDATA/"..item.text).exists then
        sys.Directory(ldl.."PSP/SAVEDATA/"..item.text):removeall()
        item:remove()
      else
        sys.File(ldl.."ISO/"..item.text):remove()
        item:remove()
      end
    end
  end
  function isolist:onSelect(item)
    if sys.Directory(ldl.."PSP/SAVEDATA/"..item.text).exists then
      gameimage:hide()
      gameimage:load(ldl.."PSP/SAVEDATA/"..item.text.."/ICON0.PNG")
      gameimage.width = 288
      gameimage.height = 160
      gameimage:show()
      local des = string.sub(sys.File(ldl.."PSP/SAVEDATA/"..item.text.."/PARAM.SFO"):open("read"):read():encode(),273)
      local title = string.sub(sys.File(ldl.."PSP/SAVEDATA/"..item.text.."/PARAM.SFO"):open("read"):read():encode(),4657 )
      gametitle.text = "Unknown Game"
      gamedes.text = des
      savetitle.text = title 
      --ui.msg(des)
      deletebutton.enabled = true
      for line in gamedatabase:open("read").lines do
        if string.sub(line,0,9) == string.sub(item.text,0,9) then
          gametitle.text = string.sub(line,11)
        end
      end
    else
      gameimage:load(sys.currentdir.."/images/isoselected.png")
      gameimage.width = 288
      gameimage.height = 160
      gametitle.text = item.text
    end
  end
end
function gamelistbutton.onClick()
  local gamelistwindow = ui.Window("PSP Game Tools: Game List","fixed",520,300)
  window:showmodal(gamelistwindow)
  local openbutton = ui.Button(gamelistwindow,"Open Game",250,150)
  local delbutton = ui.Button(gamelistwindow,"Delete Game",360,150)
  local copybutton = ui.Button(gamelistwindow,"Copy Game",305,180)
  local gametitle = ui.Label(gamelistwindow,"No Game Selected",210,120,300,40)
  openbutton.enabled = false
  delbutton.enabled = false
  copybutton.enabled = false

  gametitle.fontsize = 15
  local list = { }
  for entry in each(sys.Directory(ldl.."PSP/GAME")) do
    list[#list+1] = entry.name
  end
  for entry in each(sys.Directory(ldl.."ISO")) do
    list[#list+1] = entry.name
  end
  gamelist = ui.List(gamelistwindow,list,0,0,200,300)
  function openbutton.onClick()
    local selected = gamelist.selected
    if sys.Directory(ldl.."PSP/GAME/"..selected.text).exists then
      sys.cmd("explorer file://"..ldl.."PSP/GAME/"..selected.text,false,true)
    elseif sys.File(ldl.."ISO/"..selected.text).exists then
      sys.cmd("explorer file://"..ldl.."ISO/",false,true)
    end
  end
  function copybutton.onClick()
    local selected = gamelist.selected
    local game = sys.File(ldl.."ISO/"..selected.text)
    local moveto = ui.savedialog("Copy game to...",false,"ISO Archive (*.iso*)|*.iso|")
    if game:copy(moveto.fullpath) == nil then
      ui.error("Failed to copy file.")
    else
      ui.info("Copyed game "..selected.text.." to "..moveto.fullpath)
    end
  end
  function gamelist.onSelect()
    gametitle.text = gamelist.selected.text
    delbutton.enabled = true
    copybutton.enabled = true
    openbutton.enabled = true
  end
  function delbutton.onClick()
    local selected = gamelist.selected
    print(ldl.."ISO/"..selected.text)
    print(ldl.."ISO/"..selected.text)
    local confim = ui.confirm("Do you really want to delete the game?")
    if confim == "yes" then
      if sys.Directory(ldl.."PSP/GAME/"..selected.text).exists then
        print("folder")
        sys.Directory(ldl.."PSP/GAME/"..selected.text):removeall()
      elseif sys.File(ldl.."ISO/"..selected.text).exists then
        print("iso") 
        if sys.File(ldl.."ISO/"..selected.text):remove() == false then
          ui.error("Unable to delete file! It may be open.")
        else
          ui.info("Deleted Game "..ldl.."ISO/"..selected.text)
        end
      end
    end
  end
end
while window.visible do
  ui.update()
end 