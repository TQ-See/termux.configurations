math.randomseed(os.time())
local secretNumber = math.random(1, 100)
local attempts = 0

print("Guess the number between 1 and 100!")
print("Enter q for Exit")

while true do -- Loop selamanya sampai di-break
    -- 1. Baca input sebagai string dulu (jangan langsung tonumber)
    local raw_input = input() -- use input() insted of io.read
    local guess = tonumber(raw_input) 
    
    -- 2. Cek apakah user mau keluar
    if raw_input == "q" then
        print("Halah.. payah 😮‍💨")
        break
    elseif guess then
        attempts = attempts + 1
        if guess < secretNumber then
            print(guess .. " is too low!")
        elseif guess > secretNumber then
            print(guess .. " is too high!")
        else
            print("Congratulations! You guessed the number " .. guess .. " in " .. attempts .. " attempts.")
            break
        end
    else
        print("Please enter a valid number.")
    end
end

    
