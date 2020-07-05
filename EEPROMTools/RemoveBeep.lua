local component = require("component")
local EEPROM = component.eeprom.get()

if not string.find(EEPROM,"computer.beep(")
  print("No Beeps found in current EEPROM.")
  return
end

while string.find(EEPROM,"computer.beep(")
  local funcStart, nil = string.find(EEPROM,"computer.beep(")
  local funcEnd, nil = string.find(EEPROM,")",funcStart,string.len(EEPROM))
  EEPROM = string.sub(EEPROM, 1, funcStart) .. string.sub(EEPROM, funcEnd, string.len(EEPROM))
end

component.eeprom.set(EEPROM)
