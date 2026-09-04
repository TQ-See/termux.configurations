-- rustepub.lua — Download & update EPUB "The Rust Programming Language"
-- Sumber: build otomatis harian dari rust-lang/book (artur-sulej.github.io/rust-ebooks)
local EPUB_URL  = "https://artur-sulej.github.io/rust-ebooks/rust-book.epub"
local EPUB_DIR  = os.getenv("HOME") .. "storage/projects/rust-learning/ebooks"
local EPUB_PATH = EPUB_DIR .. "/rust-book.epub"

local function pause()
  io.write("\nTekan Enter untuk lanjut...")
  io.read()
end

local function command_exists(cmd)
  return os.execute("command -v " .. cmd .. " > /dev/null 2>&1") == true
end

local function file_exists(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  end
  return false
end

local function ensure_dir()
  os.execute('mkdir -p "' .. EPUB_DIR .. '"')
end

-- Jalankan curl, kembalikan HTTP status code sebagai string
local function curl_fetch(extra_args)
  local cmd = 'curl -sL ' .. extra_args
    .. ' -o "' .. EPUB_PATH .. '"'
    .. ' -w "%{http_code}"'
    .. ' "' .. EPUB_URL .. '"'
  local handle = io.popen(cmd)
  local http_code = handle:read("*a"):gsub("%s+", "")
  handle:close()
  return http_code
end

local function download_epub()
  if not command_exists("curl") then
    print("curl tidak ditemukan. Install dulu: pkg install curl")
    pause()
    return
  end

  ensure_dir()
  print("Mengunduh EPUB terbaru...")
  local http_code = curl_fetch("")

  if http_code == "200" then
    print("Berhasil disimpan ke " .. EPUB_PATH)
  else
    print("Gagal download (HTTP " .. http_code .. "). Cek koneksi internet.")
  end
  pause()
end

local function update_epub()
  if not command_exists("curl") then
    print("curl tidak ditemukan. Install dulu: pkg install curl")
    pause()
    return
  end

  if not file_exists(EPUB_PATH) then
    print("Belum ada EPUB lokal. Pakai opsi 1 (Download EPUB) dulu.")
    pause()
    return
  end

  print("Mengecek versi terbaru...")
  -- -z: cuma download & replace kalau versi remote lebih baru dari file lokal
  local http_code = curl_fetch('-z "' .. EPUB_PATH .. '"')

  if http_code == "200" then
    print("EPUB berhasil di-update ke versi terbaru.")
  elseif http_code == "304" then
    print("EPUB sudah versi terbaru, tidak ada perubahan.")
  else
    print("Gagal cek update (HTTP " .. http_code .. "). Cek koneksi internet.")
  end
  pause()
end

local menu = {
  { label = "Download EPUB",     action = download_epub },
  { label = "Cek & Update EPUB", action = update_epub },
}

while true do
  os.execute("clear")
  print("📖 Rust Book EPUB Manager\n")
  for i, item in ipairs(menu) do
    print(string.format("%d. %s", i, item.label))
  end
  print("0. Exit\n")
  print("File: " .. EPUB_PATH)

  io.write("\nPilih: ")
  local choice = tonumber(io.read())

  if choice == 0 then
    os.exit(0)
  elseif choice and menu[choice] then
    menu[choice].action()
  else
    print("Pilihan tidak valid.")
    os.execute("sleep 1")
  end
end
