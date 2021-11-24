local event = require("event")
local colors = require("colors")
local term = require("term")
local internet = require("internet")

component = require("component")
local gpu = component.gpu
local m = component.modem

--=========== NETWORKING ===========--

m.open(1)
m.setWakeMessage('update_wakeup')

local function message_handler(_, _, from, port, _, ...)
  local args = {...}

  if args[1] == 'update_software' then
    local handle = internet.request("")
  end
end

event.listen("modem_message", message_handler)

--=========== TERMINAL ===========--

gpu.setResolution(160/2, 50/2)
local w, h = gpu.getResolution()

term.setCursorBlink(true)

term.clear()
term.setCursor(1, 3)

while true do
  gpu.setForeground(0x000000)
  gpu.setBackground(0x00DB00)
  gpu.fill(1, 1, w, 1, " ")
  gpu.set(4, 1, "PFOS 0.0.1 [devbranch]")

  gpu.setForeground(0x00DB00)
  gpu.setBackground(0x000000)
  gpu.fill(1, 2, w, 1, " ")

  io.write(" > ")
  gpu.setForeground(0xFFFFFF)
  local input = io.read()
  if input == "exit" then
    break
  elseif input == "clear" then
    term.clear()
    term.setCursor(1, 3)
  end
end

term.clear()