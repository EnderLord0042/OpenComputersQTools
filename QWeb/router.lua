local component = require("component")
local event = require("event")
local fs = require("filesystem")
local serialization = require("serialization")

local hasInternet = component.isAvailable("internet")
local hasTunnel = component.isAvailable("tunnel")

component.modem.setWakeMessage("qwebRouterWake", true)

if hasTunnel then
  component.tunnel.setWakeMessage("wake", true)
end

local function handleModemMessage(...)
  local receiverAddress = arg[1]
  local senderAddress = arg[2]
  local port = arg[3]
  local distance = arg[4]
  local header = arg [5]
  local packetInfo = serialization.unserialize(header)
  local nonBreakingVersion = packetInfo["qwebVersion"]:match "%d*.%d*"
  if nonBreakingVersion == "1.0" then
    if packetInfo["packetType"] == "findRouter" then
      local ipListFile = io.open("iplist.txt","r")
      io.input(ipListFile)
      local ipList = serialization.unserialize(io.read("*l"))
      io.close(ipListFile)
      local identityFile = io.open("identity.txt","r")
      io.input(identityFile)
      local identity = io.read("*l")
      io.close(identityFile)
      local senderIP = ""
      for ip, address in pairs(iplist) do
        if senderAddress == address then
          senderIP = ip
        end
      end
      if senderIP == "" then
        local highestIP = 0
        for ip, address in pairs(iplist) do
          if tonumber(ip:match "%d$") >= highestIP then
            highestIP = tonumber(ip:match "%d$") + 1
          end
        end
        senderIP = identity + "." + tostring(highestIP)
        ipList[senderIP] = senderAddress
        ipListFile = io.open("iplist.txt","w")
        io.output(ipListFile)
        io.write(serialization.serialize(ipList))
        io.close(ipListFile)
      end
      component.modem.send(senderAddress, port, serialization.serialize({qwebVersion="1.0.0",packetType="returnRouter",fromIP=identity,toIP=senderIP,packetPort=tostring(port)}), senderIP)
    else if packetInfo["packetType"] == "internetRequest" then
      
    else if packetInfo["packetType"] == "data" then
      
    end
  end
end

event.listen("modem_message", handleModemMessage)
