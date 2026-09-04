package.path = package.path .. ";" .. os.getenv("HOME") .. "/.local/bin/LuaScripts/components/?.lua"

-- ================= KONFIGURASI =================
require("get_env").load(nil, true)
local api_key = GEMINI_API

if not api_key then
    print("[Error]: API Key tidak ditemukan di secrets.env")
    os.exit()
end

local model_name = "gemini-3.1-flash-lite" 
local endpoint = "https://generativelanguage.googleapis.com/v1beta/models/" .. model_name .. ":generateContent?key=" .. api_key

-- FILE PATHS (Gunakan Absolute Path untuk tmp.json agar aman dieksekusi dari folder manapun)
local base_dir = "/data/data/com.termux/files/home/.local/share/json"
local history_file = base_dir .. "/chat_history.json"
local payload_file = base_dir .. "/payload.json"
local response_file = base_dir .. "/response.json"
local tmp_file = base_dir .. "/tmp.json"

local system_prompt = "Jawablah selalu menggunakan paragraf yang singkat dan to the point. Hindari pembahasan yang bertele-tele dan penggunaan daftar (bullet points/numbering) kecuali benar-benar dibutuhkan secara eksplisit. Gunakan bahasa Indonesia yang santai tapi jelas."

-- ================= FUNGSI BANTUAN =================
local function shell_exec(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return result:gsub("^%s*(.-)%s*$", "%1")
end

-- Fungsi penting untuk mengamankan string dari injeksi Bash
local function escape_sh(s)
    return "'" .. string.gsub(s, "'", "'\\''") .. "'"
end

-- ================= LOGIKA UTAMA =================
local f = io.open(history_file, "r")
if not f then
    os.execute("echo '[]' > " .. escape_sh(history_file))
else
    local content = f:read("*a")
    -- Cegah error jq jika file kosong atau korup
    if content == "" or not content:match("%[") then
        os.execute("echo '[]' > " .. escape_sh(history_file))
    end
    f:close()
end

local user_message = arg[1]
if not user_message or user_message == "" then 
    print("Gunakan: geminiyantra \"pesan anda\" atau \"rechat\" atau \"reset\"")
    os.exit() 
end

local cmd_lower = string.lower(user_message)
if cmd_lower == "reset" then
    os.execute("echo '[]' > " .. escape_sh(history_file))
    print("[System]: Riwayat percakapan telah dihapus.")
    os.exit()
end

if cmd_lower == "rechat" then
    print("\n--- MEMUAT RIWAYAT PERCAKAPAN ---\n")
    local cmd_rechat = string.format(
        "jq -r '.[] | if .role == \"user\" then \"\\n[You] :\" else \"\\n[Gemini] :\" end, .parts[0].text' %s", 
        escape_sh(history_file)
    )
    local history_log = shell_exec(cmd_rechat)
    
    if history_log == "" then
        print("[System]: Belum ada riwayat chat.")
    else
        print(history_log)
        print("\n---------------------------------")
        print("[End of History]")
    end
    os.exit()
end

-- 2. Update History (User)
local cmd_update_user = string.format(
    "jq --arg txt %s '. += [{\"role\": \"user\", \"parts\": [{\"text\": $txt}]}]' %s > %s && mv %s %s", 
    escape_sh(user_message), escape_sh(history_file), escape_sh(tmp_file), escape_sh(tmp_file), escape_sh(history_file)
)
os.execute(cmd_update_user)

-- 3. Siapkan Payload
local cmd_payload = string.format(
    "jq --arg inst %s '{systemInstruction: {parts: [{text: $inst}]}, contents: .}' %s > %s",
    escape_sh(system_prompt), escape_sh(history_file), escape_sh(payload_file)
)
os.execute(cmd_payload)

-- 4. Kirim Request (Gunakan -sS di CURL agar pesan error network tidak disembunyikan total)
local cmd_curl = string.format(
    "curl -sS -X POST %s -H 'Content-Type: application/json' -d @%s > %s",
    escape_sh(endpoint), escape_sh(payload_file), escape_sh(response_file)
)
os.execute(cmd_curl)

-- 5. Ambil Jawaban & Token dengan jq
local answer = shell_exec("jq -r '.candidates[0].content.parts[0].text // empty' " .. escape_sh(response_file))
local token_count = shell_exec("jq -r '.usageMetadata.totalTokenCount // 0' " .. escape_sh(response_file))
local error_msg = shell_exec("jq -r '.error.message // empty' " .. escape_sh(response_file))

-- 6. Tampilkan Hasil
if error_msg ~= "" then
    print("\n[Error]: " .. error_msg)
elseif answer == "" then
    print("\n[Error]: Tidak ada respon dari API. (Cek koneksi internet, kuota API, atau payload)")
else
    print("Gemini :")
    print(answer)
    print("") 
    print("[Realtime Token: " .. token_count .. "]")

    -- 7. Simpan Jawaban
    local cmd_update_model = string.format(
        "jq --arg txt %s '. += [{\"role\": \"model\", \"parts\": [{\"text\": $txt}]}]' %s > %s && mv %s %s",
        escape_sh(answer), escape_sh(history_file), escape_sh(tmp_file), escape_sh(tmp_file), escape_sh(history_file)
    )
    os.execute(cmd_update_model)
end
