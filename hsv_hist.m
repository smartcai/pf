function h = hsv_hist(im)

  im = cv.cvtColor(im,'RGB2HSV');
  edges = {linspace(0,180,30+1),linspace(0,256,32+1)};
  h = cv.calcHist(im(:,:,1:2), edges);%只取 h 和 s，edges 是其分别的 bin 标准
