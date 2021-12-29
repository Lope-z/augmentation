import os
from model import unet
import tensorflow as tf
from tensorflow.keras.callbacks import ReduceLROnPlateau
from tensorflow.keras import backend as K
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.callbacks import ModelCheckpoint
from data import *
import pandas as pd


def main():

    # 生成训练数据
    train_gen = data_generator(train_files, BATCH_SIZE,
                               dict(),
                               target_size=(im_height, im_width))
    # 生成验证数据
    val_gen = data_generator(val_files, BATCH_SIZE,
                             dict(),
                             target_size=(im_height, im_width))

    model = unet()
    # 打印模型参数
    model.summary()

    checkpoint = ModelCheckpoint(
        filepath= MODEL_DIR + '\\MYUNet_{epoch:02d}-loss{loss:.3f}-val_loss{val_loss:.3f}.h5',
        monitor='val_loss',
        verbose= 1,
        save_weights_only=False,
        save_best_only=True,
        mode='auto',
        period=1
    )


    reduce_lr = ReduceLROnPlateau(monitor='val_loss', factor=0.1, patience=5, verbose=1)

    # 编译模型
    model.compile(optimizer=tf.keras.optimizers.Adam(1e-4), loss=dice_coef_loss,
                  metrics=["binary_accuracy", iou, dice_coef])


    train_num = len(os.listdir(os.path.join(train_files, 'image')))
    val_num = len(os.listdir(os.path.join(val_files, 'image')))
    history = model.fit_generator(train_gen,
                                  steps_per_epoch=train_num // BATCH_SIZE,
                                  epochs=110,
                                  validation_data=val_gen,
                                  validation_steps=val_num // BATCH_SIZE,
                                  callbacks=[checkpoint, reduce_lr])
    DATA_MODEL = history.history
    pd.DataFrame(DATA_MODEL).to_csv(MODEL_DIR + '\\loss.csv', index=False)

    # model.save_weights(MODEL_DIR + '\\myUnet.h5')


if __name__ == "__main__":

    # 图片大小
    im_width = 416
    im_height = 416

    BATCH_SIZE = 4

    ROOT_DIR = os.getcwd()


    which_data_file = "Dataset_BUSI"
    pic_class = "ori"
    zhe_name = 4


    K.clear_session()

    floder = pic_class + '_img_dataset'
    in_floder = floder + '_' + str(zhe_name)
    MODEL_DIR = os.path.join(ROOT_DIR, 'results',which_data_file,'results', floder, in_floder, "logs")
    RESULT_DIR = os.path.join(ROOT_DIR, 'results',which_data_file,'results', floder, in_floder, "results")
    if not os.path.exists(RESULT_DIR):
        os.makedirs(RESULT_DIR)
    if not os.path.exists(MODEL_DIR):
        os.makedirs(MODEL_DIR)

    train_files = './data/train/'
    val_files = './data/val/'
    main()
