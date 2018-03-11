function slow(amount, duration)
    print("slow.lua<slow> amount: " .. amount)

    slow_amount = amount
    timer:tween(duration, _G, { slow_amount = 1 }, 'in-out-cubic')
end