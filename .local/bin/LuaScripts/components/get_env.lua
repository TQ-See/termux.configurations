local M = {}

function M.load(path, global)
    path = path or (os.getenv("HOME") .. "/.env/secrets.env")

    local env = {}

    for line in io.lines(path) do
        local key, value = line:match("^([%w_]+): (.*)$")
        if key then
            env[key] = value

            if global then
                _G[key] = value
            end
        end
    end

    return env
end

return M
