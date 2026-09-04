-- cbz_manager.lua
-- Usage: lua cbz_manager.lua "manga.cbz"

local cbz_file = arg[1]

-- 1. Validasi Input
if not cbz_file then
  print("Usage: lua cbz_manager.lua <file.cbz>")
  os.exit(1)
end

-- ==========================================
-- HELPER FUNCTIONS
-- ==========================================
local function quote(str)
  return '"' .. str:gsub('"', '\\"') .. '"'
end

local function sh(cmd)
  local ok, _, code = os.execute(cmd)
  if type(ok) == "boolean" then
    return ok and (code == 0 or code == nil)
  else
    return ok == 0
  end
end

local function file_exists(path)
  local f = io.open(path, "r")
  if f then f:close() return true end
  return false
end

-- ==========================================
-- STEP 1: Persiapan & Ekstraksi
-- ==========================================
-- Buat nama folder temp yang unik berdasarkan waktu
local temp_dir = ".tmp_cbz_" .. os.time()
print("Target: " .. cbz_file)

-- Buat folder temp
if not sh("mkdir -p " .. quote(temp_dir)) then
  print("[Error] Failed to create temp directory.")
  os.exit(1)
end

-- Tampilkan isi dulu
print("\n--- Contents Preview ---")
sh("unzip -l " .. quote(cbz_file))
print("------------------------")

print("\n[Process] Extracting ALL files...")
-- Extract quiet (-q) ke folder temp (-d)
local unzip_cmd = "unzip -q " .. quote(cbz_file) .. " -d " .. quote(temp_dir)
if not sh(unzip_cmd) then
  print("[Error] Failed to extract. File might be corrupted.")
  sh("rm -rf " .. quote(temp_dir))
  os.exit(1)
end

-- ==========================================
-- STEP 2: Pilih Mode (Edit / Delete)
-- ==========================================
print("\nSelect Action:")
print(" [E] Edit / Create file")
print(" [D] Delete file")
io.write("> ")
local choice = io.read():lower() -- ubah ke huruf kecil

-- Validasi pilihan
if choice ~= "e" and choice ~= "d" then
  print("[Abort] Invalid option.")
  sh("rm -rf " .. quote(temp_dir))
  os.exit(0)
end

-- ==========================================
-- STEP 3: Input Nama File & Eksekusi
-- ==========================================
io.write("\nEnter filename (e.g. 001.jpg or ComicInfo.xml): ")
local target_file = io.read()

if not target_file or target_file == "" then
  print("[Abort] No filename entered.")
  sh("rm -rf " .. quote(temp_dir))
  os.exit(0)
end

local full_target_path = temp_dir .. "/" .. target_file

-- LOGIKA DELETE
if choice == "d" then
  if file_exists(full_target_path) then
    os.remove(full_target_path)
    print("\n[Delete] File '" .. target_file .. "' marked for deletion.")
  else
    print("\n[Error] File '" .. target_file .. "' not found inside archive.")
    print("Nothing to delete. Aborting...")
    sh("rm -rf " .. quote(temp_dir))
    os.exit(0)
  end

-- LOGIKA EDIT
elseif choice == "e" then
  -- Cek jika file tidak ada, tawarkan buat baru
  if not file_exists(full_target_path) then
    print("[Info] File not found.")
    io.write("Create new file? (y/n): ")
    local ans = io.read()
    if ans:lower() == 'y' then
      sh("touch " .. quote(full_target_path)) -- buat file kosong
    else
      print("[Abort] Cancelled.")
      sh("rm -rf " .. quote(temp_dir))
      os.exit(0)
    end
  end
  
  -- Buka Editor
  local editor = os.getenv("EDITOR") or "vim"
  print("[Edit] Opening " .. editor .. "...")
  sh(editor .. " " .. quote(full_target_path))
end

-- ==========================================
-- STEP 4: Repack (Zip Ulang)
-- ==========================================
print("\n[Process] Re-packing archive...")

local new_cbz = cbz_file .. ".new"

-- Masuk ke temp_dir, lalu zip semua isi (.) ke output file
local zip_cmd = "cd " .. quote(temp_dir) .. " && zip -r -9 ../" .. quote(new_cbz) .. " ."

if sh(zip_cmd) then
  print("[Success] Archive rebuilt successfully.")
  
  -- Timpa file lama
  print("[Update] Overwriting original file...")
  sh("mv " .. quote(new_cbz) .. " " .. quote(cbz_file))
  
  local action_str = (choice == "d") and "deleted from" or "updated in"
  print("✔ Done! File " .. action_str .. " " .. cbz_file)
else
  print("[Error] Failed to repack archive.")
  if file_exists(new_cbz) then os.remove(new_cbz) end
end

-- ==========================================
-- STEP 5: Bersih-bersih
-- ==========================================
sh("rm -rf " .. quote(temp_dir))
