from model import unet
import cv2
import os
import numpy as np


ROOT_DIR = os.getcwd()

which_data_file = "Dataset_BUSI"
pic_class = "trad"
zhe_name = 1

floder = pic_class + '_img_dataset'
in_floder = floder + '_' + str(zhe_name)
MODEL_DIR = os.path.join(ROOT_DIR, 'results',which_data_file,'results', floder, in_floder, "logs")
RESULT_DIR = os.path.join(ROOT_DIR, 'results', which_data_file, 'results', floder, in_floder, "results")
if not os.path.exists(RESULT_DIR):
    os.makedirs(RESULT_DIR)


test_img_files = './data/test/image/'
test_label_files = './data/test/label/'

images = os.listdir(test_img_files)


model = unet()
model.load_weights(MODEL_DIR + '\\MYUNet_70-loss0.110-val_loss0.194.h5')





for i in range(len(images)):
    img = cv2.imread(os.path.join(test_img_files,images[i]))
    img1 = cv2.resize(img ,(416, 416))
    img1 = img1.astype('float32')
    img2 = img1 / 255
    img2 = img2[np.newaxis, :, :, :]



    prediction=model.predict(img2)
    prediction = np.squeeze(prediction)
    prediction[np.nonzero(prediction < 0.5)] = 0.0
    prediction[np.nonzero(prediction >= 0.5)] = 255.
    prediction = cv2.resize(prediction, (img.shape[1],img.shape[0]))
    prediction[np.nonzero(prediction < 127)] = 0.0
    prediction[np.nonzero(prediction >= 127)] = 255.
    prediction = prediction.astype("uint8")
    cv2.imwrite(os.path.join(RESULT_DIR, images[i]), prediction)

