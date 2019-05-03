#!/bin/sh
BASEDIR="$(cd "$(dirname "$0")"; pwd -P)"
echo "${BASEDIR}"

echo "請輸入要找尋的第一個資料夾 or 離開輸入 /exit to quit"
read -p "folder ticket one Name: " FOLDER_TICKET_ONE_NAME
if [[ "$FOLDER_TICKET_ONE_NAME" == "/exit" ]]; then
	exit 1;
fi

if [ ! -e "$FOLDER_TICKET_ONE_NAME" ]; then
	echo "我找不到任何資料夾。"
	exit 1;
fi

echo "請輸入第一個資料夾內的檔案名稱前綴字 or 離開輸入 /exit to quit"
read -p "ticket one file Name: " TICKET_ONE_FILE_NAME_PREFIX_WORD
if [[ "$TICKET_ONE_FILE_NAME_PREFIX_WORD" == "/exit" ]]; then
	exit 1;
fi



LOCATION1="$FOLDER_TICKET_ONE_NAME"
FILECOUNT1=0

for item in $LOCATION1/*
do
	if [ -f "$item" ]
		then

			FILE_ONE_NAME=$FOLDER_TICKET_ONE_NAME/$TICKET_ONE_FILE_NAME_PREFIX_WORD$(printf "%05d" $[$FILECOUNT1+1]).pdf

			if [[ $item != $FILE_ONE_NAME ]]; then
				echo 'file name is different'
				exit 1;
			fi

			FILECOUNT1=$[$FILECOUNT1+1]
			array1[$FILECOUNT1]=$TICKET_ONE_FILE_NAME_PREFIX_WORD$(printf "%05d" $FILECOUNT1).pdf
	fi
done


echo "請輸入要找尋的第二個資料夾 or 離開輸入 /exit to quit"
read -p "folder ticket two Name: " FOLDER_TICKET_TWO_NAME
if [[ "$FOLDER_TICKET_TWO_NAME" == "/exit" ]]; then
	exit 1;
fi

if [ ! -e "$FOLDER_TICKET_TWO_NAME" ]; then
	echo "我找不到任何資料夾。"
	exit 1;
fi

echo "請輸入第二個資料夾內的檔案名稱前綴字 or 離開輸入 /exit to quit"
read -p "ticket two file Name: " TICKET_TWO_FILE_NAME_PREFIX_WORD
if [[ "$TICKET_TWO_FILE_NAME_PREFIX_WORD" == "/exit" ]]; then
	exit 1;
fi

LOCATION2="$FOLDER_TICKET_TWO_NAME"
FILECOUNT2=0

for item in $LOCATION2/*
do
	if [ -f "$item" ]
		then

			FILE_TWO_NAME=$FOLDER_TICKET_TWO_NAME/$TICKET_TWO_FILE_NAME_PREFIX_WORD$(printf "%05d" $[$FILECOUNT2+1]).pdf

			if [[ $item != $FILE_TWO_NAME ]]; then
				echo 'file name is different'
				exit 1;
			fi

			FILECOUNT2=$[$FILECOUNT2+1]
			array2[$FILECOUNT2]=$TICKET_TWO_FILE_NAME_PREFIX_WORD$(printf "%05d" $FILECOUNT2).pdf
	fi
done

echo "請輸入要產生or存在中的資料夾 or /exit to quit"
read -p "create folder file Name: " CREATE_FOLDER_FILE_NAME
if [[ "$CREATE_FOLDER_FILE_NAME" == "/exit" ]]; then
	exit 1;
fi

if [ ! -e "$CREATE_FOLDER_FILE_NAME" ]; then
	echo "create new folder !"
	mkdir $CREATE_FOLDER_FILE_NAME
fi

echo "請輸入每個檔案前綴字名稱 or 離開輸入 /exit"
read -p "input file Name prefix word: " FILE_NAME_PREFIX_WORD
if [[ "$FILE_NAME_PREFIX_WORD" == "/exit" ]]; then
	exit 1;
fi


echo "File One count: " $FILECOUNT1
echo "File TWO count: " $FILECOUNT2

if [[ "${FILECOUNT1}" != "${FILECOUNT2}" ]]; then
	echo 'data count different'
	exit 1;
fi

cd "../pdfbox"

for ((i=1; i<=$FILECOUNT1; i++))
do

	/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/java -jar \
	pdfbox-app-2.0.15.jar PDFMerger \
	"${BASEDIR}"/"${FOLDER_TICKET_ONE_NAME}"/"${array1[${i}]}" \
	"${BASEDIR}"/"${FOLDER_TICKET_TWO_NAME}"/"${array2[${i}]}" \
	"${BASEDIR}"/"${CREATE_FOLDER_FILE_NAME}"/"${FILE_NAME_PREFIX_WORD}"_$(printf "%05d" $i).pdf

	echo Merger ${array1[${i}]} ${array2[${i}]} $i
	echo "------------------------------------------------------------------------------------------------------------"

done

echo "The End \n"

echo "------------------------------------------------------------------------------------------------------------"
echo "folder name : $CREATE_FOLDER_FILE_NAME"
echo "file name prefix word : $FILE_NAME_PREFIX_WORD"
