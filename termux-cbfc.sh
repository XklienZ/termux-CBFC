#!/data/data/com.termux/files/usr/bin/bash

#https://github.com/Xklienz
#https://facebook.com/XklienZ
#https://instagram.com/XklienZ

dft="\e[0m"
red="\e[31m"
lred="\e[1;31m"
yellow="\e[33m"
lyellow="\e[1;33m"
blue="\e[34m"
lblue="\e[1;34m"
cyan="\e[36m"
lcyan="\e[1;36m"
lwhite="\e[1;37m"
THOME="/data/data/com.termux/files/home"
Verror="\e[31mKESALAHAN\e[37m: "
TERM_RELOAD="am broadcast --user 0 -a com.termux.app.reload_style com.termux"
SGTR="a399fb4fc84eb9ee714e9a5cb045815cf019208ea9770908871a501052aa265b"
SIGNAL_EXIT()
{
	echo -e "\e[0m\e[25?h"
	stty echo eof ^D rprnt ^R
	exit 1
}

#XCheck termux user
if [ "$(uname -o)" == "Android" ]; then
	if su -c exit &> /dev/null; then
		if [ "$(whoami)" == "root" ]; then
			echo -e "\e[0;31mROOT TERDETEKSI\e[0m\n\e[0;37mTERMUX ANDA DALAM MODE ROOT, AGAR SKRIP INI BISA DIJALANKAN MOHON KELUAR DARI MODE ROOT.\e[0m"
			exit 1
		fi
	fi
else
	echo -e "\e[0;33mSKRIP INI HANYA UNTUK TERMUX.\e[0m"
	exit 1
fi

stty eof ^- rprnt ^-
trap SIGNAL_EXIT SIGTSTP
trap SIGNAL_EXIT SIGINT SIGQUIT SIGTERM SIGHUP

file-manager() {
	local nfile error maker_0 i permission permission2 givepermission typefile fromtc

	nfile="$1"
	typefile="$2"
	error=0
	local addopt=(-r -w $4)
	fromtc="$3"
	if [ $typefile "$nfile" ]; then
		fm_err=0
	else
		if [ "$fromtc" == "y" ]; then
			fm_err=1
			return 0
		else
			echo -e "$nfile: TIDAK DAPAT MENEMUKAN FILE/FOLDER"
			exit 1
		fi
	fi

	maker_0="$(stat -c %U $nfile)"

	if [ "$maker_0" == "root" ]; then
		echo -e "\e[0;33m \e[1;34m$nfile\e[0m \e[0;33mTERBUAT OLEH \e[0;31mROOT\e[0m \e[0;33mSKRIP INI TIDAK BISA MENGAKSESNYA\e[0m"
		exit 1
	fi

	for i in ${!addopt[@]}; do
		if [ ${addopt[$i]} $nfile ]; then
			:
		else
			 permission+="${addopt[$i]}"
			 error=$((error+1))
		fi
	done

	 permission2="$(echo "$permission" | sed "s/-//g")"
	 givepermission="chmod +$permission2 $nfile"

	if ((error > 0)); then
		echo -e "SKRIP INI TIDAK BISA MENGAKSES $nfile KARENA TIDAK ADA IZIN \e[0;32m$permission\e[0m\nBERIKAN IZIN AGAR SKRIP INI BISA MENGAKSESNYA."
		while :; do
			read -p "BERI IZIN y/n: " userpermission
			if [ "${userpermission,,}" == "y" ]; then
				if $givepermission 2> /dev/null; then
					echo -e "\e[0;32mBERHASIL\e[0m MEMBERI IZIN $permission PADA $nfile"
					break
				else
					echo -e "\e[0;31mGAGAL\e[0mL MEMBERI IZIN $permission PADA $nfile"
					break
				fi
			elif [ "${userpermission,,}" == "n" ]; then
				exit 0
			else
				echo -en "\e[1F\e[0J"
			fi
		done
	fi
}

Fprop()
{
	local i typef
	if [ "$2" == "-d" ]; then
		typef="-x"
	fi
	if [ $2 $3 ]; then
		file-manager "$3" "$2" "n" $typef
	else
		for  i in {0..3}; do
			if $1 2> /dev/null; then
				file-manager "$3" "$2" "n" $typef
				break
			fi

			if ((i==3)); then
				if [ $2 $3 ]; then
					file-manager "$3" "$2" "n" $typef
					break
				else
					echo -e "${Verror}GAGAL MEMBUAT $4\n$5"
					exit 1
				fi
			fi
		done
	fi
}

line-clear() {
	echo -e "\e[${1}F\e[0J"
}

TCsave()
{
	Fprop "mkdir $THOME/.termux"  "-d" "$THOME/.termux" "FOLDER .termux DI DIREKTORI $THOME" "KARENA ITU TIDAK BISA MENYIMPAN PERUBAHAN WARNA UNTUK BACKGROUND/FOREGROUND/CURSOR"
	Fprop "touch $filecolors" "-f" "$filecolors" "FILE colors.properties DI DIREKTORI $THOME/.termux" "KARENA ITU TIDAK BISA MENYIMPAN PERUBAHAN WARNA UNTUK BACKGROUND/FOREGROUND/CURSOR"

	if [ -z "$1" ] && [ -z "$2" ] && [ -z "$3" ]; then
		echo "#TEMA DEFAULT" > $filecolors
	else
		if ! echo -e "$1\n$2\n$3" > $filecolors 2> /dev/null; then
			echo -e "${Verror}GAGAL MENYIMPAN PEMBARUAN"
			exit 1
		fi
	fi
	$TERM_RELOAD > /dev/null
	return 0
}

TCHELP()
{
echo -en "\e[s\e[0m\e[25?lUntuk memilih warna, Pengguna bisa
memilihNya dengan angka atau nama
warna yang ada di menu skrip ini
contohNya: ${lblue}LightBlue${dft} atau ${lblue}lightblue${dft}
memilih warnaNya bisa menggunakan
Huruf Kapital atau huruf kecil.
Dan ini hanya mengganti warna
 -BACKGROUND
 -FOREGROUND
 -CURSOR
Di termux anda.
${lyellow}PERINGATAN !${dft}
SKRIP INI AKAN MENYIMPAN KODE
WARNA YANG SUDAH PENGGUNA
PILIH TADI KE FILE
~/.termux/colors.properties
JADI JIKA ANDA TIDAK INGIN KEHILANGAN
ISI FILE ITU, BACKUP ISI FILE ITU
TERLEBIH DAHULU.

REPORT TO \e[4;1;34mhttps://facebook.com/XklienZ$dft
\e[48;5;17mTEKAN ${lcyan}q${dft}\e[48;5;17m UNTUK KELUAR DARI SINI${dft}
"; read -sd q
echo -en "\e[25?h"
line-clear 23
}

TCsetmenu() {
	local nowpage="${lcyan}(${lwhite}$pcount${lcyan}/${lwhite}${maxpage}${lcyan})"
	if ((pcount < ${maxpage})); then
		nextcolor="n).WARNA SELANJUTNYA $nowpage"
		if ((pcount > 0)); then
			backcolor="k).WARNA SEBELUMNYA"
		else
			backcolor=
		fi
	else
		if ((pcount > 0)); then
			backcolor="k).WARNA SEBELUMNYA $nowpage"
		else
			backcolor=
		fi
		nextcolor=
	fi
}

TCfullcolor() {
	maxpage=9
	pcount=0
	cds=0
	pause=14
	filecolors="$THOME/.termux/colors.properties"
	local back menu_notfound
	declare -A fullcolor=(["pink"]="#FFC0CB" ["lightpink"]="#FFB6C1" ["hotpink"]="#FF69B4" ["deeppink"]="#FF1493" ["palevioletred"]="#DB7093" ["mediumvioletred"]="#C71585" ["lavender"]="#E6E6FA" ["thistle"]="#D8BFD8" ["plum"]="#DDA0DD" ["orchid"]="#DA70D6" ["violet"]="#EE82EE" ["fuchsia"]="#FF00FF" ["magenta"]="#FF00FF" ["mediumorchid"]="#BA55D3" ["darkorchid"]="#9932CC" ["darkviolet"]="#9400D3" ["blueviolet"]="#8A2BE2" ["darkmagenta"]="#8B008B" ["purple"]="#800080" ["mediumpurple"]="#9370DB" ["mediumslateblue"]="#7B68EE" ["slateblue"]="#6A5ACD" ["darkslateblue"]="#483D8B" ["rebeccapurple"]="#663399" ["indigo"]="#4B0082" ["lightsalmon"]="#FFA07A" ["salmon"]="#FA8072" ["darksalmon"]="#E9967A" ["lightcoral"]="#F08080" ["indianred"]="#CD5C5C" ["crimson"]="#DC143C" ["red"]="#FF0000" ["firebrick"]="#B22222" ["darkred"]="#8B0000" ["orange"]="#FFA500" ["darkorange"]="#FF8C00" ["coral"]="#FF7F50" ["tomato"]="#FF6347" ["orangered"]="#FF4500" ["gold"]="#FFD700" ["yellow"]="#FFFF00" ["lightyellow"]="#FFFFE0" ["lemonchiffon"]="#FFFACD" ["lightgoldenrodyellow"]="#FAFAD2" ["papayawhip"]="#FFEFD5" ["moccasin"]="#FFE4B5" ["peachpuff"]="#FFDAB9" ["palegoldenrod"]="#EEE8AA" ["khaki"]="#F0E68C" ["darkkhaki"]="#BDB76B" ["greenyellow"]="#ADFF2F" ["chartreuse"]="#7FFF00" ["lawngreen"]="#7CFC00" ["lime"]="#00FF00" ["limegreen"]="#32CD32" ["palegreen"]="#98FB98" ["lightgreen"]="#90EE90" ["mediumspringgreen"]="#00FA9A" ["springgreen"]="#00FF7F" ["mediumseagreen"]="#3CB371" ["seagreen"]="#2E8B57" ["forestgreen"]="#228B22" ["green"]="#008000" ["darkgreen"]="#006400" ["yellowgreen"]="#9ACD32" ["olivedrab"]="#6B8E23" ["darkolivegreen"]="#556B2F" ["mediumaquamarine"]="#66CDAA" ["darkseagreen"]="#8FBC8F" ["lightseagreen"]="#20B2AA" ["darkcyan"]="#008B8B" ["teal"]="#008080" ["aqua"]="#00FFFF" ["cyan"]="#00FFFF" ["lightcyan"]="#E0FFFF" ["paleturquoise"]="#AFEEEE" ["aquamarine"]="#7FFFD4" ["turquoise"]="#40E0D0" ["mediumturquoise"]="#48D1CC" ["darkturquoise"]="#00CED1" ["cadetblue"]="#5F9EA0" ["steelblue"]="#4682B4" ["lightsteelblue"]="#B0C4DE" ["lightblue"]="#ADD8E6" ["powderblue"]="#B0E0E6" ["lightskyblue"]="#87CEFA" ["skyblue"]="#87CEEB" ["cornflowerblue"]="#6495ED" ["deepskyblue"]="#00BFFF" ["dodgerblue"]="#1E90FF" ["royalblue"]="#4169E1" ["blue"]="#0000FF" ["mediumblue"]="#0000CD" ["darkblue"]="#00008B" ["navy"]="#000080" ["midnightblue"]="#191970" ["cornsilk"]="#FFF8DC" ["blanchedalmond"]="#FFEBCD" ["bisque"]="#FFE4C4" ["navajowhite"]="#FFDEAD" ["wheat"]="#F5DEB3" ["burlywood"]="#DEB887" ["tan"]="#D2B48C" ["rosybrown"]="#BC8F8F" ["sandybrown"]="#F4A460" ["goldenrod"]="#DAA520" ["darkgoldenrod"]="#B8860B" ["peru"]="#CD853F" ["chocolate"]="#D2691E" ["olive"]="#808000" ["saddlebrown"]="#8B4513" ["sienna"]="#A0522D" ["brown"]="#A52A2A" ["maroon"]="#800000" ["white"]="#FFFFFF" ["snow"]="#FFFAFA" ["honeydew"]="#F0FFF0" ["mintcream"]="#F5FFFA" ["azure"]="#F0FFFF" ["aliceblue"]="#F0F8FF" ["ghostwhite"]="#F8F8FF" ["whitesmoke"]="#F5F5F5" ["seashell"]="#FFF5EE" ["beige"]="#F5F5DC" ["oldlace"]="#FDF5E6" ["floralwhite"]="#FFFAF0" ["ivory"]="#FFFFF0" ["antiquewhite"]="#FAEBD7" ["linen"]="#FAF0E6" ["lavenderblush"]="#FFF0F5" ["mistyrose"]="#FFE4E1" ["gainsboro"]="#DCDCDC" ["lightgray"]="#D3D3D3" ["silver"]="#C0C0C0" ["darkgray"]="#A9A9A9" ["dimgray"]="#696969" ["gray"]="#808080" ["lightslategray"]="#778899" ["slategray"]="#708090" ["darkslategray"]="#2F4F4F" ["black"]="#000000" ["1"]="#FFC0CB" ["2"]="#FFB6C1" ["3"]="#FF69B4" ["4"]="#FF1493" ["5"]="#DB7093" ["6"]="#C71585" ["7"]="#E6E6FA" ["8"]="#D8BFD8" ["9"]="#DDA0DD" ["10"]="#DA70D6" ["11"]="#EE82EE" ["12"]="#FF00FF" ["13"]="#FF00FF" ["14"]="#BA55D3" ["15"]="#9932CC" ["16"]="#9400D3" ["17"]="#8A2BE2" ["18"]="#8B008B" ["19"]="#800080" ["20"]="#9370DB" ["21"]="#7B68EE" ["22"]="#6A5ACD" ["23"]="#483D8B" ["24"]="#663399" ["25"]="#4B0082" ["26"]="#FFA07A" ["27"]="#FA8072" ["28"]="#E9967A" ["29"]="#F08080" ["30"]="#CD5C5C" ["31"]="#DC143C" ["32"]="#FF0000" ["33"]="#B22222" ["34"]="#8B0000" ["35"]="#FFA500" ["36"]="#FF8C00" ["37"]="#FF7F50" ["38"]="#FF6347" ["39"]="#FF4500" ["40"]="#FFD700" ["41"]="#FFFF00" ["42"]="#FFFFE0" ["43"]="#FFFACD" ["44"]="#FAFAD2" ["45"]="#FFEFD5" ["46"]="#FFE4B5" ["47"]="#FFDAB9" ["48"]="#EEE8AA" ["49"]="#F0E68C" ["50"]="#BDB76B" ["51"]="#ADFF2F" ["52"]="#7FFF00" ["53"]="#7CFC00" ["54"]="#00FF00" ["55"]="#32CD32" ["56"]="#98FB98" ["57"]="#90EE90" ["58"]="#00FA9A" ["59"]="#00FF7F" ["60"]="#3CB371" ["61"]="#2E8B57" ["62"]="#228B22" ["63"]="#008000" ["64"]="#006400" ["65"]="#9ACD32" ["66"]="#6B8E23" ["67"]="#556B2F" ["68"]="#66CDAA" ["69"]="#8FBC8F" ["70"]="#20B2AA" ["71"]="#008B8B" ["72"]="#008080" ["73"]="#00FFFF" ["74"]="#00FFFF" ["75"]="#E0FFFF" ["76"]="#AFEEEE" ["77"]="#7FFFD4" ["78"]="#40E0D0" ["79"]="#48D1CC" ["80"]="#00CED1" ["81"]="#5F9EA0" ["82"]="#4682B4" ["83"]="#B0C4DE" ["84"]="#ADD8E6" ["85"]="#B0E0E6" ["86"]="#87CEFA" ["87"]="#87CEEB" ["88"]="#6495ED" ["89"]="#00BFFF" ["90"]="#1E90FF" ["91"]="#4169E1" ["92"]="#0000FF" ["93"]="#0000CD" ["94"]="#00008B" ["95"]="#000080" ["96"]="#191970" ["97"]="#FFF8DC" ["98"]="#FFEBCD" ["99"]="#FFE4C4" ["100"]="#FFDEAD" ["101"]="#F5DEB3" ["102"]="#DEB887" ["103"]="#D2B48C" ["104"]="#BC8F8F" ["105"]="#F4A460" ["106"]="#DAA520" ["107"]="#B8860B" ["108"]="#CD853F" ["109"]="#D2691E" ["110"]="#808000" ["111"]="#8B4513" ["112"]="#A0522D" ["113"]="#A52A2A" ["114"]="#800000" ["115"]="#FFFFFF" ["116"]="#FFFAFA" ["117"]="#F0FFF0" ["118"]="#F5FFFA" ["119"]="#F0FFFF" ["120"]="#F0F8FF" ["121"]="#F8F8FF" ["122"]="#F5F5F5" ["123"]="#FFF5EE" ["124"]="#F5F5DC" ["125"]="#FDF5E6" ["126"]="#FFFAF0" ["127"]="#FFFFF0" ["128"]="#FAEBD7" ["129"]="#FAF0E6" ["130"]="#FFF0F5" ["131"]="#FFE4E1" ["132"]="#DCDCDC" ["133"]="#D3D3D3" ["134"]="#C0C0C0" ["135"]="#A9A9A9" ["136"]="#696969" ["137"]="#808080" ["138"]="#778899" ["139"]="#708090" ["140"]="#2F4F4F" ["141"]="#000000")
	local colorlist=("1).Pink\n" "2).LightPink\n" "3).HotPink\n" "4).DeepPink\n" "5).PaleVioletRed\n" "6).MediumVioletRed\n" "7).Lavender\n" "8).Thistle\n" "9).Plum\n" "10).Orchid\n" "11).Violet\n" "12).Fuchsia\n" "13).Magenta\n" "14).MediumOrchid\n" "15).DarkOrchid\n" "16).DarkViolet\n" "17).BlueViolet\n" "18).DarkMagenta\n" "19).Purple\n" "20).MediumPurple\n" "21).MediumSlateBlue\n" "22).SlateBlue\n" "23).DarkSlateBlue\n" "24).RebeccaPurple\n" "25).Indigo\n" "26).LightSalmon\n" "27).Salmon\n" "28).DarkSalmon\n" "29).LightCoral\n" "30).IndianRed\n" "31).Crimson\n" "32).Red\n" "33).FireBrick\n" "34).DarkRed\n" "35).Orange\n" "36).DarkOrange\n" "37).Coral\n" "38).Tomato\n" "39).OrangeRed\n" "40).Gold\n" "41).Yellow\n" "42).LightYellow\n" "43).LemonChiffon\n" "44).LightGoldenRodYellow\n" "45).PapayaWhip\n" "46).Moccasin\n" "47).PeachPuff\n" "48).PaleGoldenRod\n" "49).Khaki\n" "50).DarkKhaki\n" "51).GreenYellow\n" "52).Chartreuse\n" "53).LawnGreen\n" "54).Lime\n" "55).LimeGreen\n" "56).PaleGreen\n" "57).LightGreen\n" "58).MediumSpringGreen\n" "59).SpringGreen\n" "60).MediumSeaGreen\n" "61).SeaGreen\n" "62).ForestGreen\n" "63).Green\n" "64).DarkGreen\n" "65).YellowGreen\n" "66).OliveDrab\n" "67).DarkOliveGreen\n" "68).MediumAquaMarine\n" "69).DarkSeaGreen\n" "70).LightSeaGreen\n" "71).DarkCyan\n" "72).Teal\n" "73).Aqua\n" "74).Cyan\n" "75).LightCyan\n" "76).PaleTurquoise\n" "77).Aquamarine\n" "78).Turquoise\n" "79).MediumTurquoise\n" "80).DarkTurquoise\n" "81).CadetBlue\n" "82).SteelBlue\n" "83).LightSteelBlue\n" "84).LightBlue\n" "85).PowderBlue\n" "86).LightSkyBlue\n" "87).SkyBlue\n" "88).CornflowerBlue\n" "89).DeepSkyBlue\n" "90).DodgerBlue\n" "91).RoyalBlue\n" "92).Blue\n" "93).MediumBlue\n" "94).DarkBlue\n" "95).Navy\n" "96).MidnightBlue\n" "97).Cornsilk\n" "98).BlanchedAlmond\n" "99).Bisque\n" "100).NavajoWhite\n" "101).Wheat\n" "102).BurlyWood\n" "103).Tan\n" "104).RosyBrown\n" "105).SandyBrown\n" "106).GoldenRod\n" "107).DarkGoldenRod\n" "108).Peru\n" "109).Chocolate\n" "110).Olive\n" "111).SaddleBrown\n" "112).Sienna\n" "113).Brown\n" "114).Maroon\n" "115).White\n" "116).Snow\n" "117).HoneyDew\n" "118).MintCream\n" "119).Azure\n" "120).AliceBlue\n" "121).GhostWhite\n" "122).WhiteSmoke\n" "123).SeaShell\n" "124).Beige\n" "125).OldLace\n" "126).FloralWhite\n" "127).Ivory\n" "128).AntiqueWhite\n" "129).Linen\n" "130).LavenderBlush\n" "131).MistyRose\n" "132).Gainsboro\n" "133).LightGray\n" "134).Silver\n" "135).DarkGray\n" "136).DimGray\n" "137).Gray\n" "138).LightSlateGray\n" "139).SlateGray\n" "140).DarkSlateGray\n 141).Black\n")
	while :; do
		if ((pcount == ${maxpage})); then
			clr=27
		else
			clr=26
		fi

		if [ "$1" != "${type[0]}" ]; then
			back="<).SEBELUMNYA"
		else
			back=
		fi
		TCsetmenu
		echo -e "${lred}b).KEMBALI KE MENU AWAL"
		echo -e "${lwhite}?).BANTUAN$dft"
		echo -e "\e[48;5;17;1;32mPILIH WARNA UNTUK ${dft}\e[48;5;17;1;35m${1}${dft}\e[48;5;17m"
		echo -e "$lyellow$back"
		echo -e "${lyellow}>).LEWATI"
		echo -e "${lwhite}$nextcolor"
		echo -e "${lwhite}$backcolor"
		echo -e " ${lcyan}0).Default"
		echo -e " ${colorlist[@]:${cds}:$pause}"
		echo -en "$dft$menu_notfound\n${lcyan}X${TCprompt}${lcyan}Z${lwhite}×> "; read -r C_Usr
		menu_notfound=
		C_Usr="${C_Usr,,}"
		if [ -v fullcolor["${C_Usr}"] ]; then
			if [ "$1" == "${type[0]}" ]; then
				SV_BG="$1=${fullcolor["${C_Usr:-none}"]}"
				cbg="${fullcolor["${C_Usr:-none}"]}"
			elif [ "$1" == "${type[1]}" ]; then
				cfg="${fullcolor["${C_Usr:-none}"]}"
				if [ "$cfg" == "$cbg" ]; then
					menu_notfound="${yellow}WARNA SAMA DENGAN SEBELUMNYA$dft"
					line-clear $clr
					continue
				fi
				SV_FG="$1=${fullcolor["${C_Usr:-none}"]}"
			elif [ "$1" == "${type[2]}" ]; then
				ccrs="${fullcolor["${C_Usr:-none}"]}"
				if [ "$ccrs" == "$cbg" ]; then
					line-clear $clr
					menu_notfound="${yellow}WARNA SAMA DENGAN SEBELUMNYA$dft"
					continue
				fi

				if [ "$ccrs" == "$cfg" ]; then
					line-clear $clr
					menu_notfound="${yellow}WARNA SAMA DENGAN SEBELUMNYA$dft"
					continue
				fi
				SV_CRS="$1=${fullcolor["${C_Usr:-none}"]}"
			fi
			line-clear $clr
			break
		elif [ "$C_Usr" == "<" ]; then
			line-clear $clr
			if [ "$1" != "${type[0]}" ]; then
				i=$((i-2))
				break
			fi
		elif [ "$C_Usr" == ">" ]; then
			if [ "$1" == "${type[0]}" ]; then
				SV_BG="$(grep -o "^${type[0]}.\+#.\+" $filecolors)"
			elif [ "$1" == "${type[1]}" ]; then
				SV_FG="$(grep -o "^${type[1]}.\+#.\+" $filecolors)"
			elif [ "$1" == "${type[2]}" ]; then
				SV_CRS="$(grep -o "^${type[2]}.\+#.\+" $filecolors)"
			fi
			line-clear $clr
			break
		elif [ "$C_Usr" == "0" ] || [ "$C_Usr" == "default" ]; then
			line-clear $clr
			break
		elif [ "$C_Usr" == "n" ]; then
			if ((pcount == ${maxpage})); then
				clr=27
			else
				clr=26
				pcount=$((pcount+1))
				cds=$((cds+14))
			fi
			line-clear $clr
		elif [ "$C_Usr" == "k" ]; then
			if ((pcount > 0)); then
				pcount=$((pcount-1))
				cds=$((cds-14))
			fi
			line-clear $clr
		elif [ "$C_Usr" == "?" ]; then
			line-clear $clr
			TCHELP
		elif [ "$C_Usr" == "b" ]; then
			line-clear $clr
			main-menu
		else
			menu_notfound="${red}TIDAK ADA MENU/WARNA$dft"
			line-clear $clr
		fi
	done
}

TCsettype() {
	type=(background foreground cursor)
	local i prompt_clrs
	prompt_clrs=("$lblue" "$lyellow" "$lred")
	SV_BG=; SV_FG=; SV_CRS=
	for ((i=0; i<${#type[@]}; i++)); do
		shortf="${type[$i]}"
		TCprompt="${prompt_clrs[$i]}$shortf"
		TCfullcolor "$shortf"
	done
	TCsave $SV_BG $SV_FG $SV_CRS
	TCsettype
}

TFextrak() {
	echo -e "Mengecek package unzip"
	if command -v unzip > /dev/null; then
		echo -e "Package unzip ditemukan"
	else
		echo -e "Package unzip tidak ditemukan"
		echo -e "Menginstall package unzip"
		read < <(apt install unzip --assume-yes > /dev/null)
		if command -v unzip > /dev/null; then
			echo -e "Package unzip berhasil di install"
		else
			echo -e "Package unzip gagal di install"
			exit 1
		fi
	fi
	echo -e "Mengekstrak file font-termux.zip"
	unzip font-termux.zip > /dev/null
	if [ -f "$filefont" ]; then
		echo -e "Berhasil di ekstrak"
	else
		echo -e "Gagal di ekstrak"
		exit 1
	fi
	file-manager "$filefont" "-f" "n"
}

TFdownloadfont() {
	echo -e "${lcyan}MENGUNDUH FONT..\nTUNGGU HINGGA PROSES PENGUNDUHAN SELESAI$dft"
	curl -L "https://drive.google.com/uc?export=download&id=1gXTFhsNjmDZblT39KPBQ7V2fM7_FE4z7" -o font-termux.zip
	if [ -f font-termux.zip ]; then
		if [ "$SGTR" == "$(sha256sum font-termux.zip)" ]; then
			TFextrak
		else
			echo -e "${Verror}PADA FILE font-termux.zip"
			exit 1
		fi
	else
		echo -e "File ${lblue}font-termux.zip$dft tidak ditemukan didirektori saat ini"
		exit 1
	fi
}

TFsave() {
	local dirfont filefont dirnotfound
	filefont="font-termux/$savefont"
	if [ -z "$savefont" ]; then
		if [ -f "$termfont" ]; then
			if ! rm "$termfont"; then
				echo -e "${Verror}GAGAL MENGHAPAUS FILE font.ttf DI DIREKTORI $THOME/.termux"
				exit 1
			else
				$TERM_RELOAD > /dev/null
				return 0
			fi
		else
			$TERM_RELOAD > /dev/null
			return 0
		fi
	fi
	while :; do
		file-manager "$filefont" "-f" "y"
		if ((fm_err==1)); then
			if [ -f font-termux.zip ]; then
				if [ "$SGTR" == "$(sha256sum font-termux.zip)" ]; then
					TFextrak
				else
					echo -e "${Verror}PADA FILE font-termux.zip"
					exit 1
				fi
			else
				echo -e "${Verror}TIDAK DAPAT MENEMUKAN ${lblue}$filefont${dft}"
				echo -en "UKURAN FILE 17MB (sebelum  diekstrak)\nUKURAN ASLI 33MB (setelah diekstrak)\nUNDUH SEMUA FONT ? y/n: "; read downloadfont
				if [ "${downloadfont,,}" == "y" ]; then
					TFdownloadfont
				elif [ "${downloadfont,,}" == "n" ]; then
					exit 0
				else
					line-clear 3
				fi
			fi
		else
			break
		fi
	done
	Fprop "mkdir $THOME/.termux" "-d" "$THOME/.termux" "FOLDER .termux DI DIREKTORI $THOME" "KARENA ITU TIDAK BISA MENYIMPAN PERUBAHAN FONT UNTUK TERMUX"
	if cp $filefont $THOME/.termux; then
		if mv $THOME/.termux/$savefont $termfont; then
			file-manager "$termfont" "-f" "n"
		else
			echo -e "${Verror}GAGAL MENGGANTI NAMA FILE $savefont MENJADI $termfont"
			exit 1
		fi
	else
		echo -e "${Verror}GAGAL MEMINDAHKAN FILE $savefont KE $termfont"
		exit 1
	fi
	$TERM_RELOAD > /dev/null
}

TFmenu() {
	local FCprompt menu_notfound clears F_Usr
	FCprompt="${lcyan}font"
	termfont="$THOME/.termux/font.ttf"
	clears=18
	menu_control=0
	nextfont="n).FONT SELANJUTNYA"
	declare -A fontconvert=(["dejavu"]="DejaVu.ttf" ["gnufreefont"]="GNUFreeFont.ttf" ["go"]="Go.ttf" ["hack"]="Hack.ttf" ["hermit"]="Hermit.ttf" ["inconsolata"]="Inconsolata.ttf" ["liberationmono"]="LiberationMono.ttf" ["monofur"]="Monofur.ttf" ["opendyslexic"]="OpenDyslexic.ttf" ["sourcecodepro"]="SourceCodePro.ttf" ["ubuntu"]="Ubuntu.ttf" ["anonymouspro"]="anonymouspro.ttf" ["courierprime"]="courierprime.ttf" ["d2coding"]="d2coding.ttf" ["fantasque"]="fantasque.ttf" ["firacode"]="firacode.ttf" ["losevka"]="losevka.ttf" ["meslo"]="meslo.ttf" ["roboto"]="roboto.ttf" ["1"]="DejaVu.ttf" ["2"]="GNUFreeFont.ttf" ["3"]="Go.ttf" ["4"]="Hack.ttf" ["5"]="Hermit.ttf" ["6"]="Inconsolata.ttf" ["7"]="LiberationMono.ttf" ["8"]="Monofur.ttf" ["9"]="OpenDyslexic.ttf" ["10"]="SourceCodePro.ttf" ["11"]="Ubuntu.ttf" ["12"]="anonymouspro.ttf" ["13"]="courierprime.ttf" ["14"]="d2coding.ttf" ["15"]="fantasque.ttf" ["16"]="firacode.ttf" ["17"]="losevka.ttf" ["18"]="meslo.ttf" ["19"]="roboto.ttf")
	local fontlist=("1).DejaVu\n" "2).GNUFreeFont\n" "3).Go\n" "4).Hack\n" "5).Hermit\n" "6).Inconsolata\n" "7).LiberationMono\n" "8).Monofur\n" "9).OpenDyslexic\n" "10).SourceCodePro\n" "11).Ubuntu\n" "12).anonymouspro\n" "13).courierprime\n" "14).d2coding\n" "15).fantasque\n" "16).firacode\n" "17).losevka\n" "18).meslo\n" "19).roboto\n")
	while :; do
		echo -e "${lyellow}b).KEMBALI KE MENU AWAL"
		echo -e "\e[48;5;17;1;32mPILIH FONT UNTUK TERMUX ANDA"
		echo -e "${lwhite}$nextfont"
		echo -e "$backfont"
		echo -e " ${lcyan}0).Default"
		echo -e " ${fontlist[@]:${menu_control}:9}${dft}"
		echo -en "$menu_notfound\n${lblue}X$FCprompt${lblue}Z$dft> "; read -r F_Usr
		menu_notfound=
		savefont=
		F_Usr="${F_Usr,,}"
		if [ -v fontconvert["$F_Usr"] ]; then
			savefont="${fontconvert[$F_Usr]}"
			line-clear $clears
			TFsave
		elif [ "$F_Usr" == "0" ] || [ "$F_Usr" == "default" ]; then
			line-clear $clears
			TFsave
		elif [ "$F_Usr" == "n" ]; then
			if ((menu_control==0)); then
				menu_control=$((menu_control+10))
				nextfont="k).FONT SEBELUMNYA"
			fi
			line-clear $clears
		elif [ "$F_Usr" == "k" ]; then
			if ((menu_control==10)); then
				menu_control=$((menu_control-10))
				nextfont="n).FONT SELANJUTNYA"
			fi
			line-clear $clears
		elif [ "$F_Usr" == "b" ]; then
			line-clear $clears
			main-menu
		else
			menu_notfound="${red}TIDAK ADA MENU/FONT$dft"
			line-clear $clears
		fi
	done
}

main-menu() {
	local clrs choosemenu menu_notfound
	clrs=5
	while :; do
		echo -e "${lcyan}1).${lblue}WARNA (BACKGROUND/FOREGROUND/CURSOR)"
		echo -e "${lcyan}2).${lblue}FONT TERMUX$dft"
		echo -en "${menu_notfound}\nMENU-CBFC:> "; read -r choosemenu
		if [ "$choosemenu" == "1" ]; then
			line-clear $clrs
			TCsettype
		elif [ "$choosemenu" == "2" ]; then
			line-clear $clrs
			TFmenu
		else
			menu_notfound="${red}TIDAK ADA MENU$dft"
			line-clear $clrs
		fi
	done
}

main-menu
