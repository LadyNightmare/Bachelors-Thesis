import cv2
import numpy as np

from face_detector import get_face_detector, find_faces
from face_landmarks import get_landmark_model, detect_marks

import logging

logger = logging.getLogger("gunicorn.error")

def eye_on_mask(mask, side, shape):
    """
    Create ROI on mask of the size of eyes and also find the extreme points of each eye

    Parameters
    ----------
    mask : np.uint8
        Blank mask to draw eyes on
    side : list of int
        the facial landmark numbers of eyes
    shape : Array of uint32
        Facial landmarks

    Returns
    -------
    mask : np.uint8
        Mask with region of interest drawn
    [l, t, r, b] : list
        left, top, right, and bottommost points of ROI

    """
    points = [shape[i] for i in side]
    points = np.array(points, dtype=np.int32)
    mask = cv2.fillConvexPoly(mask, points, 255)
    l = points[0][0]
    t = (points[1][1] + points[2][1]) // 2
    r = points[3][0]
    b = (points[4][1] + points[5][1]) // 2
    return mask, [l, t, r, b]


def find_eyeball_position(end_points, cx, cy, right_data_list, left_data_list):
    """Find and return the eyeball positions, i.e. left or right or top or normal"""
    x_ratio = (end_points[0] - cx) / (cx - end_points[2])
    y_ratio = (cy - end_points[1]) / (end_points[3] - cy)
    if x_ratio > 3:
        left_data_list.append(x_ratio)
        return 1
    elif x_ratio < 0.33:
        right_data_list.append(x_ratio)
        return 2
    elif y_ratio < 0.33:
        return 3
    else:
        return 0


def count_wrong_meassurements(list_with_data, right=False):
    wrong_points = 0
    if right:
        for i in range(len(list_with_data) - 1):
            if list_with_data[i] < list_with_data[i + 1]:
                wrong_points += 1
    else:
        for i in range(len(list_with_data) - 1):
            if list_with_data[i] > list_with_data[i + 1]:
                wrong_points += 1
    return wrong_points


def contouring(thresh, mid, img, end_points, right, right_data_list, left_data_list):
    """
    Find the largest contour on an image divided by a midpoint and subsequently the eye position

    Parameters
    ----------
    thresh : Array of uint8
        Thresholded image of one side containing the eyeball
    mid : int
        The mid point between the eyes
    img : Array of uint8
        Original Image
    end_points : list
        List containing the exteme points of eye
    right : boolean, optional
        Whether calculating for right eye or left eye. The default is False.
    right_data_list: list
    left_data_list: list

    Returns
    -------
    pos: int
        the position where eyeball is:
            0 for normal
            1 for left
            2 for right

    """
    cnts, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    try:
        cnt = max(cnts, key=cv2.contourArea)
        m = cv2.moments(cnt)
        cx = int(m['m10'] / m['m00'])
        cy = int(m['m01'] / m['m00'])
        if right:
            cx += mid
        pos = find_eyeball_position(end_points, cx, cy, right_data_list, left_data_list)
        return pos
    except Exception:
        pass


def process_thresh(thresh):
    """
    Preprocessing the thresholded image

    Parameters
    ----------
    thresh : Array of uint8
        Thresholded image to preprocess

    Returns
    -------
    thresh : Array of uint8
        Processed thresholded image

    """
    thresh = cv2.erode(thresh, None, iterations=2)
    thresh = cv2.dilate(thresh, None, iterations=4)
    thresh = cv2.medianBlur(thresh, 3)
    thresh = cv2.bitwise_not(thresh)
    return thresh


def print_eye_pos(img, left, right):
    """
    Print the side where eye is looking and display on image

    Parameters
    ----------
    img : Array of uint8
        Image to display on
    left : int
        Position obtained of left eye.
    right : int
        Position obtained of right eye.

    Returns
    -------
    None.

    """
    if left == right and left != 0:
        text = ''
        if left == 1:
            print('Looking left')
            text = 'Looking left'
        elif left == 2:
            print('Looking right')
            text = 'Looking right'
        elif left == 3:
            print('Looking up')
            text = 'Looking up'
        font = cv2.FONT_HERSHEY_SIMPLEX
        cv2.putText(img, text, (30, 30), font,
                    1, (0, 255, 255), 2, cv2.LINE_AA)


def get_percentage(video, gaze):
    try:
        left_data_list = []
        right_data_list = []
        face_model = get_face_detector()
        landmark_model = get_landmark_model()
        left = [36, 37, 38, 39, 40, 41]
        right = [42, 43, 44, 45, 46, 47]

        cap = cv2.VideoCapture(video)
        kernel = np.ones((9, 9), np.uint8)

        while cap.isOpened():
            ret, img = cap.read()
            if ret:
                rects = find_faces(img, face_model)

                for rect in rects:
                    try:
                        shape = detect_marks(img, landmark_model, rect)
                    except cv2.error:
                        continue
                    mask = np.zeros(img.shape[:2], dtype=np.uint8)
                    mask, end_points_left = eye_on_mask(mask, left, shape)
                    mask, end_points_right = eye_on_mask(mask, right, shape)
                    mask = cv2.dilate(mask, kernel, 5)

                    eyes = cv2.bitwise_and(img, img, mask=mask)
                    mask = (eyes == [0, 0, 0]).all(axis=2)
                    eyes[mask] = [255, 255, 255]
                    mid = int((shape[42][0] + shape[39][0]) // 2)
                    eyes_gray = cv2.cvtColor(eyes, cv2.COLOR_BGR2GRAY)
                    threshold = 75 # cv2.getTrackbarPos('threshold', 'image')
                    _, thresh = cv2.threshold(eyes_gray, threshold, 255, cv2.THRESH_BINARY)
                    thresh = process_thresh(thresh)
                    contouring(thresh[:, 0:mid], mid, img, end_points_left, False, right_data_list, left_data_list)
                    contouring(thresh[:, mid:], mid, img, end_points_right, True, right_data_list, left_data_list)
                    for (x, y) in shape[36:48]:
                        cv2.circle(img, (x, y), 2, (255, 0, 0), -1)
            else:
                break
        cap.release()
        cv2.destroyAllWindows()
        try:
            if gaze == 'right':
                result = count_wrong_meassurements(right_data_list, True) / len(right_data_list)
            else:
                 result = count_wrong_meassurements(left_data_list) / len(left_data_list)
            return 1 - result
        except ZeroDivisionError:
            return 0
    except cv2.error:
        logger.exception("Exception detecting eyes")
        return 0  # If eyes are not detected, return 'undetected' result