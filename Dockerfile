FROM nvcr.io/nvidia/pytorch:20.06-py3

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
WORKDIR /

RUN apt-get update && apt-get install -y --no-install-recommends feh
RUN apt-get update && apt-get install -y --no-install-recommends python3-opencv
RUN pip uninstall -y opencv-python && pip install --no-cache "opencv-python<4.3"

# Show matplotlib images
RUN apt-get update && apt-get install -y --no-install-recommends python3-tk

# Update pip to allow installation of skelda in editable mode
RUN apt-get update && apt-get install -y --no-install-recommends python3-pip
RUN pip3 install --upgrade --no-cache-dir pip

# Install PlaneSweepPose
RUN git clone https://github.com/jiahaoLjh/PlaneSweepPose.git
RUN cd /PlaneSweepPose/; sed -i "s/numpy==.*/numpy/g" requirements.txt
RUN cd /PlaneSweepPose/; sed -i "s/PyYAML==.*/PyYAML/g" requirements.txt
RUN cd /PlaneSweepPose/; sed -i "s/scipy==.*/scipy/g" requirements.txt
RUN cd /PlaneSweepPose/; sed -i "s/torch==.*/torch/g" requirements.txt
RUN cd /PlaneSweepPose/; sed -i "s/torchvision==.*/torchvision/g" requirements.txt
RUN cd /PlaneSweepPose/; cat requirements.txt
RUN cd /PlaneSweepPose/; pip install --no-cache -r requirements.txt

# Switch to file import instead of module import because a "models" directory also exists in Kapao
# This solves some problems when trying to import models from both repos
RUN cd /PlaneSweepPose/lib/models/; sed -i 's/from models.softargmax import SoftArgMax/exec("try: from softargmax import SoftArgMax\\nexcept ImportError: from .softargmax import SoftArgMax")/g' mvmppe.py
RUN cd /PlaneSweepPose/lib/models/; sed -i 's/from models.cnns import PoseCNN, JointCNN/exec("try: from cnns import PoseCNN, JointCNN\\nexcept ImportError: from .cnns import PoseCNN, JointCNN")/g' mvmppe.py

# Fix an issue with deprecated numpy functions
RUN pip3 install "numpy<1.20"

# Fix an undefined symbol error with ompi
RUN echo "ldconfig" >> ~/.bashrc

WORKDIR /PlaneSweepPose/
CMD ["/bin/bash"]
