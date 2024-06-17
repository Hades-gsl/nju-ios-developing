import logging
import urllib.request

import cv2
import numpy as np
import pytesseract
from pdf2image import convert_from_path
from pytesseract import pytesseract

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(name)s - %(message)s')
handler = logging.StreamHandler()
handler.setFormatter(formatter)
logger.addHandler(handler)


def ocr(url, destination, length_threshold, block_count):
    # 下载文件
    try:
        urllib.request.urlretrieve(url, destination)
        logger.info(f"文件下载成功: {destination}")
    except Exception as e:
        logger.error(f'文件下载失败: {e}')
        return None

    # pdf转图片
    images = convert_from_path(destination)

    index = [0, len(images) - 1]

    ret = []

    for idx in range(2):
        # 图片转灰度
        image = cv2.cvtColor(np.asarray(images[index[idx]]), cv2.COLOR_RGB2BGR)
        edges = cv2.Canny(image, 50, 150)

        # 查找轮廓
        contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        # 只保留长度大于该阈值的边缘
        large_contours = [contour for contour in contours if
                          cv2.arcLength(contour, closed=True) > length_threshold[idx]]

        contour = large_contours[-1]
        x, y, w, h = cv2.boundingRect(contour)
        cv2.rectangle(image, (x, y + h), (x + w, y + h), color=(0, 255, 0), thickness=2)
        cropped = image[y + h - w - 3:y + h, x:x + w]
        
#        cv2.imshow('cropped', cropped)
#        cv2.waitKey(0)

        height, width = cropped.shape[:2]
        block_height = height // block_count
        block_width = width // block_count

        matrix = None
        if idx == 0:
            matrix = np.empty((block_count, block_count, 3), dtype='U10')
        else:
            matrix = np.empty((block_count, block_count), dtype='U1')

        logger.debug('problem' if idx == 0 else 'answer')

        # 识别每个格子
        for i in range(block_count):
            for j in range(block_count):
                y_start, y_end = i * block_height, (i + 1) * block_height
                x_start, x_end = j * block_width, (j + 1) * block_width

                bias = 7
                block = cropped[y_start + bias:y_end - bias, x_start + bias:x_end - bias]
                text1 = pytesseract.image_to_string(block,
                                                    config='--psm 10 --oem 3 -c tessedit_char_whitelist=0123456789+-x/')
                bias = 8
                block = cropped[y_start + bias:y_end - bias, x_start + bias:x_end - bias]
                text2 = pytesseract.image_to_string(block,
                                                    config='--psm 10 --oem 3 -c tessedit_char_whitelist=0123456789+-x/')
                text = text1 if len(text1) > len(text2) else text2

                if text != '':
                    if idx == 0:
                        matrix[i][j][0] = text[:-1]
                        logger.debug(f'第{i + 1}行，第{j + 1}列：{text}')
                    else:
                        matrix[i][j] = text[:-1]
                        logger.debug(f'第{i + 1}行，第{j + 1}列：{text}')
                else:
                    if idx == 0:
                        matrix[i][j][0] = ' '
                    else:
                        matrix[i][j] = ' '

                if idx == 0:
                    x, y = x_end - bias, y_end - bias
                    assert cropped[y, x][0] != 0
                    matrix[i][j][1] = '1' if is_bold(cropped, x, y, True) else '0'
                    matrix[i][j][2] = '1' if is_bold(cropped, x, y, False) else '0'

#                cv2.imshow('block', block)
#                cv2.waitKey(0)

        ret.append(matrix.tolist())

    return ret


# 判断是否为粗线
def is_bold(cropped, x, y, is_horizontal):
    cnt = 0
    while cropped[y, x][0] != 0 and y < cropped.shape[0] - 1 and x < cropped.shape[1] - 1:
        if is_horizontal:
            x += 1
        else:
            y += 1
    while cropped[y, x][0] == 0 and y < cropped.shape[0] - 1 and x < cropped.shape[1] - 1:
        if is_horizontal:
            x += 1
        else:
            y += 1
        cnt += 1
    logger.debug('x' if is_horizontal else 'y' + f': {cnt}')
    return cnt > 4


if __name__ == "__main__":
    url = "https://files.krazydad.com/inkies/sfiles/INKY_v3_6E_b006_1pp.pdf"
    destination = url.split('/')[-1]
    length_threshold = [800, 300]
    block_count = 6
    ret = ocr(url, destination, length_threshold, block_count)
    if ret is not None:
        logger.info(ret[0])
        logger.info(ret[1])
