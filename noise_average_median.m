function noise_average_median(yuvop)
    I = imread('passaros.jpg');
    
    if yuvop == true
        temp = RGBYUV(I);
        yuv = zeros(size(temp));
        yuv(:,:,1) = temp(:,:,1);
        Jsp = imnoise(yuv,'salt & pepper',0.02);
        Jgaus = imnoise(yuv,'gaussian',0,0.005);
        Jspeckle = imnoise(yuv,'speckle',0.04);
    else
        Jsp = imnoise(I,'salt & pepper',0.02);
        Jgaus = imnoise(I,'gaussian',0,0.005);
        Jspeckle = imnoise(I,'speckle',0.04);
    end

    % Noise plot

    figure('name','Noises');
    title('Graph of Sine and Cosine Between -2\pi and 2\pi')
    subplot(2,2,1); imshow(Jsp); title('Salt & Pepper')
    subplot(2,2,2); imshow(Jgaus); title('Gaussian')
    subplot(2,2,3); imshow(Jspeckle); title('Speckle')
    if yuvop == true
        subplot(2,2,4); imshow(yuv); title('Original')
    else
        subplot(2,2,4); imshow(I); title('Original')
    end

    % Average filter

    H = fspecial('average',[3 3]);
    Ksp = imfilter(Jsp,H,'replicate');
    Kgaus = imfilter(Jgaus,H,'replicate');
    Kspeckle = imfilter(Jspeckle,H,'replicate');

    % Median filter

    Lsp = Jsp;
    Lgaus = Jgaus;
    Lspeckle = Jspeckle;

    for c = 1 : 3
        Lsp(:, :, c) = medfilt2(Jsp(:, :, c), [3, 3]);
        Lgaus(:, :, c) = medfilt2(Jgaus(:, :, c), [3, 3]);
        Lspeckle(:, :, c) = medfilt2(Jspeckle(:, :, c), [3, 3]);
    end

    % After filter Plot

    figure('name','Filters');
    subplot(2,3,1); imshow(Lsp); title('Med Salt & Pepper')
    subplot(2,3,2); imshow(Lgaus); title('Med Gaussian')
    subplot(2,3,3); imshow(Lspeckle); title('Med Speckle')
    subplot(2,3,4); imshow(Ksp); title('Avg Salt & Pepper')
    subplot(2,3,5); imshow(Kgaus); title('Avg Gaussian')
    subplot(2,3,6); imshow(Kspeckle); title('Avg Speckle')

    imwrite(Lsp,'med_salt_pepper.jpg')
    imwrite(Lgaus,'med_gaussian.jpg')
    imwrite(Lspeckle,'med_speckle.jpg')
    imwrite(Ksp,'avg_salt_pepper.jpg')
    imwrite(Kgaus,'avg_gausian.jpg')
    imwrite(Kspeckle,'avg_speckle.jpg')
end