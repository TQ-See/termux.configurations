function cleanhome --description 'Bersihkan cache lokal'
    rm -rf ~/.cache/* $PREFIX/tmp/* 2>/dev/null
    echo "Cache lokal dibersihkan ✅"
end
