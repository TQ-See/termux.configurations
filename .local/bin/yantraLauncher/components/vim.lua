local V = {}

function V.run()

  local Vim_chapters = {
  "Introduction",
  "PengenalanKodeVim",
  "Overview",
  "Environtment",
  "BasicSyntax",
  "Variable",
  "DataTypes",
  "Operators",
  "Loop",
  "DecissionMaking",
  "Functions",
  "Strings",
  "Arrays",
  "Iterators",
  "Tables",
  "Modules",
  "Metatables",
  "Coroutines",
  "fileInputOutput",
  "ErrorHandling",
  "debugging",
  "GarbageCollector",
  "ObjectOriented",
  "WebProgramming",
  "DatabaseAcceses",
  "GameProgramming",
  "StandarLibrary",
  "MathLibrary",
  "OperationSystem"
  }

  local BASE_PATH = "/storage/emulated/0/Documents/EbookLauncher/Vim_Ebook/"
  local HEADER = "====================================== START\n"

  -- ===============================
  -- Utils
  -- ===============================

  local function cmd(c)
    if binding and binding.exec then
      binding.exec(c)
    else
      os.execute(c)
    end
  end

  local function read_input(prompt)
    if prompt then io.write(prompt) end
    return io.read()
  end

  -- ===============================
  -- UI
  -- ===============================

  local function show_lists()
    print("\nSilakan pilih chapter:\n")
    for i, c in ipairs(Vim_chapters) do
      print(string.format("[%d] %s", i, c))
    end
    print("\n--------------------------------------------")
    print("---------------- [b] Back to Menu - [l] List")
  end

  local function show_cover()
    cmd("clear")
    print("================== Vim ===================")
    print("--------------------------------------------")
    print(" Selamat datang di Ebook pembelajaran Vim")
    show_lists()
  end

  -- ===============================
  -- File handling
  -- ===============================

  local function ensure_dir()
    os.execute("mkdir -p " .. BASE_PATH)
  end

  local function ensure_and_validate_file(path)
    ensure_dir()

    local f = io.open(path, "r")
    if f then
      f:close()
      return true
    end

    f = io.open(path, "w")
    if not f then
      print("❌ Tidak bisa membuat file.")
      return false
    end

    f:write(HEADER .. "\n")
    f:close()
    return true
  end

  local function read_file(path)
    local f = io.open(path, "r")
    if not f then
      print("❌ Gagal membuka ebook.")
      return
    end

    cmd("clear")
    print(f:read("*a"))
    f:close()

    print("\n--------------------------------------------")
    print("---------------- [b] Back to Menu - [l] List")
  end

  -- ===============================
  -- Main Loop
  -- ===============================

  show_cover()

  while true do
    local user_input = read_input("\n> ")

    if not user_input then
      print("❌ Input error")
      return
    end

    if user_input == "b" then
      return

    elseif user_input == "l" then
      show_cover()

    else
      local index = tonumber(user_input)

      if index and Vim_chapters[index] then
        local chapter = Vim_chapters[index]
        local file_path = BASE_PATH .. chapter .. ".txt"

        if ensure_and_validate_file(file_path) then
          read_file(file_path)
        end
      else
        print("⚠️ Invalid chapter!")
      end
    end
  end
end

return V
