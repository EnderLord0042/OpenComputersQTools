local component = require("component")
local EEPROM = component.eeprom.get()

if not string.find(EEPROM,"computer.beep%(") then
  print("No Beeps found in current EEPROM.")
  return
end

while string.find(EEPROM,"computer.beep%(") do
  local funcStart,_ = string.find(EEPROM,"computer.beep%(")
  local funcEnd,_ = string.find(EEPROM,")",funcStart,string.len(EEPROM))
  EEPROM = string.sub(EEPROM, 1, (funcStart - 1)) .. string.sub(EEPROM, (funcEnd + 1), string.len(EEPROM))
end

component.eeprom.set(EEPROM)
