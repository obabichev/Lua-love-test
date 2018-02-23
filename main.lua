Object = require 'lib/classic/classic'
Input = require 'lib/boipushy/input'
Timer = require 'lib/hump/timer'

function love.load()
    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)

    timer = Timer()

    input = Input()
    input:bind('mouse1', 'test')

    circle = HyperCircle(400, 300, 50, 10, 120)
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

function love.update(dt)
    timer:update(dt)
    if input:pressed('test') then print('Mouse1 click') end
end

function love.draw()
    circle:draw()
end
