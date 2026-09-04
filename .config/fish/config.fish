set fish_greeting

function dorong_prompt_ke_bawah --on-event fish_prompt
    tput cup $LINES 0
end

if status is-interactive

end

