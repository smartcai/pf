clc;
close all;

addpath('mexopencv');

title = 'bolt'; % test video
root = '';
framePath = fullfile(root, title, 'frames\');
files = dir([framePath '*.jpg']);
frames = 1 : numel(files);
nSamples = 300;

% initialization
r0 = [349, 195, 25, 60]; % centerx, centery, width, height
s0 = 1;

sigma = [0.3, 0.3, 0.1, 0.1];

for it_frm = frames
  disp([ '-> Frame', num2str(it_frm), '/', num2str(numel(frames))]);

  disp(files(it_frm).name);
  im = imread([framePath files(it_frm).name]);


  if it_frm > 1
    % create samples
    randMatrix = randn(nSamples, 4);
    samples = repmat(r0, [nSamples, 1]);
    samples =  samples + randMatrix .* repmat(sigma, [nSamples, 1]);% generate samples using Gaussian

    % compute likelihood
    sim = zeros(nSamples, 1);
    h = cell(nSamples, 1);
    for it_sample = 1 : nSamples
      r = samples(it_sample,:);
      wl = round(r(1) - r(3)/2);
      wr = round(r(1) + r(3)/2);
      hu = round(r(2) - r(4)/2);
      hd = round(r(2) + r(4)/2);
      h{it_sample} = hsv_hist(im(hu:hd,wl:wr,:));
      sim(it_sample) = cv.compareHist(h{it_sample}, tempH, 'Method', 'Intersect');% caculate observations
    end

    [~, idx] = min(sim);
    r0 = samples(idx, :);
    r = r0;
    wl = round(r(1) - r(3)/2);
    wr = round(r(1) + r(3)/2);
    hu = round(r(2) - r(4)/2);
    hd = round(r(2) + r(4)/2);
  else % == 1
    % select rectangle
    r = r0;
    wl = round(r(1) - r(3)/2);
    wr = round(r(1) + r(3)/2);
    hu = round(r(2) - r(4)/2);
    hd = round(r(2) + r(4)/2);
    tempH = hsv_hist(im(hu:hd,wl:wr,:)); % caculate the hsv_hist of the rectangle
  end
  
  clf;
  imshow(im);
  hold on;
  rectangle('Position', [wl hu r(3) r(4)], 'LineWidth',2,'LineStyle','--','EdgeColor','red');% the newly estimated position
  pause(1);% pause so that I can view the effect
end
