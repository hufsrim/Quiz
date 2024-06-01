#!/bin/bash

if [ "$#" -ne 3 ]; then
  echo "입력값 오류"
  exit 1
fi

month=$1
day=$2
year=$3

month=$(echo "$month" | tr '[:lower:]' '[:upper:]' | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')

case $(echo "$month" | tr '[:upper:]' '[:lower:]') in
  jan | january | 1)
    month="Jan";;
  feb | february | 2)
    month="Feb";;
  mar | march | 3)
    month="Mar";;
  apr | april | 4)
    month="Apr";;
  may | 5)
    month="May";;
  jun | june | 6)
    month="Jun";;
  jul | july | 7)
    month="Jul";;
  aug | august | 8)
    month="Aug";;
  sep | september | 9)
    month="Sep";;
  oct | october | 10)
    month="Oct";;
  nov | november | 11)
    month="Nov";;
  dec | december | 12)
    month="Dec";;
  *)
    echo "월(month) 입력값 오류: $month는 유효하지 않습니다"
    exit 1;;
esac

is_leap_year() {
  if [ $(($1 % 4)) -ne 0 ];
  then
    echo 0
  elif [ $(($1 % 400)) -eq 0 ];
  then
    echo 1
  elif [ $(($1 % 100)) -eq 0 ];
  then
    echo 0
  else
    echo 1
  fi
}

leap_year=$(is_leap_year $year)

case $month in
  Jan | Mar | May | Jul | Aug | Oct | Dec)
    max_day=31;;
  Apr | Jun | Sep | Nov)
    max_day=30;;
  Feb)
    if [ "$leap_year" -eq 1 ];
    then
      max_day=29
    else
      max_day=28
    fi
    ;;
esac

if ! [[ "$day" =~ ^[0-9]+$ ]];
then
  echo "일(date) 입력값 오류: $day는 유효하지 않습니다"
  exit 1
fi

if [ "$day" -lt 1 ] || [ "$day" -gt "$max_day" ];
then
  echo "일(date) 범위 오류: $month $day $year는 유효하지 않습니다"
  exit 1
fi

echo "$month $day $year"
