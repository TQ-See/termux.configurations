-- ===============================
-- Ebook Launcher (Termux Safe)
-- ===============================

-- Tambahkan path module ebook
package.path = package.path
  .. ";/storage/emulated/0/Documents/EbookLauncher/?.lua"
  .. ";/storage/emulated/0/Documents/scripts/?.lua"

-- Daftar ebook (nama file TANPA .lua)
local ebooks = {
  "lua",
  "vim",
  "rust",
  "nix",
  "helix"
}

-- Clear screen (launcher / termux compatible)
local function clear_screen()
  if binding and binding.exec then
    binding.exec("clear")
  else
    os.execute("clear")
  end
end

-- Input universal
local function read_input(prompt)
  if prompt then io.write(prompt) end
  return io.read()
end

local function show_menu()
  clear_screen()
  print("--------------------------------------------")
  print("====================================== START")
  print("      Which ebook do you want to open?      ")
  print("--------------------------------------------")

  for i, name in ipairs(ebooks) do
    print(string.format("[ %d ] %s", i, name))
  end

  print("--------------------------------------------")
end

while true do
  show_menu()

  local input_user = read_input("Input number (q to quit): ")

  if not input_user then
    print("\n❌ Input error!")
    break
  end

  if input_user == "q" then
    print("👋 Bye, happy hacking!")
    break
  end

  local index = tonumber(input_user)

  if not index or index < 1 or index > #ebooks then
    print("⚠️ Invalid input!")
    read_input("Press Enter...")
  else
    local ebook_name = ebooks[index]

    -- Reset cache supaya aman reload
    package.loaded[ebook_name] = nil

    local ok, module = pcall(require, ebook_name)

    if not ok then
      print("❌ Failed to load ebook:")
      print(module)
      read_input("Press Enter...")
    elseif type(module) == "table" and type(module.run) == "function" then
      module.run()
    elseif type(module) == "function" then
      module()
    else
      print("⚠️ Ebook loaded but no runnable entry found.")
      read_input("Press Enter...")
    end
  end
end
