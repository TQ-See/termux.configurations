-- rustlearn.lua — Rust offline learning launcher untuk Termux
local ROOT = os.getenv("HOME") .. "storage/projects/rust-learning"

local function clear()
  os.execute("clear")
end

local function pause()
  io.write("\nTekan Enter untuk lanjut...")
  io.read()
end

local function run(cmd)
  os.execute(cmd)
end

-- Cek apakah sebuah command ada di PATH
local function command_exists(cmd)
  return os.execute("command -v " .. cmd .. " > /dev/null 2>&1") == true
end

-- Buka file markdown: pakai `glow` (rendered) kalau ada, fallback ke `less`
local function open_reader(path)
  if command_exists("glow") then
    run('glow -p "' .. path .. '"')
  else
    run('less "' .. path .. '"')
  end
end

-- Cari semua file .md di sebuah direktori, biarkan user pilih, buka via open_reader
local function browse_markdown(dir)
  local handle = io.popen('find "' .. dir .. '" -name "*.md" 2>/dev/null | sort')
  if not handle then
    print("Gagal membaca direktori: " .. dir)
    pause()
    return
  end

  local files = {}
  for line in handle:lines() do
    table.insert(files, line)
  end
  handle:close()

  if #files == 0 then
    print("Belum ada materi di " .. dir)
    print("(pastikan sudah di-clone dulu waktu online)")
    pause()
    return
  end

  clear()
  for i, f in ipairs(files) do
    local label = f:gsub(dir .. "/", "")
    print(string.format("%3d. %s", i, label))
  end

  io.write("\nPilih nomor (0 = batal): ")
  local choice = tonumber(io.read())
  if choice and choice > 0 and choice <= #files then
    open_reader(files[choice])
  end
end

local function open_book()
  browse_markdown(ROOT .. "/book/src")
end

local function open_examples()
  browse_markdown(ROOT .. "/rust-by-example/src")
end

local function run_rustlings()
  if not command_exists("rustlings") then
    print("rustlings belum ke-install atau belum ada di PATH.")
    print("Install dulu: cargo install rustlings")
    pause()
    return
  end
  run('cd "' .. ROOT .. '/rustlings" && rustlings')
end

local function list_projects()
  clear()
  run('ls -la "' .. ROOT .. '/projects"')
  pause()
end

local function new_project()
  io.write("Nama project baru: ")
  local name = io.read()

  if not name or name == "" then
    pause()
    return
  end

  -- Cuma izinkan huruf, angka, underscore, dash — cegah shell injection
  if not name:match("^[%w_%-]+$") then
    print("Nama tidak valid. Cuma boleh huruf, angka, underscore, dan dash.")
    pause()
    return
  end

  if not command_exists("cargo") then
    print("cargo tidak ditemukan.")
    pause()
    return
  end

  run('cd "' .. ROOT .. '/projects" && cargo new "' .. name .. '"')
  pause()
end

local function open_docs()
  if not command_exists("rustup") then
    print("rustup tidak ditemukan. Pastikan sudah terpasang lewat rustup-init.")
    pause()
    return
  end
  run("rustup doc")
end

local function show_version()
  clear()
  run("rustc --version")
  run("cargo --version")
  run("rustup show")
  pause()
end

local menu = {
  { label = "Rust Book",             action = open_book },
  { label = "Rust By Example",       action = open_examples },
  { label = "Rustlings",             action = run_rustlings },
  { label = "My Projects",           action = list_projects },
  { label = "Project Baru (cargo new)", action = new_project },
  { label = "Rust Documentation (rustup doc)", action = open_docs },
  { label = "Rust Version",          action = show_version },
}

while true do
  clear()
  print("🦀 Rust Learning Environment\n")
  for i, item in ipairs(menu) do
    print(string.format("%d. %s", i, item.label))
  end
  print("0. Exit\n")

  io.write("Pilih: ")
  local input = io.read()
  local choice = tonumber(input)

  if choice == 0 then
    os.exit(0)
  elseif choice and menu[choice] then
    menu[choice].action()
  else
    print("Pilihan tidak valid.")
    os.execute("sleep 1")
  end
end
