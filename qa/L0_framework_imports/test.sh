#!/bin/bash -e
# used pip packages

pip_packages="jupyter matplotlib opencv-python mxnet-cu##CUDA_VERSION## tensorflow-gpu torchvision torch"

test_body() {
    # test code
    echo "---------Testing MXNET;DALI----------"
    ( set -x && python -c "import mxnet; import nvidia.dali.plugin.mxnet" )
    echo "---------Testing DALI;MXNET----------"
    ( set -x && python -c "import nvidia.dali.plugin.mxnet; import mxnet" )

    # TensorFlow supports only CUDA 9.0 now
    if [ "${CUDA_VERSION}" == "90"]; then
        echo "---------Testing TENSORFLOW;DALI----------"
        ( set -x && python -c "import tensorflow; import nvidia.dali.plugin.tf as dali_tf; daliop = dali_tf.DALIIterator()" )
        echo "---------Testing DALI;TENSORFLOW----------"
        ( set -x && python -c "import nvidia.dali.plugin.tf as dali_tf; import tensorflow; daliop = dali_tf.DALIIterator()" )
    fi

    echo "---------Testing PYTORCH;DALI----------"
    ( set -x && python -c "import torch; import nvidia.dali.plugin.pytorch" )
    echo "---------Testing DALI;PYTORCH----------"
    ( set -x && python -c "import nvidia.dali.plugin.pytorch; import torch" )
}

source ../test_template.sh
