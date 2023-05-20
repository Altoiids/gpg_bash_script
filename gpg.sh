#!/bin/bash
echo "install git and gnpug before starting"

generate_key() {
      gpg --full-generate-key
      gpg --list-secret-keys --keyid-format LONG
      key_id=$(gpg --list-keys --keyid-format LONG | grep '/' | tail -n 1 | awk -F'/' '{print $2}' | awk -F' ' '{print $1}')
      echo "$key_id"
      gpg --armor --export "$key_id"
      echo "copy from begin to end of public key block and paste it in the new gpg key in your github account"

}

sign_key() {
      read -rp "enter your username FOR-SETTING-GLOBAL-VARIABLES: " name
      
      read -rp "enter your emailid FOR-SETTING-GLOBAL-VARIABLES: " email
      git config --global user.name "$name"
      git config --global user.email "$email"
      git config --global user.signingkey "$key"
      git config --global commit.gpgsign true
      git config --global tag.gpgsign true
}

new_key() {
generate_key
echo "do you want to use this key for signing? if yes press 1 else press 0"
      read -r cont
      if [ "$cont" -eq 1 ]; then
        sign_key
      else
        exit 0
      fi 
}

reuse_key() {
gpg --list-secret-keys --keyid-format LONG
      
      read -rp "sec   rsa4096/YOUR-KEY-ID 2020-06-18 [SC] you will see a line in this format kindly enter YOUR-KEY-ID: " keyreuse
      gpg --armor --export "$keyreuse"
      echo "copy from begin to end of public key block and paste it in the new gpg key in your github account"
}
output=$(gpg --list-secret-keys 2>&1)

if [[ $output == *"sec "* ]]; then
  echo "If you want to use an existing key for signing, press1. If you want to create a new key to signin, press 2.  If want to delete a key press 3 else press any other other key"

    read -r input
    if [ "$input" -eq 1 ]; then

      reuse_key

      echo "do you want to use this key for signing? if yes press 1 else press 0"
      sign_key
      

    elif [ "$input" -eq 2 ]; then
      echo "Generating a new key..."
      new_key
     

    elif [ "$input" -eq 3 ]; then
        gpg --list-secret-keys --keyid-format=long
        echo "sec   rsa4096/YOUR-KEY-ID 2020-06-18 [SC] you will see a line in this format kindly enter YOUR-KEY-ID"
        read -r key_ID
        gpg --delete-secret-key "$key_ID"
        gpg --delete-key "$key_ID"
    else
      exit 0
    fi

else
  echo "No GPG keys found. Generating ..."
  new_key
      

  
fi
