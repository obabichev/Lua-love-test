Object = require 'lib/classic/classic'
Input = require 'lib/boipushy/input'
Timer = require 'lib/hump/timer'

function love.load()
    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)

    timer = Timer()
    input = Input()

    current_room = nil
end

function love.update(dt)
    timer:update(dt)
    if current_room then current_room:update(dt) end
end

function love.draw()
    if current_room then current_room:draw() end
end

function gotoRoom(room_type, ...)
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