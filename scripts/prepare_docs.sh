if ! which jazzy >/dev/null; then
	echo "${BASH_SOURCE}:${LINENO}: warning: Jazzy is not installed. You can download it from https://github.com/realm/jazzy"
	exit
fi

jazzy \
	--module Zone5 \
	--min-acl public \
	--swift-build-tool spm \
	--hide-documentation-coverage \
	--title "Zone5 SDK for Swift" \
	--author_url https://zone5ventures.com \
	--github_url https://github.com/Zone5-Ventures/z5-sdk-swift \
	--theme fullwidth \
	--output ./docs

rm -rf ./build
