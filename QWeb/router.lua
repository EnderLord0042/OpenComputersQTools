local component = require("component")
local event = require("event")

local hasInternet = component.isAvailable("internet")
local hasTunnel = component.isAvailable("tunnel")

local function handleModemMessage()
  
end

event.listen("modem_message", handleModemMessage)
