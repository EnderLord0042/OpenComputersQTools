local component = require("component")
local os = require("os")
local event = require("event")
local tty = require("tty")
local GPUProxy = component.getPrimary("gpu")

local colorPrimary = 0x0000FF
local colorSecondary = 0xFFFFFF

if GPUProxy.getDepth() == 1 then
  colorPrimary = 0x000000 
end

local screenWidth,screenHeight = GPUProxy.getResolution()

local function desc(descName,descInfo,continue)
  local menuSelection = 1
  GPUProxy.setBackground(colorPrimary)
  GPUProxy.setForeground(colorSecondary)
  GPUProxy.fill(1,1,screenWidth,screenHeight," ")
  GPUProxy.set(4,2,descName)
  GPUProxy.set(4,(screenHeight - 1),"  Back/Quit")
  if continue then
    GPUProxy.set(22,(screenHeight - 1),"Continue")
  end
  local descLinesNum = math.ceil(string.len(descInfo)/(screenWidth - 11))
  local descLines = {}
  for i = 1,descLinesNum do
    GPUProxy.set(6,(i + 5),string.sub(descInfo,((screenWidth - 11) * (i - 1)),(((screenWidth - 11) * i)) - 1))
  end
  GPUProxy.setBackground(colorSecondary)
  GPUProxy.setForeground(colorPrimary)
  GPUProxy.set(4,(screenHeight - 1),"Q")
  if continue then
    GPUProxy.set(16,(screenHeight - 1),"Enter")
  end
  GPUProxy.fill(4,4,(screenWidth - 7),1," ")
  GPUProxy.fill(4,5,1,(screenHeight - 8)," ")
  GPUProxy.fill(4,(screenHeight - 3),(screenWidth - 8),1," ")
  GPUProxy.fill((screenWidth - 4),5,1,(screenHeight - 7)," ")
  local returnValue = nil
  local function handleKeyPress(event,keyboardAddress,char,code,playerName)
    if code == 16 then
      returnValue = false
    end
    if code == 28 and continue then
      returnValue = true
    end
  end
  local function handleTouch(event,screenAddress,screenX,screenY,playerName)
    if screenY == (screenHeight - 1) and screenX > 3 and screenX < 15 then
      returnValue = false
    end
    if screenY == (screenHeight - 1) and screenX > 15 and screenX < 30 and continue then
      returnValue = true
    end
  end
  event.listen("key_down", handleKeyPress)
  event.listen("touch",handleTouch)
  while returnValue == nil do
    os.sleep(0.05)
  end
  event.ignore("key_down", handleKeyPress)
  event.ignore("touch",handleTouch)
  return returnValue
end

local function menu(menuName,menuEntries,info)
  local menuSelection = 1
  local function setupDisplay()
    GPUProxy.setBackground(colorPrimary)
    GPUProxy.setForeground(colorSecondary)
    GPUProxy.fill(1,1,screenWidth,screenHeight," ")
    GPUProxy.set(4,2,menuName)
    GPUProxy.set(4,(screenHeight - 1),"  Back/Quit   Additional Info       Select")
    GPUProxy.setBackground(colorSecondary)
    GPUProxy.setForeground(colorPrimary)
    GPUProxy.set(4,(screenHeight - 1),"Q")
    GPUProxy.set(16,(screenHeight - 1),"I")
    GPUProxy.set(34,(screenHeight - 1),"Enter")
    GPUProxy.fill(4,4,(screenWidth - 7),1," ")
    GPUProxy.fill(4,5,1,(screenHeight - 8)," ")
    GPUProxy.fill(4,(screenHeight - 3),(screenWidth - 8),1," ")
    GPUProxy.fill((screenWidth - 4),5,1,(screenHeight - 7)," ")
  end
  setupDisplay()
  local menuCount = 1
  local function setSelection(sel)
    GPUProxy.setBackground(colorPrimary)
    GPUProxy.setForeground(colorSecondary)
    menuCount = 1
    for _  in pairs(menuEntries) do
      GPUProxy.set(6,(5+menuCount),(menuEntries[menuCount] .. string.rep(" ", (screenWidth - 11 - string.len(menuEntries[menuCount])))))
      menuCount = menuCount + 1
    end
    GPUProxy.setBackground(colorSecondary)
    GPUProxy.setForeground(colorPrimary)
    GPUProxy.set(6,(5+sel),(menuEntries[sel] .. string.rep(" ", (screenWidth - 11 - string.len(menuEntries[sel])))))
  end
  setSelection(1)
  local returnValue = nil
  local canInteract = true
  local function handleKeyPress(event,keyboardAddress,char,code,playerName)
    if code == 16 and canInteract then
      returnValue = "exit"
    end
    if code == 28 and canInteract then
      returnValue = menuSelection
    end
    if code == 23 and canInteract then
      canInteract = false
      desc((info[menuSelection])[1],(info[menuSelection])[2],false)
      setupDisplay()
      setSelection(menuSelection)
      canInteract = true
    end
    if code == 208 and canInteract then
      menuSelection = menuSelection + 1
      if menuSelection == menuCount then
        menuSelection = 1
      end
      setSelection(menuSelection)
    end
    if code == 200 and canInteract then
      menuSelection = menuSelection - 1
      if menuSelection == 0 then
        menuSelection = menuCount - 1
      end
      setSelection(menuSelection)
    end
  end
  local function handleTouch(event,screenAddress,screenX,screenY,playerName)
    if screenY == (screenHeight - 1) and screenX > 3 and screenX < 15 and canInteract then
      returnValue = "exit"
    end
    if screenY == (screenHeight - 1) and screenX > 15 and screenX < 33 and canInteract then
      canInteract = false
      desc((info[menuSelection])[1],(info[menuSelection])[2],false)
      setupDisplay()
      setSelection(menuSelection)
      canInteract = true
    end
    if screenY == (screenHeight - 1) and screenX > 33 and screenX < 46 and canInteract then
      returnValue = menuSelection
    end
    if screenX > 5 and screenX < (screenWidth - 5) and screenY > 5 and screenY < (menuCount + 5) and canInteract then
      if screenY == (menuSelection + 5) then
        returnValue = menuSelection
      else
        menuSelection = screenY - 5
        setSelection(menuSelection)
      end
    end
  end
  event.listen("key_down", handleKeyPress)
  event.listen("touch",handleTouch)
  while returnValue == nil do
    os.sleep(0.05)
  end
  event.ignore("key_down", handleKeyPress)
  event.ignore("touch",handleTouch)
  return returnValue
end


local menu1result = nil
repeat
  menu1result = menu("QTools v1.0.0",{"EEPROM Tools","QNet","QDesktop"},{{"EEPROM Tools Info","This is a collection of tools to allow you to easily make small changes to your EEPROM."},{"QNet Info","This is a collection of tools used in QNet, an internet system for OpenComputers based on the real Internet."},{"QDesktop Tools","This is a collection of tools for installing and modifying QDesktop, a desktop for OpenOS."}})
  if menu1result == 1 then
    local menu2result = nil
    repeat
      menu2result = menu("EEPROM Tools",{"Remove Beep"},{{"Remove Beep Info","Many different types of BIOS have a computer.beep() function call. This removes that."}})
      if menu2result == 1 then
        if desc("Will Alter EEPROM","This will alter the EEPROM currently in your computer. Please enter the EEPROM to be altered or go back.",true) then
          desc("Remove Beep",(require("/home/QTools/EEPROMTools/RemoveBeep.lua").unbeep() .. " You may now continue using QTools or exit."),false)
        end 
      end
    until(menu2result == "exit")
  elseif menu1result == 2 then
    desc("Not Implemented","This tool is not yet implemented in QTools. Please wait for another release",false)
  elseif menu1result == 3 then
    desc("Not Implemented","This tool is not yet implemented in QTools. Please wait for another release",false)
  end
until(menu1result == "exit")

GPUProxy.setBackground(0x000000)
GPUProxy.setForeground(0xFFFFFF)
tty.clear()
