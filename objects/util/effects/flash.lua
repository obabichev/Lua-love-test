function flash(frames)
    flash_frames = frames
end

function flashInit()
    flash_frames = nil
end

function flashDraw()
    if flash_frames then
        flash_frames = flash_frames - 1
        if flash_frames == -1 then flash_frames = nil end
    end
    if flash_frames then
        love.graphics.setColor(background_color)
        love.graphics.rectangle('fill', 0, 0, sx * gw, sy * gh)
        love.graphics.setColor(255, 255, 255)
    end
end