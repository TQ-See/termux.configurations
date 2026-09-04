-- ===============================
-- Ebook Launcher (Yantra)
-- ===============================

-- Daftar ebook (nama file TANPA .lua)
local ebooks = {
  "rustreact",
}

-- Helper untuk eksekusi command
local function cmd(c)
  if binding and binding.exec then
    binding.exec(c)
  end
end

-- Tampilkan menu
local function show_menu()
  cmd("clear")
  print("--------------------------------------------")
  print("====================================== START")
  print("      Which ebook do you want to open?      ")
  print("--------------------------------------------")

  for i, name in ipairs(ebooks) do
    print(string.format("[ %d ] %s", i, name))
  end

  print("--------------------------------------------")
  print("Input number (q to quit):")
end

-- Loop utama
while true do
  show_menu()

  local input_user = input()

  -- Quit
  if input_user == "q" then
    print("👋 Bye, happy hacking!")
    break
  end

  -- Konversi input ke angka
  local choice = tonumber(input_user)

  if choice and ebooks[choice] then
    local ebook = ebooks[choice]

    -- Aksi khusus per ebook
    if ebook == "rustreact" then
      cmd("clear")
      cmd("termux rustreact")
      cmd("web http://localhost:3001")
    end
  else
    print("❌ Invalid input. Please choose a valid number.")
    input("Press Enter to continue...")
  end
end
