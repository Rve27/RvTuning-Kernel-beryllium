#!/bin/bash

# Copyright 2024 Purrr
# Github @sandatjepil

# Ini Pengaturan buat kirim ke supergroup (grup bertopik)
# Set 1 untuk Ya | 0 untuk Tidak
TG_SUPER=0

# Isi token BOT disini
TG_TOKEN=6884104326:AAGFvtewNQGplsEqViVyLwYocZg5c898StY

# isi ID channel atau grup
# Pastikan botnya sudah jadi admin
CHATID=2017003441
# kalo grupnya bertopic isi ini, kalo ngga kosongin aja
TOPICID=

#################################################
# BAGIAN INI JANGAN DISENTUH!!
#################################################
BOT_MSG_URL="https://api.telegram.org/bot$TG_TOKEN/sendMessage"
BOT_DEL_URL="https://api.telegram.org/bot$TG_TOKEN/deleteMessage"
BOT_BUILD_URL="https://api.telegram.org/bot$TG_TOKEN/sendDocument"

tg_post_msg(){
	if [ $TG_SUPER = 1 ]
	then
	    curl -s -X POST "$BOT_MSG_URL" \
	    -d chat_id="$CHATID" \
	    -d message_thread_id="$TOPICID" \
	    -d "disable_web_page_preview=true" \
	    -d "parse_mode=html" \
	    -d text="$1"
	else
	    curl -s -X POST "$BOT_MSG_URL" \
	    -d chat_id="$CHATID" \
	    -d "disable_web_page_preview=true" \
	    -d "parse_mode=html" \
	    -d text="$1"
	fi
}

tg_post_build()
{
	#Post MD5Checksum alongwith for easeness
	MD5CHECK=$(md5sum "$1" | cut -d' ' -f1)

	#Show the Checksum alongwith caption
	if [ $TG_SUPER = 1 ]
	then
	    curl -F document=@"$1" "$BOT_BUILD_URL" \
	    -F chat_id="$CHATID"  \
	    -F message_thread_id="$TOPICID" \
	    -F "disable_web_page_preview=true" \
	    -F "parse_mode=Markdown" \
	    -F caption="$2 | MD5 Checksum: \`$MD5CHECK\`"
	else
	    curl -F document=@"$1" "$BOT_BUILD_URL" \
	    -F chat_id="$CHATID"  \
	    -F "disable_web_page_preview=true" \
	    -F "parse_mode=Markdown" \
	    -F caption="$2 | MD5 Checksum: \`$MD5CHECK\`"
	fi
}

normal="\033[0m"
orange="\033[1;38;5;208m"
red="\033[1;31m"
green="\033[1;32m"

case "$1" in
  file)
    tg_post_build $2 $3 > /dev/null 2>&1
    echo "kirim file ke ID ${CHATID}"
    ;;
  msg)
    tg_post_msg $2 > /dev/null 2>&1
    echo "kirim pesan ke ID ${CHATID}"
    ;;
  help)
    echo "Cara Pemakaian:"
    echo "- Untuk kirim file"
    echo "${green}kirimtele.sh file namafile caption${normal}"
    echo "- Untuk kirim pesan"
    echo "${green}kirimtele.sh msg caption${normal}"
    ;;
  *)
    echo "command tidak ditemukan"
    echo "ketik ${green}kirimtele.sh help${normal}"
    echo "untuk cara penggunaan"
    ;;
esac
#################################################
# BAGIAN INI JANGAN DISENTUH!!
#################################################