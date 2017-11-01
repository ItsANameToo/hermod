if tail -n 3 ./log.log | grep -q "Blockchain not ready to receive block"; then
    echo "fugs"
fi
