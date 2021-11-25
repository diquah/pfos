local event = require("event")
local colors = require("colors")
local term = require("term")
local internet = require("internet")
local computer = require("computer")

component = require("component")
local gpu = component.gpu
local m = component.modem
local filesystem = component.filesystem

--=========== NETWORKING ===========--

local function download_and_save(filename, url)
  local handle, data, chunk = internet.request(url), ""
  while true do
    chunk = handle.read(math.huge)
    if chunk then
        data = data .. chunk
    else
        break
    end
  end
  local f = io.open(filename, "w")
  f:write(data)
  f:close()
end

local function update_all()
  download_and_save("autorun.lua", "https://raw.githubusercontent.com/rubycookinson/pfos/main/autorun.lua")
  download_and_save("ac.lua", "https://raw.githubusercontent.com/rubycookinson/pfos/main/ac.lua")
end

m.open(1)
m.setWakeMessage("update_wakeup")

local function message_handler(_, _, from, port, _, ...)
  local args = {...}

  if args[1] == "update_software" then
    update_all()
    computer.shutdown(true)
  end
end

event.ignore("modem_message", message_handler)
mh_listener = event.listen("modem_message", message_handler)

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
  elseif input == "update" then -- Disable in release
    update_all()
    computer.shutdown(true)
  elseif input == "ac" then
    os.execute("ac.lua")
  end
end

event.ignore("modem_message", message_handler)
m.close(1)
term.clear()
