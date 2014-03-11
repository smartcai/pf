import os

def num(s):
    try:
        return int(s)
    except exceptions.ValueError:
        return none

def rename(dir, pattern):
    files = []

    fs = os.listdir(dir)
    for f in fs:
        full_path = os.path.join(dir, f)
        if full_path.endswith(pattern):
            nm = os.path.splitext(os.path.basename(f))[0]
            ext = os.path.splitext(os.path.basename(f))[1]
            print nm, ext
            newnm = "%03d%s" % (num(nm), ext)

            new_path = os.path.join(dir, newnm)
            print full_path, new_path
            os.rename(full_path, new_path)

if __name__ == '__main__':
    dir = '/home/fei/Research/experiments/data/tracking/bolt/frames/'
    pattern = 'jpg'

    rename(dir, pattern)
