local component = require("component")
local os = require("os")
local tty = require("tty")
local colors = require ("colors")
local GPUProxy = component.getPrimary("gpu")

local colorPrimary = 0x0000FF
local colorSecondary = 0xFFFFFF

if GPUProxy.getDepth() == 1 then
  colorPrimary = 0x000000 
end

local screenWidth,screenHeight = GPUProxy.getResolution()

local function menu(menuName,menuEntries)
  local menuSelection = 1
  GPUProxy.setBackground(colorPrimary)
  GPUProxy.setForeground(colorSecondary)
  GPUProxy.fill(1,1,screenWidth,screenHeight," ")
  GPUProxy.set(4,2,menuName)
  GPUProxy.setBackground(colorSecondary)
  GPUProxy.fill(4,4,(screenWidth - 7),1," ")
  GPUProxy.fill(4,5,1,(screenHeight - 8)," ")
  GPUProxy.fill(4,(screenHeight - 2),(screenWidth - 8),1," ")
  GPUProxy.fill((screenWidth - 4),5,1,(screenHeight - 7)," ")
  os.sleep(500)
end
local function desc(descName,descInfo)
  print("placeholder")
end

local testResult = menu("Test Menu",{"Option 1","Option 2", "Option 3"})

GPUProxy.setBackground(0x000000)
GPUProxy.setForeground(0xFFFFFF)
tty.clear()

print(testResult)
