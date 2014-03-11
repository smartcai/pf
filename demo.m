clc;
close all;

addpath(genpath('~/Research/experiments/vendor/mexopencv/'));

title = 'bolt'; % test video
root = '.';
framePath = fullfile(root, title, 'frames/');
files = dir([framePath '*.jpg']);
frames = 1 : numel(files);

nSamples = 300;

% initialization
r0 = [349, 195, 25, 60]; % centerx, centery, width, height
s0 = 1;

sigma = [0.3, 0.3, 0.1, 0.1];

for it_frm = frames
  disp([ '-> Frame', num2str(it_frm), '/', num2str(numel(frames))])

  disp(files(it_frm).name)
  im = imread([framePath files(it_frm).name]);

  if it_frm > 1
    disp(num2str(it_frm))
    % create samples
    randMatrix = randn(nSamples, 4);
    samples = repmat(r0, [nSamples, 1]);
    samples =  samples + randMatrix .* repmat(sigma, [nSamples, 1]);

    % compute likelihood
    sim = zeros(nSamples, 1);
    h = cell(nSamples, 1);
    for it_sample = 1 : nSamples
      h{it_sample} = hsv_hist(im);
      sim(it_sample) = cv.compareHist(h{it_sample}, tempH, 'Method', 'Intersect');
    end

    [~, idx] = min(sim);
    r0 = samples(idx, :);
    tempH = h{idx};
  else % == 1
    tempH = hsv_hist(im);
  end

  r = [r0(1)-r0(3)/2, r0(2)-r0(4)/2, r0(3), r0(4)];
  r = floor(r + .5);

  im(r(2), r(1) : r(1) + r(3), :) = repmat([255, 0, 0], [r(3)+1, 1]);
  im(r(2) + r(4), r(1) : r(1) + r(3), :) = repmat([255, 0, 0], [r(3)+1, 1]);

  im(r(2) : r(2) + r(4), r(1), :) = repmat([255, 0, 0], [r(4)+1, 1]);
  im(r(2) : r(2) + r(4), r(1) + r(3), :) = repmat([255, 0, 0], [r(4)+1, 1]);

  savePath = fullfile(root, title, 'pf/');
  saveName = fullfile(savePath, files(it_frm).name);
  imwrite(im, saveName, 'jpg');
end
