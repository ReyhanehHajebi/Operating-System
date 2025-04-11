#include <iostream>
#include <string>
#include <chrono>
#include <opencv4/opencv2/core.hpp>
#include <opencv4/opencv2/highgui.hpp>
#include <opencv4/opencv2/imgproc.hpp>


using namespace std;
using namespace cv;
using namespace chrono;

void h_revers(Mat& image) {

    int num_rows = image.rows;  
    int num_cols = image.cols;  


    for (int i = 0; i < num_rows ; i++) {
        for (int j = 0; j < num_cols / 2; j++) {
            Vec3b temp_pixel = image.at<Vec3b>(i, j);
            image.at<Vec3b>(i, j) = image.at<Vec3b>(i, num_cols - j -1);
            image.at<Vec3b>(i, num_cols - j -1) = temp_pixel;
        }
    }

}

void v_reverse(Mat& image) {

    int num_rows = image.rows; 
    int num_cols = image.cols;  


    for (int i = 0; i < num_rows / 2; i++) {
        for (int j = 0; j < num_cols; j++) {
            Vec3b temp_pixel = image.at<Vec3b>(i, j);
            image.at<Vec3b>(i, j) = image.at<Vec3b>(num_rows - i - 1, j);
            image.at<Vec3b>(num_rows - i - 1, j) = temp_pixel;
        }
    }

}

void sepia_filter(Mat& image) {

    int num_rows = image.rows; 
    int num_cols = image.cols;  

    for (int i = 0; i < num_rows ; i++) {
        for (int j = 0; j < num_cols; j++) {

            int blue = image.at<Vec3b>(i, j)[0];
            int green = image.at<Vec3b>(i, j)[1];
            int red = image.at<Vec3b>(i, j)[2];

            int sepiaBlue = min(255, static_cast<int>(0.272 * red + 0.534 * green + 0.131 * blue));
            int sepiaGreen = min(255, static_cast<int>(0.349 * red + 0.686 * green + 0.168 * blue));
            int sepiaRed = min(255, static_cast<int>(0.393 * red + 0.769 * green + 0.189 * blue));
 
            sepiaBlue = max(0, sepiaBlue);
            sepiaGreen = max(0, sepiaGreen);
            sepiaRed = max(0, sepiaRed);

            image.at<Vec3b>(i, j)[0] = sepiaBlue;
            image.at<Vec3b>(i, j)[1] = sepiaGreen;
            image.at<Vec3b>(i, j)[2] = sepiaRed;



        }
    }

}

void box_blur(Mat& image,int kernel_size) {

    int offset = kernel_size / 2;

    for (int y = offset; y < image.rows - offset; ++y) {
        for (int x = offset; x < image.cols - offset; ++x) {
            int sum = 0;
            for (int j = -offset; j <= offset; ++j) {
                for (int i = -offset; i <= offset; ++i) {
                    sum += image.at<uchar>(y + j, x + i);
                }
            }
            image.at<uchar>(y, x) = sum / (kernel_size * kernel_size);
        }
    }

}

void gray_to_blackwhite(Mat& image,double threshold_value) {

    for (int x = 0; x < image.rows; ++x) {
        for (int y = 0; y < image.cols; ++y) {
            uchar pixel_value = image.at<uchar>(x, y);
            image.at<uchar>(x, y) = (pixel_value > threshold_value) ? 255 : 0;
        }
    }

}

void laplacian_edge_detection(Mat& image)  {

    Mat output = image.clone();

    int kernel[3][3] = {
        { 0, -1,  0},
        {-1,  4, -1},
        { 0, -1,  0}
    };

    int rows = image.rows;
    int cols = image.cols;

    for (int y = 1; y < rows - 1; ++y) {

        for (int x = 1; x < cols - 1; ++x) {

            int sum = 0;
            
            for (int j = -1; j <= 1; ++j) {

                for (int i = -1; i <= 1; ++i) {

                    sum += kernel[j + 1][i + 1] * image.at<uchar>(y + j, x + i);
                }
            }
            output.at<uchar>(y, x) = saturate_cast<uchar>(sum);
        }
    }

    image = output;

}

int main(int argc, char* argv[]) {

    if(argc != 2) {
        cout << "Bad arguments!" << endl;
        exit(EXIT_FAILURE);
    }

    const string FILE_PATH(argv[1]);

    Mat image = imread(FILE_PATH, ImreadModes::IMREAD_COLOR);
    
    if(image.empty()) {
        cout << "Input image empty" << endl;
        exit(EXIT_FAILURE);
    }

    auto t1 = high_resolution_clock::now();
    h_revers(image);
    imwrite("h-revers.bmp", image);
   
    v_reverse(image);
    imwrite("v-reverse.bmp", image);

    sepia_filter(image);
    imwrite("sepia-filter.bmp", image);

    image.release();



    Mat img_gray = imread(FILE_PATH,ImreadModes::IMREAD_GRAYSCALE);

    if(img_gray.empty()) {

        cout << "Input grayscale image empty" << endl;
        exit(EXIT_FAILURE);
    }

    int kernel_size = 3;
    box_blur(img_gray,kernel_size);
    imwrite("box-blur.bmp", img_gray);
    
    double threshold_value = 127;
   gray_to_blackwhite(img_gray,threshold_value);
   imwrite("blackwhite.bmp", img_gray);

    laplacian_edge_detection(img_gray);
    imwrite("edge-detection.bmp", img_gray);

    auto t2 = high_resolution_clock::now();

    cout << "Execution Time : " << duration_cast<milliseconds>(t2 - t1).count() << endl;


    img_gray.release();

    return 0;
}