# Проверка на отсутствие pdb в python файлах
rg -q 'pdb' (git diff --cached --name-only '*.py')
if test $status -eq 0
    set_color red
    echo "There is pdb in files! Remove it and try commit again."
    set_color normal
    exit 1
end
