#!/bin/bash
# Author: wrfly
# Date: 2016-5-14

function convert(){
	FROM=${1}
	TO=${2}
	AMOUNT=${3}

	curl 'http://www.huilvda.com/huansuancx.asp'\
		-H 'Host: www.huilvda.com' \
		--data "TheNum=$AMOUNT&TheFrom=${FROM}&TheTo=${TO}" \
		&> /dev/null

	AMOUNT=`echo $AMOUNT | tr \. \_`
	curl -sS "http://www.huilvda.com/${FROM}to${TO}/${AMOUNT}/" | \
			iconv -f gbk -t utf8 | \
			grep description | \
			sed 's/.*:\(.*\)".*/\1/g'
}

# check
function check(){
	STRING_A='AUD-KRW-CAD-MOP-CHF-MYR-CNY-NOK-DKK-NZD-EUR-PHP-GBP-RUB-HKD-SEK-IDR-SGD-JPY-THB-TWD-USD-'
	STRING_B=$1

	STRING_B=`echo $STRING_B|tr a-z A-Z`-

	if [[ ${STRING_A/${STRING_B}} == $STRING_A ]];then
	    ## is not substring.
	    return 1
	else
	    ## is substring.
	    return 0
	fi
}

function wrong(){
	echo "Wrong input, please check."
	exit
}

function main(){
	echo """
  AUD - 澳大利亚元	KRW - 韩元
  CAD - 加拿大元	MOP - 澳门元
  CHF - 瑞士法郎	MYR - 马来西亚林吉特
  CNY - 人民币		NOK - 挪威克朗
  DKK - 丹麦克朗	NZD - 新西兰元
  EUR - 欧元		PHP - 菲律宾比索
  GBP - 英镑		RUB - 俄罗斯卢布
  HKD - 港币		SEK - 瑞典克朗
  IDR - 印尼卢比	SGD - 新加坡元
  JPY - 日元		THB - 泰铢
  TWD - 台币		USD - 美元
	"""
	read -p "From(default USD):" FROM
	check $FROM || wrong
	read -p "To(default CNY):" TO
	check $TO || wrong
	read -p "Amount:" AMOUNT
	AMOUNT=${AMOUNT:-1}
	[[ "$AMOUNT" =~ ^[0-9]+(\.[0-9]+)?$ ]] || wrong
	convert ${FROM:-USD} ${TO:-CNY} ${AMOUNT:-1}
}

main
