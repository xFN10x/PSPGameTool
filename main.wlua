ui = require("ui")
sys = require("sys")
com = require("compression")

window = ui.Window("PSP Game Tools: Main Menu","fixed",504,220)
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
window:show() 
print(sys.currentdir)
gamedatabase = sys.File(sys.currentdir.."/data/gamedatabase.txt")
ldl = sys.File(sys.currentdir.."/savedata/lastdriveletter.set"):open("read"):read()
if sys.Directory(ldl.. "/PSP").exists and sys.Directory(ldl.. "/ISO").exists then
 ui.msg("Selected PSP at "..ldl)
else
  if ldl == "/nil" then
    ui.msg("Select Drive Letter", "First Time Setup")
  else
    ui.error("The selected drive doesn't have the PSP/ISO folder, or is not a PSP")
  end
  drivewindow = ui.Window("PSP Game Tools: Drive Selection","single",265,100)
  drivewindow:loadicon(sys.currentdir.."/images/icon.ico")
  window:showmodal(drivewindow)
  driveselect = ui.Combobox(drivewindow,false,{"D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"})
  driveshowbutton = ui.Button(drivewindow,"Show Connected Drives",120,9)
  driveclosebutton = ui.Button(drivewindow,"Done",0,40,265,60)
  function driveshowbutton.onClick()
    sys.cmd('explorer file:\\')
  end
  function driveclosebutton.onClick()
    if driveselect.selected == nil then
      ui.error("Please Select a letter")
    else
       if sys.Directory(driveselect.selected.text..":/".. "PSP").exists == true and sys.Directory(driveselect.selected.text..":/".. "ISO").exists == true then
      ui.msg("Selected PSP at "..driveselect.selected.text..":/")
      sys.File(sys.currentdir.."/savedata/lastdriveletter.set"):open("write"):write(driveselect.selected.text..":/")
      drivewindow:hide()
    else
      ui.error("Still not a psp...")
    end
    drivewindow:tofront()
    end
  end 
  function drivewindow.onClose()
    if ui.confirm("The only program you can use without a drive selected, is PSXTOPSP, would you like to open it?") == "yes" then
      sys.cmd(sys.currentdir.."/psxtopsp/app.exe")
      window:hide()
    else
      if ui.confirm("Would you like to exit?") == "yes" then
        window:hide()
      else
        return false
      end
    end
  end
end

function ps1button.onClick()
  if ui.confirm("This will open PSXTOPSP, Do you wish to continue?","Open Other App") == "yes" then
    sys.cmd(sys.currentdir.."/psxtopsp/app.exe")
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
        copyedfile:flush()
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
  ui.msg("You can look at the saves on your PSP!")
  local listwindow = ui.Window("PSP Game Tools: Save List","fixed",500,300)
  window:showmodal(listwindow)
  local isolist = ui.List(listwindow,list,0,0,150,300)
  gameimage = ui.Picture(listwindow,sys.currentdir.."/images/noneselected.png",160,50,288,160)
  gameimage:show()
  gamedes = ui.Label(listwindow,"No Save Selected",160,210,260)
  local gametitle = ui.Label(listwindow,"No Save Selected",160,10,1000000,10)
  local savetitle = ui.Label(listwindow,"No Save Selected",160,30)
  gametitle.textalign = "left"
  gametitle.fgcolor = 0xc0c0c0
  savetitle.textalign = "left"
  gamedes.textalign = "left"
  local deletebutton = ui.Button(listwindow,"Delete Save",420,270)
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
      gameimage:load(ldl.."PSP/SAVEDATA/"..item.text.."/ICON0.PNG")
      gameimage.width = 288
      gameimage.height = 160
       local des = string.sub(sys.File(ldl.."PSP/SAVEDATA/"..item.text.."/PARAM.SFO"):open("read"):read():encode(),273)
      local title = string.sub(sys.File(ldl.."PSP/SAVEDATA/"..item.text.."/PARAM.SFO"):open("read"):read():encode(),4657 )
      gametitle.text = "Unknown Game"
      gamedes.text = des
      gamedes.width = 260
      savetitle.text = title 
      --ui.msg(des)
      deletebutton.enabled = true
      for line in gamedatabase:open("read").lines do
        if string.sub(line,0,9) == string.sub(item.text,0,9) then
          gametitle.text = string.sub(line,11)
          gametitle.height = 20
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

while window.visible == true do
  ui.update()
end 
