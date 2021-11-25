local term = require("term")

component = require("component")
local gpu = component.gpu

gpu.setResolution(16*2, 5*2)
local w, h = gpu.getResolution()

gpu.setBackground(0x1E1E1E)
gpu.fill(1, 1, w, h, " ")

gpu.setForeground(0x696969)
gpu.set(10, 4, "PLEASE SCAN ID")

gpu.setBackground(0x3C3C3C)
gpu.fill(5, 7, 23, 1, " ")

os.sleep(5)

gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)
gpu.fill(1, 1, w, h, " ")

gpu.setResolution(160/2, 50/2)
