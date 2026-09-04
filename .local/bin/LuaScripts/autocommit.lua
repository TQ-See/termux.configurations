-- Helper function untuk menjalankan perintah shell dan mengambil outputnya
local function capture(cmd)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    return s:gsub('%s+$', '') -- Hapus trailing whitespace/newline
end

-- Fungsi helper untuk commit per file dengan pesan diff
local function commit_file_with_diff(f, sys_msg, timestamp)
    -- Ambil data diff mentah
    local raw_diff = capture(string.format('git diff --cached --unified=0 --no-color -- "%s"', f))
    
    -- Filter baris diff (Menggantikan fungsi 'sed' pada script Bash)
    local diff_lines = {}
    for line in raw_diff:gmatch("[^\r\n]+") do
        if not line:match("^diff %-%-git ") and
           not line:match("^index ") and
           not line:match("^%-%-%- ") and
           not line:match("^%+%+%+ ") and
           not line:match("^@@ ") then
            table.insert(diff_lines, line)
        end
    end
    local diff = table.concat(diff_lines, "\n")

    -- Buat file temporary untuk pesan commit
    local tmp_name = os.tmpname()
    local msgfile = io.open(tmp_name, "w")
    if msgfile then
        msgfile:write(string.format("%s - %s\n\n", sys_msg, timestamp))
        msgfile:write(string.format("Update file: %s\n\n", f))
        msgfile:write("Changes:\n")
        msgfile:write(diff .. "\n")
        msgfile:close()
        
        -- Jalankan commit menggunakan file temporary
        os.execute(string.format('git commit -F "%s"', tmp_name))
        os.remove(tmp_name) -- Hapus file temporary
    end
end

-- ─── Main Logic ──────────────────────────────────────────────────────────────

local dir = "."
local timestamp = os.date("%Y-%m-%d %H:%M")

-- Mengambil argumen dari command line (arg[1] dan arg[2])
local sys_msg = (arg[1] and arg[1] ~= "") and arg[1] or "Update via Auto Commit"
local current_branch = capture(string.format('git -C "%s" branch --show-current 2>/dev/null', dir))
local target_branch = (arg[2] and arg[2] ~= "") and arg[2] or current_branch

-- Validasi apakah folder merupakan repositori git
if current_branch == "" then
    print("no git in this folder")
    os.exit(0)
end

-- Cek status perubahan
if capture("git status --porcelain") ~= "" then
    -- Ambil daftar file yang berubah
    local files_raw = capture("git diff --name-only")
    for f in files_raw:gmatch("[^\r\n]+") do
        if f ~= "" then
            os.execute(string.format('git add -- "%s"', f))
            commit_file_with_diff(f, sys_msg, timestamp)
        end
    end
    
    os.execute("git add .")
    
    -- Cek apakah masih ada sisa perubahan di stage area
    local has_cached = capture("git diff --cached --name-only") ~= ""
    if has_cached then
        os.execute(string.format('git commit -m "%s | %s"', timestamp, sys_msg))
    end
    
    -- Sleep 0.1 detik (menggunakan perintah sistem POSIX)
    os.execute("sleep 0.1")
    
    print(string.format("✅ Changes commited to %s dengan pesan: %s", target_branch, sys_msg))
else
    print(string.format("⚡ Tidak ada perubahan di %s.", dir))
end
