local function show_menu()
  binding.exec("clear")
  print("--------------------------------------------")
  print("       Automatic File Maker (Yantra)        ") 
  print("============================================")
end

show_menu()

print("")
print("Choose storage location:")
print("[1] Internal Storage")
print("[2] External SD Card")
print("--------------------------------------------")
io.write("Your choice (1/2): ")
local storage_choice = input()

-- Root path Android
local root_path = nil

if storage_choice == "1" then
  root_path = "/storage/emulated/0/"
elseif storage_choice == "2" then
  -- change your external path!
  root_path = "/storage/F0E9-334E/"
else
  print("\n❌ Pilihan tidak valid!")
  return
end

print("")
print("--------------------------------------------")
print("- Where is the path do you put this file? --")
print("----------------- Example : Path/to/file.ext")
io.write(": ")
local user_path = input()

if user_path == "" then
  print("\n❌ Path tidak boleh kosong!")
  return
end

-- Gabungkan root + path user
local full_path = root_path .. user_path

-- Buka file (write mode)
local file, err = io.open(full_path, "w")

if not file then
  print("\n❌ Gagal membuat file!")
  print(err)
  return
end

-- Template isi file
file:write("(Write your script or text here!)\n")
file:close()

print("\n✅ File berhasil dibuat!")
print("📂 Location: " .. full_path)
