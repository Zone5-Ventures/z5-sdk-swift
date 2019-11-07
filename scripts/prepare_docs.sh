if ! which jazzy >/dev/null; then
	echo "${BASH_SOURCE}:${LINENO}: warning: Jazzy is not installed. You can download it from https://github.com/realm/jazzy"
	exit
fi

jazzy \
	--module Zone5 \
	--min-acl public \
	--no-hide-documentation-coverage \
	--theme fullwidth \
	--output ./docs

rm -rf ./build
