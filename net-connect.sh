ip_identifier="6"

# accept arguments
function wireless {
    access_point="$1"
    disconnect="$2"
    echo $access_point > test
    # returns the access point name
    available=$(wicd-cli -l --wireless | grep -i $access_point  | awk '{ print $4 }')

    if [[ $access_point == $available ]]; then
        # Find number and connect or disconnect
        number=$(wicd-cli -l --wireless | grep -i $access_point  | awk '{ print $1 }')

        if [[ $disconnect != true ]]; then
            wicd-cli --wireless -n $number -c
        else
            wicd-cli --wireless -n $number -x
        fi

    fi
}

for x in "$@"; do
    if [[ $x == "-d" ]]; then
        disconnect=true
    fi
done


access_point="2945"
if [[ $!
    wireless $access_point $disconnect

