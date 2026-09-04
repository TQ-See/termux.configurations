function update --wraps='pkg update && pkg upgrade' --description 'alias update=pkg update && pkg upgrade'
    pkg update && pkg upgrade $argv
end
