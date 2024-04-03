#!/bin/bash
cd $(dirname $0) || exit 1

SCRIPT_NAME=$1

mkdir $SCRIPT_NAME
if [ $? -ne 0 ]; then
    echo "Script $SCRIPT_NAME already exists."
    exit 1
fi

echo \
    "#!/bin/bash
cd \$(dirname \$0) || exit 1

echo hi from $SCRIPT_NAME

exit 0" \
    >$SCRIPT_NAME/run.sh

chmod +x $SCRIPT_NAME/run.sh

cp _template_readme.md $SCRIPT_NAME/README.md

if [[ $(uname) == "Darwin" ]]; then
    # macOS
    sed -i '' "s/<script_name>/$SCRIPT_NAME/g" $SCRIPT_NAME/README.md
else
    # Linux
    sed -i "s/<script_name>/$SCRIPT_NAME/g" $SCRIPT_NAME/README.md
fi
