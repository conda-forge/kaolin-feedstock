#!/bin/bash
set -ex

if [[ "$cuda_compiler_version" == "None" ]]; then
  export FORCE_CUDA=0
else
  if [[ ${cuda_compiler_version} == 11.8 ]]; then
      export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9+PTX"
  elif [[ ${cuda_compiler_version} == 12.0 ]]; then
      export TORCH_CUDA_ARCH_LIST="5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9;9.0+PTX"
  elif [[ ${cuda_compiler_version} == 12.6 ]]; then
      export TORCH_CUDA_ARCH_LIST="5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9;9.0+PTX"
  else
      echo "unsupported cuda version. edit build.sh"
      exit 1
  fi
  export FORCE_CUDA=1
fi

export IGNORE_TORCH_VER=1

# Remove 'usd-core' (PyPI) to avoid pip/conda name mismatch
sed -i -E '/^usd-core([[:space:]]*[<>=].*)?$/d' tools/requirements.txt tools/viz_requirements.txt || true

${PYTHON} -m pip install . -vv
