a=$(date +%s)
b=$(stat -t fake.log | awk '{print $1}')

echo "current $a"
echo "logfile $b"
# echo $(($a - $b))

if [[ $(expr `date +%s` - `stat -c %Y fake.log`) -gt 900 ]]; then
    echo "older then 15 minutes"
fi
