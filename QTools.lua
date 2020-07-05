local component = require("component")
local os = require("os")
local tty = require("tty")
local colors = require ("colors")
local GPUProxy = component.getPrimary("gpu")

local colorPrimary = 0x0000FF
local colorSecondary = 0xFFFFFF

if GPUProxy.getDepth() = 1 then
  colorPrimary = 0x000000 
end

local screenWidth,sceenHeight = GPUProxy.getResolution()

local menu,desc =
  function(menuName,menuEntries)
    local menuSelection = 1
    GPUProxy.setBackground(colorPrimary))
    GPUProxy.setForegroundground(colorSecondary)
    GPUProxy.fill(1,1,screenWidth,screenHeight," ")
    GPUProxy.set(5,4,menuName)
    GPUProxy.setBackground(colorSecondary)
    GPUProxy.fill(5,6,(screenWidth - 10),1," ")
    GPUProxy.fill(5,6,1,(screenHeight - 12)," ")
    GPUProxy.fill(5,(screenHeight - 6),(screenWidth - 10),1," ")
    GPUProxy.fill((screenWidth - 5),6,1,(screenHeight - 12)," ")
    os.sleep(500)
  end,
  function(descName,descInfo)
    print("placeholder")
  end

local testResult = menu("test",{"Option 1","Option 2", Option 3})

GPUProxy.setBackground(0x000000)
GPUProxy.setForeground(0xFFFFFF)
tty.clear()

print(testResult)
