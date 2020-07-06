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
  os.sleep(500)
end
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
  local descLinesNum = math.ceil(string.len(descInfo)/(screenWidth - 10))
  local descLines = {}
  local i = 1
  while i < descLinesNum do
    GPUProxy.set(6,(i + 5),string.sub(descInfo,(0 + ((screenWidth - 10) * i)),((screenWidth - 10) * (i + 1))))
    i += 1
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
  os.sleep(500)
end

desc("Test","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting.",true)

GPUProxy.setBackground(0x000000)
GPUProxy.setForeground(0xFFFFFF)
tty.clear()

