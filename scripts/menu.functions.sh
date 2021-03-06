#!/bin/bash

# openMenuIfCancelled
openMenuIfCancelled() {
pressed=$1
case $pressed in
  1)
    clear
    echo "Cancelled"
    echo "Returning to the menu..."
    sleep 1
    /home/joinmarket/menu.sh
    exit 1;;
  255)
    clear
    echo "ESC pressed."
    echo "Returning to the menu..."
    sleep 1
    /home/joinmarket/menu.sh
    exit 1;;
esac
}

# write password into a file (to be shredded)
passwordToFile() {
# get password
data=$(tempfile 2>/dev/null)
# trap it
trap "rm -f $data" 0 1 2 5 15
dialog --backtitle "Enter password" \
       --title "Enter password" \
       --insecure \
       --passwordbox "Type or paste the wallet decryption password" 8 52 2> $data
# make decison
pressed=$?
case $pressed in
  0)
    touch /home/joinmarket/.pw
    chmod 600 /home/joinmarket/.pw
    cat $data | tee /home/joinmarket/.pw 1>/dev/null
    shred $data;;
  1)
    shred $data
    shred $wallet
    rm -f .pw
    echo "Cancelled"
    exit 1;;
  255)
    shred $data
    shred $wallet
    rm -f .pw
    [ -s $data ] &&  cat $data || echo "ESC pressed."
    exit 1;;
esac
}

# chooseWallet
chooseWallet() {
wallet=$(tempfile 2>/dev/null)
dialog --backtitle "Choose a wallet" \
--title "Choose a wallet by typing the full name of the file" \
--fselect "/home/joinmarket/.joinmarket/wallets/" 10 60 2> $wallet
openMenuIfCancelled $?
}
