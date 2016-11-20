function noisy = mulNakagamiNoise(im,L,seed)
    s = RandStream('mt19937ar','Seed',seed);
    noise_int = mean(randn(s, [size(im, 1),size(im, 2),2*L] ).^2,3);
    noisy = sqrt(noise_int).*im;