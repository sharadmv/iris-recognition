import skimage.filter as filter
from skimage.io import imshow
from data import Dataset
from skimage.draw import circle_perimeter, ellipse_perimeter
from pupil import find_pupil

from math import cos, sin, pi
import numpy as np

def find_iris(image, pupil, **kwargs):
    buffer = 20
    image = filter.canny(image, sigma=1, low_threshold=10, high_threshold=50)
    cx, cy, radius = pupil
    def gen_dir(f):
        return map(f, np.arange(0, 2*pi, 0.5))
    directions = zip(gen_dir(cos), gen_dir(sin))
    shape = image.shape
    points = []
    for d in directions:
        start = (cx + (radius + buffer) * d[0], cy + (radius + buffer)*d[1])
        while shape[0] > start[0] and start[0] > 0 and shape[1] > start[1] and start[1] > 0:
            pixel = map(int, start)
            if (check_neighbourhood(image, pixel)):
                points.append((pixel[0], pixel[1]))
                break
            start = (start[0] + d[0], start[1] + d[1])
    # we now have the ellipse points, so now try to fit ellipse
    # using reduce to create the design matrix [x^2, xy, y^2, x, y, 1]

    mat = reduce(lambda x, y: np.vstack([x, np.array([y[0]**2, y[0]*y[1], y[1]**2, y[0], y[1], 1])]), points, np.zeros((1, 6)))[1:,:]


    # so i shamelessly stole some ellipse fitting code from a blog post as a temporary hack. we can do better since we already know the ellipse centers though. also we probably want to do something that's not exactly least squares, since we have a lot of outliers.

    # solving the least squares problem
    A = np.dot(mat.T, mat)

    C = np.zeros((6, 6))
    C[0,2] = C[2,0] = 2; C[1,1] = -1
    e, v =  np.linalg.eig(np.dot(np.linalg.inv(A), C))
    idx = np.argmax(np.abs(e))
    a = v[:, idx]
    return image, points, a

def ellipse_center(a):
    b,c,d,f,g,a = a[1]/2, a[2], a[3]/2, a[4]/2, a[5], a[0]
    num = b*b-a*c
    x0=(c*d-b*f)/num
    y0=(a*f-b*d)/num
    return np.array([x0,y0])

def ellipse_orientation( a ):
    b,c,d,f,g,a = a[1]/2, a[2], a[3]/2, a[4]/2, a[5], a[0]
    return 0.5*np.arctan(2*b/(a-c))

def ellipse_axis_length( a ):
    b,c,d,f,g,a = a[1]/2, a[2], a[3]/2, a[4]/2, a[5], a[0]
    up = 2*(a*f*f+c*d*d+g*b*b-2*b*d*f-a*c*g)
    down1=(b*b-a*c)*( (c-a)*np.sqrt(1+4*b*b/((a-c)*(a-c)))-(c+a))
    down2=(b*b-a*c)*( (a-c)*np.sqrt(1+4*b*b/((a-c)*(a-c)))-(c+a))
    res1=np.sqrt(up/down1)
    res2=np.sqrt(up/down2)
    return np.array([res1, res2])

def check_neighbourhood(image, point, size=2):
    x, y = point
    for i in range(x - size, x + size):
        for j in range(y - size, y + size):
            if (image[i, j] > 0):
                return True
    return False

def detect(d, i,**kwargs):
    image = d.read(d.images[i])
    rgb = d.read(d.images[i], flatten=False)
    pupil = find_pupil(image)[0]
    img, points, ellipse = find_iris(image, pupil, **kwargs)
    x, y = circle_perimeter(pupil[0], pupil[1], pupil[2])
    rgb[x,y] = (220, 40, 40)
    ex, ey = ellipse_center(ellipse)
    major, minor = ellipse_axis_length(ellipse)
    orientation = ellipse_orientation(ellipse)
    x, y = ellipse_perimeter(int(ex), int(ey), int(major), int(minor), orientation)
    rgb[x,y] = (220, 40, 40)
    imshow(rgb)
if __name__ == "__main__":
    d = Dataset('data')
    detect(d, 0)
