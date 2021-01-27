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

local function handleModemMessage(receiverAddress, senderAddress, port, distance, header, data...)
  local packetInfo = serialization.unserialize(header)
  local nonBreakingVersion = packetInfo["qwebVersion"]:match ".%d*.%d*"
  if nonBreakingVersion == "1.0" then
    
  end
end

event.listen("modem_message", handleModemMessage)
