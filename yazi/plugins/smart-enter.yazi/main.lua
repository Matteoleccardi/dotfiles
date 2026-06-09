-- 1. Synchronously check if the hovered item is a directory
local get_is_dir = ya.sync(function()
    local h = cx.active.current.hovered
    if h then
        -- Safety check for Yazi API versions
        return type(h.cha.is_dir) == "function" and h.cha:is_dir() or h.cha.is_dir
    end
    return nil
end)

-- 2. Main async entry point
local function entry()
    local is_dir = get_is_dir()

    -- If nothing is highlighted, do nothing
    if is_dir == nil then
        return
    end

    if is_dir then
        -- If it's a folder, step inside (same behavior as Right Arrow)
        ya.emit("enter", {})
    else
        -- If it's a file, open it using Yazi's default program logic
        ya.emit("open", {})
    end
end

return { entry = entry }
