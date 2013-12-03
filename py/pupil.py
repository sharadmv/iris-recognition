import skimage
from skimage import io
io.use_plugin('gtk')
import skimage.filter as filter
from skimage.io import imshow
from skimage.transform import hough_circle
from skimage.feature import peak_local_max
from skimage.draw import circle_perimeter
from skimage.morphology import disk
from data import Dataset
import numpy as np

def find_pupil(image, threshold=25):
    image = image < threshold
    #image = filter.canny(image, sigma=2, low_threshold=10, high_threshold=50)
    return find_circles(image, np.arange(15, 40, 2))[0:1]

def find_circles(image, input_radii):
    result = hough_circle(image, input_radii)
    centers = []
    accums = []
    radii = []
    for radius, h in zip(input_radii, result):
        # For each radius, extract two circles
        peaks = peak_local_max(h, num_peaks=2)
        centers.extend(peaks)
        accums.extend(h[peaks[:, 0], peaks[:, 1]])
        radii.extend([radius, radius])
    circles = []
    for idx in np.argsort(accums)[::-1][:5]:
        center_x, center_y = centers[idx]
        radius = radii[idx]
        circles.append((center_x, center_y, radius))
    return circles
