-- 1. Synchronously grab the hovered item and its properties
local get_hovered_info = ya.sync(function()
    local h = cx.active.current.hovered
    if h then
        local is_dir = type(h.cha.is_dir) == "function" and h.cha:is_dir() or h.cha.is_dir
        return tostring(h.url), is_dir
    end
    return nil, false
end)

-- 2. Debug Notification Helper
local function notify(msg, level)
    -- switch to "true" if you want to debug
    if false then
        ya.notify({
            title = "Shell-CWD Debug",
            content = tostring(msg),
            level = level or "info",
            timeout = 2
        })
    end
end

-- 3. Main async entry point
local function entry()
    local success, err = pcall(function()
        notify("Plugin triggered!", "info")

        local url, is_dir = get_hovered_info()

        if not url then
            notify("Nothing highlighted!", "warn")
            return
        end

        notify("Hovered: " .. url .. " | Is Directory: " .. tostring(is_dir), "info")

        if is_dir then
            local cwd_file = os.getenv("YAZI_CWD_FILE")
            
            if cwd_file then
                notify("Found Bash temp file: " .. cwd_file, "info")
                
                local f = io.open(cwd_file, "w")
                if f then
                    f:write(url)
                    f:close()
                    notify("Path written. Exiting Yazi...", "info")
                else
                    notify("Failed to open temp file for writing!", "error")
                end
                
                -- Exclusively using the new ya.emit syntax
                ya.emit("quit", { ["no-cwd-file"] = true })
            else
                notify("No YAZI_CWD_FILE found in env. Falling back...", "warn")
                ya.emit("enter", {})
                ya.emit("quit", {})
            end
        else
            notify("Item is a file. Emitting normal open...", "info")
            ya.emit("open", {})
        end
    end)

    if not success then
        notify("CRASH: " .. tostring(err), "error")
    end
end

return { entry = entry }
