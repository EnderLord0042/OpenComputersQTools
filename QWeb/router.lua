local component = require("component")
local event = require("event")
local fs = require("filesystem")

local hasInternet = component.isAvailable("internet")
local hasTunnel = component.isAvailable("tunnel")

component.modem.setWakeMessage("qweb1.0.0/findRouter", true)

if hasTunnel then
  component.tunnel.setWakeMessage("qweb1.0.0/wake", true)
end

local function handleModemMessage(receiverAddress, senderAddress, port, distance, packetType, fromIP, toIP, virtualPort, data, data2, data3, data4)
  if packetType == "qweb1.0.0/findRouter" then
    
  else if packetType == "qweb1.0.0/internetRequest" then
    
  else if packetType == "qweb1.0.0/data" then
    if port != nil and hasTunnel then
      component.tunnel.send(packetType, fromIP, toIP, virtualPort, data, data2, data3, data4)
    end
    
  end
end

event.listen("modem_message", handleModemMessage)
