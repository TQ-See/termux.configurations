-- 1) Your recurring tasks
local DAILY_TASKS = {
  "Feed dogs",
  "Feed Cats",
  "Vacuum"
}

-- 2) Where to store last-run date
local STATE_FILE = "/storage/emulated/0/Documents/daily_todo_state.txt"

-- 3) Helper: run a Yantra command from Lua
local function run_cmd(cmd)
  if binding and binding.exec then
    -- Use Yantra's built-in binding module
    binding.exec(cmd)
  else
    -- Fallback (e.g. if you ever run this in Termux Lua)
    os.execute(cmd)
  end
end

-- 4) Get today's date string (YYYY-MM-DD)
local function today_str()
  return os.date("%Y-%m-%d")
end

-- 5) Read last date we generated tasks
local function read_last_date()
  local f = io.open(STATE_FILE, "r")
  if not f then return nil end
  local line = f:read("*l")
  f:close()
  return line
end

-- 6) Save today's date as last-run
local function write_last_date(d)
  local f, err = io.open(STATE_FILE, "w")
  if not f then
    print("Error saving state file: " .. tostring(err))
    return
  end
  f:write(d .. "\n")
  f:close()
end

-- 7) Actually create the TODO items
local function create_daily_todos()
  for _, task in ipairs(DAILY_TASKS) do
    -- Adjust this if your todo syntax is different
    local cmd = string.format('todo add "%s"', task)
    print("Running: " .. cmd)
    run_cmd(cmd)
  end
end

-- 8) Main logic
local today  = today_str()
local before = read_last_date()

if before == today then
  print("Daily TODOs already created for " .. today)
else
  print("Creating daily TODOs for " .. today .. "...")
  create_daily_todos()
  write_last_date(today)
  print("Done.")
end
