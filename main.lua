Object = require 'lib/classic/classic'
Input = require 'lib/boipushy/input'
Timer = require 'lib/hump/timer'
Camera = require 'lib/hump/camera'
Physics = require 'lib/windfield/windfield/init'
Draft = require('lib/draft/draft')
require('lib/vector/Vector')

function love.load()
    love.graphics.setDefaultFilter('nearest')

    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)

    resize(2)

    timer = Timer()
    input = Input()
    camera = Camera()
    draft = Draft()

    current_room = Stage()

    input:bind('left', 'left')
    input:bind('right', 'right')
    input:bind('up', 'up')
    input:bind('down', 'down')
    input:bind('p', 'p')

    input:bind('f1', function()
        print("Before collection: " .. collectgarbage("count") / 1024)
        collectgarbage()
        print("After collection: " .. collectgarbage("count") / 1024)
        print("Object count: ")
        local counts = type_count()
        for k, v in pairs(counts) do print(k, v) end
        print("-------------------------------------")
    end)

    slow_amount = 1
    flashInit()
end

function love.update(dt)
    timer:update(dt * slow_amount)
    camera:update(dt * slow_amount)
    if current_room then current_room:update(dt * slow_amount) end
end

function love.draw()
    if current_room then current_room:draw() end

    flashDraw()
end

function gotoRoom(room_type, ...)
    if current_room and current_room.destroy then current_room:destroy() end
    current_room = _G[room_type](...)
end

function requireFiles(files)
    for _, file in ipairs(files) do
        print(file)
        local file = file:sub(1, -5)
        require(file)
    end
end

function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file, file_list)
        end
    end
end

function resize(s)
    love.window.setMode(s * gw, s * gh)
    sx, sy = s, s
end

-- Function for garbage collection
function count_all(f)
    local seen = {}
    local count_table
    count_table = function(t)
        if seen[t] then return end
        f(t)
        seen[t] = true
        for k, v in pairs(t) do
            if type(v) == "table" then
                count_table(v)
            elseif type(v) == "userdata" then
                f(v)
            end
        end
    end
    count_table(_G)
end

function type_count()
    local counts = {}
    local enumerate = function(o)
        local t = type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    count_all(enumerate)
    return counts
end

global_type_table = nil
function type_name(o)
    if global_type_table == nil then
        global_type_table = {}
        for k, v in pairs(_G) do
            global_type_table[v] = k
        end
        global_type_table[0] = "table"
    end
    return global_type_table[getmetatable(o) or 0] or "Unknown"
end
