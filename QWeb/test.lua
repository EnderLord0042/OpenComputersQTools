    local component = require("component")
    local event = require("event")
    local serialization = require("serialization")
    local m = component.modem -- get primary modem component
    m.open(42)
    print(m.isOpen(42)) -- true
    -- Send some message.
    m.broadcast(42, serialization.serialize({qwebVersion="1.0.0",packetType="findRouter"}))
    -- Wait for a message from another network card.
    local _, _, from, port, _, message = event.pull("modem_message")
    print("Got a message from " .. from .. " on port " .. port .. ": " .. tostring(message))
