#! /bin/bash

xhost +
docker run --privileged --rm --network host -it \
  --gpus all --shm-size=16g --ulimit memlock=-1 --ulimit stack=67108864 \
  --volume "$(pwd)"/PlaneSweepPose/output/:/PlaneSweepPose/output/ \
  --volume "$(pwd)"/PlaneSweepPose/lib/dataset/:/PlaneSweepPose/lib/dataset/ \
  --volume "$(pwd)"/PlaneSweepPose/lib/utils/:/PlaneSweepPose/lib/utils/ \
  --volume "$(pwd)"/PlaneSweepPose/run/:/PlaneSweepPose/run/ \
  --volume "$(pwd)"/PlaneSweepPose/configs/:/PlaneSweepPose/configs/ \
  --volume "$(pwd)"/../datasets/:/datasets/ \
  --volume "$(pwd)"/../datasets/shelf/Shelf/:/PlaneSweepPose/data/Shelf/ \
  --volume "$(pwd)"/../datasets/campus/CampusSeq1/:/PlaneSweepPose/data/Campus/ \
  --volume "$(pwd)"/PlaneSweepPose/data/panoptic_training_pose.pkl:/PlaneSweepPose/data/panoptic_training_pose.pkl \
  --volume "$(pwd)"/PlaneSweepPose/data/pred_shelf_maskrcnn_hrnet_coco.pkl:/PlaneSweepPose/data/Shelf/pred_shelf_maskrcnn_hrnet_coco.pkl \
  --volume "$(pwd)"/PlaneSweepPose/data/pred_campus_maskrcnn_hrnet_coco.pkl:/PlaneSweepPose/data/Campus/pred_campus_maskrcnn_hrnet_coco.pkl \
  --volume /tmp/.X11-unix:/tmp/.X11-unix \
  --env DISPLAY --env QT_X11_NO_MITSHM=1 \
  planesweeppose
