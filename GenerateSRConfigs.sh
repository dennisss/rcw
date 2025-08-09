#!/bin/bash -e

generate() {
	local template=${1}
	local MODULE=${2}
	local SOC_REVISION=${3}
	local BOARD=${4}
	local CPU_SPEED=${5}
	local BUS_SPEED=${6}
	local DDR_SPEED=${7}
	local SD1=${8}
	local SD2=${9}
	local SD3=${10}
	local BOOTSOURCE=${11}

	local SOC_REVISION_SUFFIX="_rev${SOC_REVISION}"
	if [ "${SOC_REVISION_SUFFIX}" = "_rev1" ]; then
		SOC_REVISION_SUFFIX=
	fi

	local nSD1=${SD1}
	if [[ $SD1 = *S ]]; then
		nSD1=${SD1%S}
	fi

	local nSD2=${SD2}
	if [[ $SD2 = *S ]]; then
		nSD2=${SD2%S}
	fi

	local nSD3=${SD3}
	if [[ $SD3 = *S ]]; then
		nSD3=${SD3%S}
	fi

	local rcw="${MODULE,,}${SOC_REVISION_SUFFIX,,}/${BOARD,,}/rcw_${CPU_SPEED}_${BUS_SPEED}_${DDR_SPEED}_${SD1}_${SD2}_${SD3}_${BOOTSOURCE,,}.rcw"
	cat "$template" | sed \
		-e "s;%module%;${MODULE,,};g" -e "s;%MODULE%;${MODULE^^};g" \
		-e "s;%SOC_REVISION%;${SOC_REVISION};g" \
		-e "s;%board%;${BOARD,,};g" -e "s;%BOARD%;${BOARD^^};g" \
		-e "s;%CPU_SPEED%;${CPU_SPEED};g" \
		-e "s;%BUS_SPEED%;${BUS_SPEED};g" \
		-e "s;%DDR_SPEED%;${DDR_SPEED};g" \
		-e "s;%bootsource%;${BOOTSOURCE,,};g" -e "s;%BOOTSOURCE%;${BOOTSOURCE^^};g" \
		-e "s;%SD1%;${SD1};g" -e "s;%nSD1%;${nSD1};g" \
		-e "s;%SD2%;${SD2};g" -e "s;%nSD2%;${nSD2};g" \
		-e "s;%SD3%;${SD3};g" -e "s;%nSD3%;${nSD3};g" \
		> "$rcw"
	echo "Generated $rcw"
}

# generate LX2160A CEX-7 Clearfog-CX
for DDR_SPEED in 2400 2600 2666 2900 3200; do
	for SOC_REVISION in 1 2; do
		for BOOTSOURCE in auto sdhc xspi; do
			for SD1 in 4 8 8S 18 20; do
				generate lx2160acex7_clearfog-cx.tmpl lx2160acex7 ${SOC_REVISION} clearfog-cx 2000 700 ${DDR_SPEED} ${SD1} 5 2 ${BOOTSOURCE}
				generate lx2160acex7_clearfog-cx.tmpl lx2160acex7 ${SOC_REVISION} clearfog-cx 2200 750 ${DDR_SPEED} ${SD1} 5 2 ${BOOTSOURCE}
			done
		done
	done
done

# generate LX2162A CSoM Clearfog
for SD1 in 2 18; do
	for SD2 in 7 9 11; do
		generate lx2162asom_clearfog.tmpl lx2162asom 2 clearfog 2000 650 2900 ${SD1} ${SD2} 0 auto
	done
done

# generate LX2160A CEX-6 Internal Evaluation Board
for DDR_SPEED in 2400 2600 2900 3200; do
	generate lx2160acex6_evb.tmpl lx2160acex6 2 evb 2000 700 ${DDR_SPEED} 3 3 2 auto
	generate lx2160acex6_evb.tmpl lx2160acex6 2 evb 2200 750 ${DDR_SPEED} 3 3 2 auto
done

# generate LX2160A CEX-7 Internal Twins Board
for DDR_SPEED in 2400 2600 2666 2900 3200; do
	generate lx2160acex7_twins.tmpl lx2160acex7 2 twins 2000 700 ${DDR_SPEED} 8S 9 2 auto
done
