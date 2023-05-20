#!/bin/bash
if which gnupg >/dev/null; then
    echo "Installed"
else
    echo "Not installed"


fi

if which git >/dev/null
then
    echo "Git is Installed"
else
 echo "Git is not install"

fi


output=$(gpg --list-secret-keys 2>&1)

if [[ $output == *"sec "* ]]; then
  echo "If you want to use an existing key for signing, press1. If you want to create a new key to signin, press 2.  If want to delete a key press 3 else press any other other key"

    read -r input
    if [ "$input" -eq 1 ]; then

      gpg --list-secret-keys --keyid-format LONG
      echo "sec   rsa4096/YOUR-KEY-ID 2020-06-18 [SC] you will see a line in this format kindly enter YOUR-KEY-ID"
      read -r key
      gpg --armor --export $key
      echo "copy from begin to end of public key block and paste it in the new gpg key in your github account"
      echo "enter your username"
      read -r name
      echo "enter your emailid"
      read -r email
      git config --global user.name "$name"
      git config --global user.email "$email"
      git config --global user.signingkey "$key"
      git config --global commit.gpgsign true
      git config --global tag.gpgsign true
      echo "Type where gpg in cmd you will get the gpg key location as the output. Run this command git config --global gpg.program YOUR-PR"

    elif [ "$input" -eq 2 ]; then
      echo "Generating a new key..."
      gpg --full-generate-key
      gpg --list-secret-keys --keyid-format LONG
      echo "sec   rsa4096/YOUR-KEY-ID 2020-06-18 [SC] you will see a line in this format kindly enter YOUR-KEY-ID"
      read -r key
      gpg --armor --export $key
      echo "copy from begin to end of public key block and paste it in the new gpg key in your github account"
      echo "enter your username"
      read -r name
      echo "enter your emailid"
      read -r email
      git config --global user.name "$name"
      git config --global user.email "$email"
      git config --global user.signingkey "$key"
      git config --global commit.gpgsign true
      git config --global tag.gpgsign true
      echo "Type where gpg in cmd you will get the gpg key location as the output. Run this command git config --global gpg.program YOUR-GP"

    elif [ "$input" -eq 3 ]; then
        gpg --list-secret-keys --keyid-format=long
        echo "Enter the key ID of the key to be deleted"
        read -r key_ID
        gpg --delete-secret-key "$key_ID"
        gpg --delete-key "$key_ID"
    else
      exit 0
    fi

else
  echo "No GPG keys found. Generating ..."
  gpg --full-generate-key
  gpg --list-secret-keys --keyid-format LONG
  echo "sec   rsa4096/YOUR-KEY-ID 2020-06-18 [SC] you will see a line in this format kindly enter YOUR-KEY-ID if you want to use it for sig"  
read -r key
  if [ "$key" -eq 0 ]; then
        exit 0
  else
      gpg --armor --export $key
      echo "copy from begin to end of public key block and paste it in the new gpg key in your github account"
      echo "enter your username"
      read -r name
      echo "enter your emailid"
      read -r email
      git config --global user.name "$name"
      git config --global user.email "$email"
      git config --global user.signingkey "$key"
      git config --global commit.gpgsign true
      git config --global tag.gpgsign true
      echo "Type where gpg in cmd you will get the gpg key location as the output. Run this command git config --global gpg.program YOUR-GP"

  fi
fi
