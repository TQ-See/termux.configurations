package.path = package.path .. ";/storage/emulated/0/Documents/components/?.lua"

-- default package.pth sebelumnya cuman = ?.lua , gk tahu path aslinya dimana
math.randomseed(os.time())

os.setlocale("id_ID")
local sekarang = os.time()
local format_panjang = os.date("%A, %d %b %Y", sekarang)
local format_pendek = os.date("%d %m %y", sekarang)
local jam_24 = os.date("%H:%M:%S", sekarang)
local jam_12 = os.date("%I:%M %p", sekarang)

local quotes  = require("quotes")
local authors = require("authors")
local kuotes = require("kuotes")

local index = math.random(1, #authors)


print(format_panjang .. "            ")
print("============================================")
print("            📜 Quote Hari Ini:")
-- print("\n   ~ " .. quotes[index] .. "\n" ) 
print("--------------------------------------------")
print('\n   "' .. kuotes[index] .. '"\n\n               ~  ' .. authors[index])
print("--------------------------------------------")
print("                                    " .. jam_12)
