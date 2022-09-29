#!/usr/bin/env bash

unread_mail=`notmuch count tag:unread`

echo 📭 "$unread_mail"
