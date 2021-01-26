local component = require("component")
local event = require("event")
local event = require("filesystem")

local ROUTER_QWEB_VERSION = "qweb1.0.0"

local hasInternet = component.isAvailable("internet")
local hasTunnel = component.isAvailable("tunnel")

component.modem.setWakeMessage(ROUTER_QWEB_VERSION, true)

if hasTunnel then
  component.tunnel.setWakeMessage(ROUTER_QWEB_VERSION, true)
end

local function handleModemMessage(receiverAddress, senderAddress, port, distance, qwebVersion, packetType, fromIP, toIP, data, data2, data3, data4)
  if qwebVersion == ROUTER_QWEB_VERSION then
    if packetType == "findRouter" then
      
    else if packetType == "internetRequest" then
      
    else if packetType == "data" then
      
    end
  end
end

event.listen("modem_message", handleModemMessage)
