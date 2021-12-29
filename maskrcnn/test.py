#coding=utf-8

import os
import sys
import cv2
import math
import time
import xlrd
import xlwt
import utils
import skimage.io
import matplotlib
import numpy as np
import model as modellib
import visualize as visualize
import matplotlib.pyplot as plt


from scipy import misc
from tqdm import *
from glob import glob
from config import Config


class ShapesConfig(Config):

    NAME = "shapes"

    GPU_COUNT = 1
    IMAGES_PER_GPU = 1

    NUM_CLASSES = 1 + 1

    IMAGE_MIN_DIM = 448
    IMAGE_MAX_DIM = 512

    RPN_ANCHOR_SCALES = (8 * 4, 16 * 4, 32 * 4, 64 * 4, 128 * 4)

    TRAIN_ROIS_PER_IMAGE = 32

    # Use a small epoch since the data is simple
    STEPS_PER_EPOCH = 100

    # use small validation steps since the epoch is small
    VALIDATION_STEPS = 5


class InferenceConfig(ShapesConfig):

    GPU_COUNT = 1
    IMAGES_PER_GPU = 1



def main():

    in_floder = floder + '_' + str(zhe_name)
    MODEL_DIR = os.path.join(ROOT_DIR, 'results',which_data_file,'results', floder, in_floder, "logs")
    RESULT_DIR = os.path.join(ROOT_DIR, 'results',which_data_file,'results', floder, in_floder, "results")
    if not os.path.exists(RESULT_DIR):
        os.makedirs(RESULT_DIR)

    Excel_name = "value_"+in_floder
    MASK_DIR = os.path.join(dataset_root_path , pic_class +"_mask")
    IMAGE_DIR = os.path.join(dataset_root_path, pic_class +"_img")


    # Local path to trained weights file
    COCO_MODEL_PATH = os.path.join(MODEL_DIR, MODEL_NAME)

    if not os.path.exists(COCO_MODEL_PATH):
        utils.download_trained_weights(COCO_MODEL_PATH)


    config = InferenceConfig()

    model = modellib.MaskRCNN(mode="inference", model_dir=ROOT_DIR, config=config)
    print("Loading weights from ", model)
    model.load_weights(COCO_MODEL_PATH , by_name=True)
    class_names = ['BG', 'tumor']

    count = dataset[test]



    for i in tqdm(range(len(count))):
        _ = count[i].split('.')
        image_name = _[0]
        path = os.path.join(IMAGE_DIR, image_name + ext[0])
        if os.path.isfile(path):
            image = skimage.io.imread(os.path.join(path))

            # Run detection
            results = model.detect([image], verbose=0)
            r = results[0]

            if r['rois'].shape[0] == 0:
                masks = np.zeros((r['masks'].shape[0],r['masks'].shape[1],2))

            else:
                masks = (r['masks'] + 0)

            zcl_masks = masks[:, :, 0]
            cv2.imwrite(RESULT_DIR + "\\" + image_name + ".png", zcl_masks * 255)




if __name__ == '__main__':

    ROOT_DIR = os.getcwd()
    whose_data_file = "D:\\data"
    # which_data_file = "US_guiyi"
    which_data_file = "Dataset_BUSI"
    dataset_root_path = os.path.join(whose_data_file, which_data_file)

    pic_class = "trad"
    ext = [".png", ".png"]
    floder = pic_class + '_img_dataset'


    data_dir = os.path.join(dataset_root_path, floder + '.npy')
    dataset = np.load(data_dir).item()
    for zhe_name in range(4,5):
        MODEL_NAME = 'mask_rcnn_shapes_0002.h5'
        test = 'test' + str(zhe_name)
        main()

