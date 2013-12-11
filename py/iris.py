import skimage.filter as filter
from skimage.io import imshow
from data import Dataset
from skimage.draw import circle_perimeter, ellipse_perimeter
from pupil import find_pupil

from math import cos, sin, pi
import numpy as np

class Ray:
    def __init__(self, img, start, direction, n_size=1):
        self.img = img
        self.start = start
        self.direction = direction
        self.n_size = n_size

    def fire(self):
        point = self.start
        x1, y1 = self.img.shape
        while point[0] > self.n_size and point[0] < x1 - self.n_size \
                and  point[1] > self.n_size and point[1] < y1 - self.n_size:
            point = point[0] + self.direction[0], point[1] + self.direction[1]
            if self.check_neighbourhood(point, self.n_size):
                return point
        return None

    def check_neighbourhood(self, point, size=1):
        x, y = map(int, point)
        for i in range(x - size, x + size):
            for j in range(y - size, y + size):
                if (self.img[i, j] > 0):
                    return True
        return False

class Ellipse:
    def __init__(self):
        self._center = None
        self._axes = None
        self._orientation = None
        self._coeff = None

    def fit_with_center(self, center, points):
        if center != None:
            self._center = center
        mat = reduce(lambda x, y: np.vstack([x, np.array([y[0]**2, y[0]*y[1], y[1]**2, y[0], y[1], 1])]), points, np.zeros((1, 6)))[1:,:]
        # so i shamelessly stole some ellipse fitting code from a blog post as a temporary hack. we can do better since we already know the ellipse centers though. also we probably want to do something that's not exactly least squares, since we have a lot of outliers.
        # solving the least squares problem
        A = np.dot(mat.T, mat)
        C = np.zeros((6, 6))
        C[0,2] = C[2,0] = 2; C[1,1] = -1
        e, v =  np.linalg.eig(np.dot(np.linalg.inv(A), C))
        idx = np.argmax(np.abs(e))
        a = v[:, idx]
        self._coeff = a
        return self

    @property
    def center(self):
        if self._center == None:
            b,c,d,f,g,a = self._coeff[1]/2, self._coeff[2], self._coeff[3]/2, self._coeff[4]/2, self._coeff[5], self._coeff[0]
            num = b*b-a*c
            x0=(c*d-b*f)/num
            y0=(a*f-b*d)/num
            self._center = np.array([x0, y0])
        return self._center

    @property
    def axes(self):
        if self._axes == None:
            b,c,d,f,g,a = self._coeff[1]/2, self._coeff[2], self._coeff[3]/2, self._coeff[4]/2, self._coeff[5], self._coeff[0]
            up = 2*(a*f*f+c*d*d+g*b*b-2*b*d*f-a*c*g)
            down1=(b*b-a*c)*( (c-a)*np.sqrt(1+4*b*b/((a-c)*(a-c)))-(c+a))
            down2=(b*b-a*c)*( (a-c)*np.sqrt(1+4*b*b/((a-c)*(a-c)))-(c+a))
            res1=np.sqrt(up/down1)
            res2=np.sqrt(up/down2)
            return np.array([res1, res2])
        return self._axes

    @property
    def orientation(self):
        if self._orientation == None:
            b,c,d,f,g,a = self._coeff[1]/2, self._coeff[2], self._coeff[3]/2, self._coeff[4]/2, self._coeff[5], self._coeff[0]
            self._orientation = 0.5*np.arctan(2*b/(a-c))
        return self._orientation

def chunks(l, n):
    for i in range(0, len(l), n):
        yield l[i:i+n]

def get_segments(num_rays, step=0.1):
    return list(chunks(np.arange(0, 2*pi, step), num_rays))

def find_iris(image, pupil, **kwargs):
    buffer = 20
    # run canny
    image = filter.canny(image, sigma=1, low_threshold=10, high_threshold=50)
    cx, cy, radius = pupil

    segments = get_segments(17, step=0.05)
    # get ray directions
    directions = zip(map(cos, segments[0]), map(sin, segments[0]))
    shape = image.shape
    points = []
    for d in directions:
        start = (cx + (radius + buffer) * d[0], cy + (radius + buffer)*d[1])
        ray = Ray(image, start, d)
        point = ray.fire()
        if point != None:
            points.append(point)

    for p in points:
        x, y = circle_perimeter(int(p[0]), int(p[1]), 3)
        rgb[x,y] = (220, 40, 40)

    e = Ellipse().fit_with_center(None, points)
    return image, points, e

rgb = None
def detect(d, i,**kwargs):
    image = d.read(d.images[i])
    global rgb
    rgb = d.read(d.images[i], flatten=False)
    pupil = find_pupil(image)[0]
    img, points, ellipse = find_iris(image, pupil, **kwargs)
    x, y = circle_perimeter(pupil[0], pupil[1], pupil[2])
    rgb[x,y] = (220, 40, 40)
    ex, ey = ellipse.center
    major, minor = ellipse.axes
    orientation = ellipse.orientation
    x, y = ellipse_perimeter(int(ex), int(ey), int(major), int(minor), orientation)
    rgb[x,y] = (220, 40, 40)
    imshow(rgb)

if __name__ == "__main__":
    d = Dataset('../data')
    detect(d, 0)
