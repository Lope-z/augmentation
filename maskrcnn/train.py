# coding=utf-8

import os
import re
import cv2
import sys
import math
import time
import yaml
import random
import visualize
import matplotlib
import utils
import numpy as np
import pandas as pd
import tensorflow as tf
import model as modellib
import matplotlib.pyplot as plt

from keras import  backend as K

from PIL import Image
from config import Config

iter_num = 0


class ShapesConfig(Config):
    """Configuration for training on the toy shapes dataset.
    Derives from the base Config class and overrides values specific
    to the toy shapes dataset.
    """
    # Give the configuration a recognizable name
    NAME = "shapes"

    # Train on 1 GPU and 8 images per GPU. We can put multiple images on each
    # GPU because the images are small. Batch size is 8 (GPUs * images/GPU).
    GPU_COUNT = 1
    IMAGES_PER_GPU = 1

    # Number of classes (including background)
    NUM_CLASSES = 1 + 1  # background + 3 shapes

    # Use small images for faster training. Set the limits of the small side
    # the large side, and that determines the image shape.
    IMAGE_MIN_DIM = 448
    IMAGE_MAX_DIM = 512

    # Use smaller anchors because our image and objects are small
    RPN_ANCHOR_SCALES = (8 * 4, 16 * 4, 32 * 4, 64 * 4, 128 * 4)  # anchor side in pixels

    # Reduce training ROIs per image because the images are small and have
    # few objects. Aim to allow ROI sampling to pick 33% positive ROIs.
    TRAIN_ROIS_PER_IMAGE = 32

    # Use a small epoch since the data is simple
    STEPS_PER_EPOCH = 100

    # use small validation steps since the epoch is small
    VALIDATION_STEPS = 5


class DrugDataset(utils.Dataset):
    # 得到该图中有多少个实例（物体）
    def get_obj_index(self, image):
        n = np.max(image)
        return n

    # 解析labelme中得到的yaml文件，从而得到mask每一层对应的实例标签
    def from_yaml_get_class(self, image_id):
        info = self.image_info[image_id]
        with open(info['yaml_path']) as f:
            temp = yaml.load(f.read(), Loader=yaml.FullLoader)
            labels = temp['label_names']
            del labels[0]
        return labels

    # 重新写draw_mask
    def draw_mask(self, num_obj, mask, image, image_id):

        info = self.image_info[image_id]
        for index in range(num_obj):
            for i in range(info['width']):
                for j in range(info['height']):
                    at_pixel = image.getpixel((i, j))
                    if at_pixel == index + 1:
                        mask[j, i, index] = 1
        return mask

    # 重新写load_shapes，里面包含自己的自己的类别
    def load_shapes(self, count, img_folder, mask_folder, imglist, dataset_root_path, ext):
        """Generate the requested number of synthetic images.
        count: number of images to generate.
        height, width: the size of the generated images.
        """
        # Add classes
        self.add_class("shapes", 1, "tumor")

        for i in range(count):
            # 获取图片宽和高
            filestr = imglist[i].split(".")[0]
            cv_img = cv2.imread(img_folder + "/" + filestr + ext[0])
            mask_path = mask_folder + "/" + filestr + ext[1]
            yaml_path = dataset_root_path + "/labelme_json/" + "info.yaml"

            self.add_image("shapes", image_id=i, path=img_folder + "/" + filestr + ext[0],
                           width=cv_img.shape[1], height=cv_img.shape[0], mask_path=mask_path, yaml_path=yaml_path)
        return

    # 重写load_mask
    def load_mask(self, image_id):
        """Generate instance masks for shapes of the given image ID.
        """
        global iter_num
        print("image_id", image_id)
        info = self.image_info[image_id]
        count = 1  # number of object
        img = Image.open(info['mask_path'])
        num_obj = self.get_obj_index(img)
        mask = np.zeros([info['height'], info['width'], num_obj], dtype=np.uint8)
        mask = self.draw_mask(num_obj, mask, img, image_id)
        occlusion = np.logical_not(mask[:, :, -1]).astype(np.uint8)
        for i in range(count - 2, -1, -1):
            mask[:, :, i] = mask[:, :, i] * occlusion

            occlusion = np.logical_and(occlusion, np.logical_not(mask[:, :, i]))
        labels = []
        labels = self.from_yaml_get_class(image_id)
        labels_form = []
        for i in range(len(labels)):
            if labels[i].find("tumor") != -1:
                labels_form.append("tumor")
        class_ids = np.array([self.class_names.index(s) for s in labels_form])
        return mask, class_ids.astype(np.int32)


def get_ax(rows=1, cols=1, size=8):
    """Return a Matplotlib Axes array to be used in
    all visualizations in the notebook. Provide a
    central point to control graph sizes.

    Change the default size attribute to control the size
    of rendered images
    """
    _, ax = plt.subplots(rows, cols, figsize=(size * cols, size * rows))
    return ax


def main():
    os.environ["CUDA_VISIBLE_DEVICES"] = "0"
    sess = tf.Session()
    init = tf.global_variables_initializer()
    sess.run(init)

    # Local path to trained weights file
    COCO_MODEL_PATH = os.path.join(ROOT_DIR, "mask_rcnn_coco.h5")


    # Download COCO trained weights from Releases if needed
    if not os.path.exists(COCO_MODEL_PATH):
        utils.download_trained_weights(COCO_MODEL_PATH)


    # 基础设置

    img_folder = os.path.join(dataset_root_path, pic_class +"_img")
    mask_folder = os.path.join(dataset_root_path, pic_class + "_mask")

    imglist = dataset[train]
    random.shuffle(imglist)
    count = len(imglist)

    # train数据集准备
    train_count = int(count * 0.9)
    train_imglist = imglist[0:train_count]
    dataset_train = DrugDataset()
    dataset_train.load_shapes(train_count, img_folder, mask_folder, train_imglist, dataset_root_path, ext)
    dataset_train.prepare()

    # val数据集准备
    val_imglist = imglist[train_count:count]
    val_count = len(val_imglist)
    dataset_val = DrugDataset()
    dataset_val.load_shapes(val_count, img_folder, mask_folder, val_imglist, dataset_root_path, ext)
    dataset_val.prepare()



    config = ShapesConfig()

    config.STEPS_PER_EPOCH =  int(train_count / config.BATCH_SIZE)
    config.VALIDATION_STEPS = int(val_count / config.BATCH_SIZE)
    config.display()

    # Directory to save logs and trained model
    in_floder = floder + '_' + str(zhe_name)
    MODEL_DIR = os.path.join(ROOT_DIR, 'results', which_data_file, 'results', floder, in_floder, "logs")
    if not os.path.exists(MODEL_DIR):
        os.makedirs(MODEL_DIR)
    # Create model in training mode
    model = modellib.MaskRCNN(mode="training", config=config,
                              model_dir=MODEL_DIR)
    # checkpoint_path = model.checkpoint_path
    # log_dir = model.log_dir

    # Which weights to start with?
    init_with = "coco"  # imagenet, coco, or last

    if init_with == "imagenet":
        model.load_weights(model.get_imagenet_weights(), by_name=True)
    elif init_with == "coco":
        model.load_weights(COCO_MODEL_PATH, by_name=True,
                           exclude=["mrcnn_class_logits", "mrcnn_bbox_fc",
                                    "mrcnn_bbox", "mrcnn_mask"])
    elif init_with == "last":
        # Load the last model you trained and continue training
        model.load_weights(model.find_last()[1], by_name=True)




    matrix = {}
    model.train(dataset_train, dataset_val,
                learning_rate=config.LEARNING_RATE,
                epochs=head_epoch,
                layers='head')
    DATA_MODEL_1 = model.keras_model.history.history
    loss_dir = os.path.join(MODEL_DIR, "loss-a.csv")
    pd.DataFrame(DATA_MODEL_1).to_csv(loss_dir, index=False)

    model.train(dataset_train, dataset_val,
                learning_rate=config.LEARNING_RATE /10,
                epochs=middle_epoch,
                layers="all")
    DATA_MODEL_2 = model.keras_model.history.history
    loss_dir = os.path.join(MODEL_DIR, "loss-b.csv")
    pd.DataFrame(DATA_MODEL_2).to_csv(loss_dir, index=False)

    model.train(dataset_train, dataset_val,
                learning_rate=config.LEARNING_RATE /100,
                epochs=all_epoch,
                layers="all")
    DATA_MODEL_3 = model.keras_model.history.history
    loss_dir = os.path.join(MODEL_DIR, "loss-c.csv")
    pd.DataFrame(DATA_MODEL_3).to_csv(loss_dir, index=False)

    matrix.update({'epoch': list(range(1, all_epoch + 1))})
    for k in DATA_MODEL_2.keys():
        c = DATA_MODEL_3[k]
        b = DATA_MODEL_2[k]
        a = DATA_MODEL_1[k]

        matrix.update({k: a + b + c })
    loss_dir = os.path.join(MODEL_DIR, "loss.csv")
    pd.DataFrame(matrix).to_csv(loss_dir, index=False)


if __name__ == '__main__':

    ROOT_DIR = os.getcwd()

    whose_data_file = "D:\\data"
    which_data_file = "Dataset_BUSI"
    dataset_root_path = os.path.join(whose_data_file, which_data_file)


    pic_class = "ori"
    ext = [".png", ".png"]
    floder = pic_class + '_img_dataset'

    head_epoch = 30
    middle_epoch = 80
    all_epoch = 110


    data_dir = os.path.join(dataset_root_path, floder + '.npy')
    dataset = np.load(data_dir).item()
    for zhe_name in range(4, 5):
        train = 'train' + str(zhe_name)
        main()
        K.clear_session()

