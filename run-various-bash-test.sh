#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.3.5-alpha
# date: 2024-12-12 23:27:15
replace__0_v0() {

# bshchk (https://git.blek.codes/blek/bshchk)
deps=('return' '[' 'sed' '[' 'bc' 'sed' 'sed' 'return' 'sed' 'return' 'return' 'tr' 'return' '[' 'return' '[' 'return' '[' 'bc' 'sed' 'bc' 'sed' '[' 'bc' 'sed' 'return' 'return' '[' 'return' '[' '[' 'return' 'return' '[' '[' '[' 'bc' 'sed' 'bc' 'sed' 'return' '[' 'bc' 'sed' 'exit' '[' '[' 'return' 'true' 'bc' 'sed' 'return' 'bc' 'sed' 'return' '[' 'return' '[' 'return' '[' '[' '[' '[' '[' '[' '[' 'return' '[' 'continue' '[' 'continue' '[' 'continue' 'return' 'return' '[' 'bc' 'sed' '[' 'bc' 'sed' 'exit' '[' '[' 'bc' 'sed' 'true' 'docker' '[' '[' 'docker' 'docker' 'docker' 'cargo' '[' '[' '[' 'docker' '[')
non_ok=()

for d in $deps
do
    if ! command -v $d > /dev/null 2>&1; then
        non_ok+=$d
    fi
done

if (( ${#non_ok[@]} != 0 )); then
    >&2 echo "RDC Failed!"
    >&2 echo "  This program requires these commands:"
    >&2 echo "  > $deps"
    >&2 echo "    --- "
    >&2 echo "  From which, these are missing:"
    >&2 echo "  > $non_ok"
    >&2 echo "Make sure that those are installed and are present in \$PATH."
    exit 1
fi

unset non_ok
unset deps
# Dependencies are OK at this point


    local source=$1
    local search=$2
    local replace=$3
    __AF_replace0_v0="${source//${search}/${replace}}"
    return 0
}
replace_regex__2_v0() {
    local source=$1
    local search=$2
    local replace=$3
    local extended=$4
    replace__0_v0 "${search}" "/" "\/"
    __AF_replace0_v0__16_18="${__AF_replace0_v0}"
    search="${__AF_replace0_v0__16_18}"
    replace__0_v0 "${replace}" "/" "\/"
    __AF_replace0_v0__17_19="${__AF_replace0_v0}"
    replace="${__AF_replace0_v0__17_19}"
    if [ ${extended} != 0 ]; then
        # GNU sed versions 4.0 through 4.2 support extended regex syntax,
        # but only via the "-r" option; use that if the version information
        # contains "GNU sed".
        re='\bCopyright\b.+\bFree Software Foundation\b'
        [[ $(sed --version 2>/dev/null) =~ $re ]]
        __AS=$?
        local flag=$(if [ $(echo $__AS '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then echo "-r"; else echo "-E"; fi)
        __AMBER_VAL_0=$(echo "${source}" | sed "${flag}" -e "s/${search}/${replace}/g")
        __AS=$?
        __AF_replace_regex2_v0="${__AMBER_VAL_0}"
        return 0
    else
        __AMBER_VAL_1=$(echo "${source}" | sed -e "s/${search}/${replace}/g")
        __AS=$?
        __AF_replace_regex2_v0="${__AMBER_VAL_1}"
        return 0
    fi
}
join__6_v0() {
    local list=("${!1}")
    local delimiter=$2
    __AMBER_VAL_2=$(
        IFS="${delimiter}"
        echo "${list[*]}"
    )
    __AS=$?
    __AF_join6_v0="${__AMBER_VAL_2}"
    return 0
}
lower__10_v0() {
    local text=$1
    __AMBER_VAL_3=$(echo "${text}" | tr '[:upper:]' '[:lower:]')
    __AS=$?
    __AF_lower10_v0="${__AMBER_VAL_3}"
    return 0
}
contains__14_v0() {
    local text=$1
    local phrase=$2
    __AMBER_VAL_4=$(if [[ "${text}" == *"${phrase}"* ]]; then
        echo 1
    fi)
    __AS=$?
    local result="${__AMBER_VAL_4}"
    __AF_contains14_v0=$(
        [ "_${result}" != "_1" ]
        echo $?
    )
    return 0
}
starts_with__20_v0() {
    local text=$1
    local prefix=$2
    __AMBER_VAL_5=$(if [[ "${text}" == "${prefix}"* ]]; then
        echo 1
    fi)
    __AS=$?
    local result="${__AMBER_VAL_5}"
    __AF_starts_with20_v0=$(
        [ "_${result}" != "_1" ]
        echo $?
    )
    return 0
}
slice__22_v0() {
    local text=$1
    local index=$2
    local length=$3
    if [ $(echo ${length} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_LEN="${text}"
        length=$(echo "${#__AMBER_LEN}" '-' ${index} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    fi
    if [ $(echo ${length} '<=' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_slice22_v0=""
        return 0
    fi
    __AMBER_VAL_6=$(printf "%.${length}s" "${text:${index}}")
    __AS=$?
    __AF_slice22_v0="${__AMBER_VAL_6}"
    return 0
}

shell_var_set__90_v0() {
    local name=$1
    local val=$2
    export $name="$val" 2>/dev/null
    __AS=$?
    if [ $__AS != 0 ]; then
        __AF_shell_var_set90_v0=''
        return $__AS
    fi
}
is_command__93_v0() {
    local command=$1
    [ -x "$(command -v ${command})" ]
    __AS=$?
    if [ $__AS != 0 ]; then
        __AF_is_command93_v0=0
        return 0
    fi
    __AF_is_command93_v0=1
    return 0
}
confirm__96_v0() {
    local prompt=$1
    local default_yes=$2
    local choice_default=$(if [ ${default_yes} != 0 ]; then echo " [\x1b[1mY/\x1b[0mn]"; else echo " [y/\x1b[1mN\x1b[0m]"; fi)
    printf "\x1b[1m${prompt}\x1b[0m${choice_default}"
    __AS=$?
    read -s -n 1
    __AS=$?
    printf "
"
    __AS=$?
    __AMBER_VAL_7=$(echo $REPLY)
    __AS=$?
    lower__10_v0 "${__AMBER_VAL_7}"
    __AF_lower10_v0__90_18="${__AF_lower10_v0}"
    local result="${__AF_lower10_v0__90_18}"
    __AF_confirm96_v0=$(echo $(
        [ "_${result}" != "_y" ]
        echo $?
    ) '||' $(echo $(
        [ "_${result}" != "_" ]
        echo $?
    ) '&&' ${default_yes} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    return 0
}
printf__99_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __AS=$?
    printf "${args[@]}"
    __AS=$?
}
error__109_v0() {
    local message=$1
    local exit_code=$2
    __AMBER_ARRAY_8=("${message}")
    printf__99_v0 "\x1b[1;3;97;41m%s\x1b[0m
" __AMBER_ARRAY_8[@]
    __AF_printf99_v0__162_5="$__AF_printf99_v0"
    echo "$__AF_printf99_v0__162_5" >/dev/null 2>&1
    if [ $(echo ${exit_code} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        exit ${exit_code}
    fi
}
array_first_index__120_v0() {
    local array=("${!1}")
    local value=$2
    index=0
    for element in "${array[@]}"; do
        if [ $(
            [ "_${value}" != "_${element}" ]
            echo $?
        ) != 0 ]; then
            __AF_array_first_index120_v0=${index}
            return 0
        fi
        ((index++)) || true
    done
    __AF_array_first_index120_v0=$(echo '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    return 0
}
includes__122_v0() {
    local array=("${!1}")
    local value=$2
    array_first_index__120_v0 array[@] "${value}"
    __AF_array_first_index120_v0__26_18="$__AF_array_first_index120_v0"
    local result="$__AF_array_first_index120_v0__26_18"
    __AF_includes122_v0=$(echo ${result} '>=' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    return 0
}
contains_regex__124_v0() {
    local text=$1
    local search=$2
    local extended=$3
    replace_regex__2_v0 "${text}" "${search}" "" ${extended}
    __AF_replace_regex2_v0__20_20="${__AF_replace_regex2_v0}"
    __AF_contains_regex124_v0=$(
        [ "_${text}" == "_${__AF_replace_regex2_v0__20_20}" ]
        echo $?
    )
    return 0
}
equals_regex__125_v0() {
    local text=$1
    local search=$2
    local extended=$3
    replace_regex__2_v0 "${text}" "${search}" "" ${extended}
    __AF_replace_regex2_v0__24_12="${__AF_replace_regex2_v0}"
    __AF_equals_regex125_v0=$(
        [ "_${__AF_replace_regex2_v0__24_12}" != "_" ]
        echo $?
    )
    return 0
}
declare -r __0_container_name="amber_bash_test_container"
__AMBER_ARRAY_9=("3.2" "4.0" "4.1" "4.2" "4.3" "4.4" "5.0" "5.1" "5.2")
declare -r __1_bash_versions=("${__AMBER_ARRAY_9[@]}")
declare -r __2_default_bash_version="5.1"
parse_bash_versions__126_v0() {
    local arguments=("${!1}")
    join__6_v0 arguments[@] " "
    __AF_join6_v0__42_20="${__AF_join6_v0}"
    declare -r joined="${__AF_join6_v0__42_20}"
    declare -r regex="[0-9]\.[0-9]-[0-9]\.[0-9]"
    contains_regex__124_v0 "${joined}" "${regex}" 1
    __AF_contains_regex124_v0__44_8="$__AF_contains_regex124_v0"
    if [ "$__AF_contains_regex124_v0__44_8" != 0 ]; then
        echo "joined: ${joined}"
        for arg in "${arguments[@]}"; do
            equals_regex__125_v0 "${arg}" "${regex}" 1
            __AF_equals_regex125_v0__47_16="$__AF_equals_regex125_v0"
            if [ "$__AF_equals_regex125_v0__47_16" != 0 ]; then
                __AMBER_ARRAY_10=()
                local versions=("${__AMBER_ARRAY_10[@]}")
                slice__22_v0 "${arg}" 0 3
                __AF_slice22_v0__49_30="${__AF_slice22_v0}"
                declare -r left="${__AF_slice22_v0__49_30}"
                slice__22_v0 "${arg}" 4 3
                __AF_slice22_v0__50_31="${__AF_slice22_v0}"
                declare -r right="${__AF_slice22_v0__50_31}"
                local flag_started=0
                for ver in "${__1_bash_versions[@]}"; do
                    if [ $(
                        [ "_${ver}" != "_${left}" ]
                        echo $?
                    ) != 0 ]; then
                        flag_started=1
                    fi
                    if [ ${flag_started} != 0 ]; then
                        __AMBER_ARRAY_11=("${ver}")
                        versions+=("${__AMBER_ARRAY_11[@]}")
                    fi
                    if [ $(
                        [ "_${ver}" != "_${right}" ]
                        echo $?
                    ) != 0 ]; then
                        __AF_parse_bash_versions126_v0=("${versions[@]}")
                        return 0
                    fi
                done
            fi
        done
    else
        __AMBER_ARRAY_12=()
        local versions=("${__AMBER_ARRAY_12[@]}")
        local last_is_dash=0
        for arg in "${arguments[@]}"; do
            contains__14_v0 "${arg}" "bash"
            __AF_contains14_v0__66_16="$__AF_contains14_v0"
            if [ "$__AF_contains14_v0__66_16" != 0 ]; then
                continue
            fi
            starts_with__20_v0 "${arg}" "--"
            __AF_starts_with20_v0__67_16="$__AF_starts_with20_v0"
            if [ "$__AF_starts_with20_v0__67_16" != 0 ]; then
                last_is_dash=1
                continue
            fi
            if [ ${last_is_dash} != 0 ]; then
                last_is_dash=0
                continue
            fi
            __AMBER_ARRAY_13=("${arg}")
            versions+=("${__AMBER_ARRAY_13[@]}")
        done
        __AF_parse_bash_versions126_v0=("${versions[@]}")
        return 0
    fi
    __AMBER_ARRAY_14=("${__2_default_bash_version}")
    __AF_parse_bash_versions126_v0=("${__AMBER_ARRAY_14[@]}")
    return 0
    # return [
    # ]
}
declare -r args=("$0" "$@")
is_command__93_v0 "docker"
__AF_is_command93_v0__85_12="$__AF_is_command93_v0"
if [ $(echo '!' "$__AF_is_command93_v0__85_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
    error__109_v0 "Docker is required" 1
    __AF_error109_v0__86_9="$__AF_error109_v0"
    echo "$__AF_error109_v0__86_9" >/dev/null 2>&1
fi
includes__122_v0 args[@] "-h"
__AF_includes122_v0__88_8="$__AF_includes122_v0"
includes__122_v0 args[@] "--help"
__AF_includes122_v0__88_32="$__AF_includes122_v0"
if [ $(echo "$__AF_includes122_v0__88_8" '||' "$__AF_includes122_v0__88_32" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
    echo "${args[0]} [-h|--help] [--sleep NUM] [VERSION(S)]"
    echo ""
    echo "Examples:"
    echo "${args[0]}                 # Run test on bash ${__2_default_bash_version}. (default)"
    echo "${args[0]} 3.2-5.2         # Run test on bash 3.2 to 5.2."
    echo "${args[0]} 4.4 5.2         # Run test on bash 4.4 and 5.2."
    echo "${args[0]} 3.2-4.1 5.2     # Mixed range is not supported."
    echo "${args[0]} --sleep 300 5.2 # Launch a container which lives 300 seconds. If tests are not done in the lifetime, bad things happen."
    exit 0
fi
sleep="infinity"
i=0
for arg in "${args[@]}"; do
    if [ $(
        [ "_${arg}" != "_--sleep" ]
        echo $?
    ) != 0 ]; then
        sleep="${args[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
    fi
    ((i++)) || true
done
parse_bash_versions__126_v0 args[@]
__AF_parse_bash_versions126_v0__106_22=("${__AF_parse_bash_versions126_v0[@]}")
declare -r versions=("${__AF_parse_bash_versions126_v0__106_22[@]}")
for ver in "${versions[@]}"; do
    echo "Version: ${ver}"
    # Firch, check whether there is a container since last test.
    __AMBER_VAL_15=$(docker container ls --quiet --filter name=${__0_container_name}_${ver})
    __AS=$?
    running_container="${__AMBER_VAL_15}"
    if [ $(
        [ "_${running_container}" != "_" ]
        echo $?
    ) != 0 ]; then
        # Run a detached docker container.
        docker rm -f ${__0_container_name} >/dev/null 2>&1
        __AS=$?
        docker run --rm --network host --detach --name ${__0_container_name}_${ver} bash:${ver} sleep ${sleep} >/dev/null 2>&1
        __AS=$?
        docker exec ${__0_container_name}_${ver} apk add coreutils curl sed
        __AS=$?
    fi
    # Run the tests.
    shell_var_set__90_v0 "AMBER_TEST_STRATEGY" "docker"
    __AS=$?
    __AF_shell_var_set90_v0__120_13="$__AF_shell_var_set90_v0"
    echo "$__AF_shell_var_set90_v0__120_13" >/dev/null 2>&1
    __AMBER_ARRAY_16=("exec" "--user 405" "${__0_container_name}_${ver}" "bash")
    join__6_v0 __AMBER_ARRAY_16[@] " "
    __AF_join6_v0__121_46="${__AF_join6_v0}"
    shell_var_set__90_v0 "AMBER_TEST_ARGS" "${__AF_join6_v0__121_46}"
    __AS=$?
    __AF_shell_var_set90_v0__121_13="$__AF_shell_var_set90_v0"
    echo "$__AF_shell_var_set90_v0__121_13" >/dev/null 2>&1
    cargo test --all-targets --all-features
    __AS=$?
    if [ $__AS != 0 ]; then
        confirm__96_v0 "The tests for ${ver} is failed. Continue?" 0
        __AF_confirm96_v0__129_13="$__AF_confirm96_v0"
        echo "$__AF_confirm96_v0__129_13" >/dev/null 2>&1
    fi
    if [ $(
        [ "_${sleep}" != "_infinity" ]
        echo $?
    ) != 0 ]; then
        # Stop and remove the docker container.
        docker rm -f ${__0_container_name}_${ver} >/dev/null 2>&1
        __AS=$?
        if [ $__AS != 0 ]; then
            error__109_v0 "Stopping ${__0_container_name}_${ver} failed. You should stop it manually." 1
            __AF_error109_v0__135_17="$__AF_error109_v0"
            echo "$__AF_error109_v0__135_17" >/dev/null 2>&1
        fi
    fi
done
