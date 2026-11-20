#!/bin/bash

# This script is responsible for installing a built
# RCPCustomComponents.framework into a location that
# Reality Composer Pro can find it at (<repo>/Plugins)
#
# This gets run as a pre-run script for the `RCPCustomComponents` target.
# If you aren't running as a macOS target, this causes the run to fail
# and not do anything.

# Errors => fail build
set -eo pipefail

if [ "${PLATFORM_NAME}" != "macosx" ]; then
    echo "Not running Chaparral Village on macOS. Please adjust the target destination."
    exit 1
fi

# Resolve the symlinked built products directory for the framework.
FRAMEWORK_NAME="${PRODUCT_NAME}"
SOURCE_PATH="${BUILT_PRODUCTS_DIR}/PackageFrameworks/${FRAMEWORK_NAME}.framework"
BUILT_FRAMEWORK=$(cd "${SOURCE_PATH}"; pwd -P)

PROJECT_DIR=$(realpath "${WORKSPACE_PATH}/../..")

INSTALL_FOLDER="${PROJECT_DIR}/Plugins"
INSTALL_PATH="${INSTALL_FOLDER}/${FRAMEWORK_NAME}.framework"

# Remove already installed plug-in.
if [ -d "${INSTALL_PATH}" ]; then
    rm -rf "${INSTALL_PATH}"
fi

# Create the install folder in case it doesn't exit.
mkdir -p "${INSTALL_FOLDER}"

# Copy framework over
cp -a "${BUILT_FRAMEWORK}" "${INSTALL_PATH}"
