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

local function handleModemMessage(arg)
  print("Function called")
  local receiverAddress = arg[2]
  local senderAddress = arg[3]
  local port = arg[4]
  local distance = arg[5]
  local header = arg [6]
  local packetInfo = serialization.unserialize(header)
  local nonBreakingVersion = packetInfo["qwebVersion"]:match "%d*.%d*"
  if nonBreakingVersion == "1.0" then
    if packetInfo["packetType"] == "findRouter" then
      local ipListFile = io.open("iplist.txt","r")
      io.input(ipListFile)
      local serializedIPList = io.read()
      local ipList = serialization.unserialize(serializedIPList)
      print(serializedIPList)
      print("pog")
      print(ipList)
      io.close(ipListFile)
      local identityFile = io.open("identity.txt","r")
      io.input(identityFile)
      local identity = io.read()
      print(identity)
      io.close(identityFile)
      local senderIP = ""
      if not empty(iplist) then
        for i, v in pairs(iplist) do
          if senderAddress == v then
            senderIP = i
          end
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
    elseif packetInfo["packetType"] == "internetRequest" then
      
    elseif packetInfo["packetType"] == "data" then
      
    end
  end
end


component.modem.open(42)


print("event listener listening")

while true do
 local eventInfo = {event.pull("modem_message")}
 print(eventInfo)
 handleModemMessage(eventInfo)
end
