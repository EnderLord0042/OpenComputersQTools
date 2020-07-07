local component = require("component")
local os = require("os")
local keyboard = require("keyboard")
local event = require("event")
local tty = require("tty")
local colors = require ("colors")
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
  local function setSelection(sel)
    GPUProxy.setBackground(colorPrimary)
    GPUProxy.setForeground(colorSecondary)
    local menuCount = 1
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
  local canExit = true
  local function handleKeyPress(event,keyboardAddress,char,code,playerName)
    if code == 16 anf canExit then
      returnValue = "exit"
    end
    if code == 28 then
      returnValue = menuSelection
    end
    if code == 23 then
      canExit = false
      desc((info[menuSelection])[1],(info[menuSelection])[2],false)
      setSelection(menuSelection)
      canExit = true
    end
    if code == 200 then
      menuSelection = menuSelection + 1
      if menuSelection == menuCount then
        menuSelection = 1
      end
      setSelection(menuSelection)
    end
    if code == 208 then
      if menuSelection != 1 then
      menuSelection = menuSelection - 1
      if menuSelection == 0 then
        menuSelection = menuCount - 1
      end
      setSelection(menuSelection)
    end
  end
  local function handleTouch(event,screenAddress,screenX,screenY,playerName)
    
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


local test = menu("Test",{"Option 1","Option 2","Option 3"},{{"Test","Test Info 1"},{"Test","Test Info 2"},{"Test","Test Info 3"}})

GPUProxy.setBackground(0x000000)
GPUProxy.setForeground(0xFFFFFF)
tty.clear()

print(test)

