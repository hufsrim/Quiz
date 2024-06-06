#!/bin/bash

WHITEPAGES_FILE="whitepages.txt"

declare -A REGION_CODES
REGION_CODES=(
  ["02"]="서울"
  ["031"]="경기"
  ["032"]="인천"
  ["051"]="부산"
  ["053"]="대구"
  ["062"]="광주"
)

read_whitepages() {
  if [[ ! -f $WHITEPAGES_FILE ]]; then
    touch $WHITEPAGES_FILE
  fi
  cat $WHITEPAGES_FILE
}

write_whitepages() {
  echo -n "" > $WHITEPAGES_FILE
  for entry in "${whitepages[@]}"; do
    echo "$entry" >> $WHITEPAGES_FILE
  done
}

validate_phone() {
  local phone=$1
  if [[ $phone =~ ^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$ ]]; then
    return 0
  else
    return 1
  fi
}

get_region() {
  local phone=$1
  local area_code=${phone%%-*}
  echo "${REGION_CODES[$area_code]:-Unknown}"
}

main() {
  if [[ $# -ne 2 ]]; then
    echo "Error: 두 개의 인수를 입력해야 합니다."
    exit 1
  fi

  local name=$1
  local phone=$2

  if ! validate_phone "$phone"; then
    echo "Error: 전화번호 형식이 잘못되었습니다. 예: 02-2222-2222"
    exit 2
  fi

  local region=$(get_region "$phone")

  if [[ "$region" == "Unknown" ]]; then
    echo "Error: 올바른 지역을 인식할 수 없습니다."
    exit 3
  fi

  IFS=$'\n' read -d '' -r -a whitepages < <(read_whitepages)
  local found=0

  for i in "${!whitepages[@]}"; do
    IFS=' ' read -r -a entry <<< "${whitepages[i]}"
    if [[ "${entry[0]}" == "$name" ]]; then
      found=1
      if [[ "${entry[1]}" == "$phone" && "${entry[2]}" == "$region" ]]; then
        echo "$name님은 이미 등록되어 있습니다: $phone $region"
        exit 0
      else
        echo "$name님의 정보를 업데이트합니다: ${entry[1]} ${entry[2]} -> $phone $region"
        whitepages[i]="$name $phone $region"
      fi
    fi
  done

  if [[ $found -eq 0 ]]; then
    whitepages+=("$name $phone $region")
  fi

  whitepages=($(printf "%s\n" "${whitepages[@]}" | sort))
  write_whitepages

  echo "$name님을 전화번호부에 추가했습니다: $phone ($region)"
}

main "$@"
