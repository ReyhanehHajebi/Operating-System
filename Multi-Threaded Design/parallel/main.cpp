#include <pthread.h>
#include <iostream>
#include <string>
#include <chrono>
#include <opencv4/opencv2/core.hpp>
#include <opencv4/opencv2/highgui.hpp>
#include <opencv4/opencv2/imgproc.hpp>

using namespace std;
using namespace cv;
using namespace chrono;

struct ThreadData {
    Mat image;
    string outputFileName;
    pthread_mutex_t* mutex;
};

void* h_revers(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    Mat& image = data->image;

    pthread_mutex_lock(data->mutex);
    int num_rows = image.rows;
    int num_cols = image.cols;
    for (int i = 0; i < num_rows; i++) {
        for (int j = 0; j < num_cols / 2; j++) {
            Vec3b temp_pixel = image.at<Vec3b>(i, j);
            image.at<Vec3b>(i, j) = image.at<Vec3b>(i, num_cols - j - 1);
            image.at<Vec3b>(i, num_cols - j - 1) = temp_pixel;
        }
    }
    imwrite(data->outputFileName, image);
    pthread_mutex_unlock(data->mutex);

    pthread_exit(NULL);
}

void* v_reverse(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    Mat& image = data->image;

    pthread_mutex_lock(data->mutex);
    int num_rows = image.rows;
    int num_cols = image.cols;
    for (int i = 0; i < num_rows / 2; i++) {
        for (int j = 0; j < num_cols; j++) {
            Vec3b temp_pixel = image.at<Vec3b>(i, j);
            image.at<Vec3b>(i, j) = image.at<Vec3b>(num_rows - i - 1, j);
            image.at<Vec3b>(num_rows - i - 1, j) = temp_pixel;
        }
    }
    imwrite(data->outputFileName, image);
    pthread_mutex_unlock(data->mutex);

    pthread_exit(NULL);
}

void* sepia_filter(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    Mat& image = data->image;

    pthread_mutex_lock(data->mutex);
    int num_rows = image.rows;
    int num_cols = image.cols;
    for (int i = 0; i < num_rows; i++) {
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
    imwrite(data->outputFileName, image);
    pthread_mutex_unlock(data->mutex);

    pthread_exit(NULL);
}

void* box_blur(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    Mat& image = data->image;

    pthread_mutex_lock(data->mutex);
    Mat output = image.clone();
    int kernel_size = 3;
    int offset = kernel_size / 2;
    for (int y = offset; y < image.rows - offset; ++y) {
        for (int x = offset; x < image.cols - offset; ++x) {
            int sum = 0;
            for (int j = -offset; j <= offset; ++j) {
                for (int i = -offset; i <= offset; ++i) {
                    sum += image.at<uchar>(y + j, x + i);
                }
            }
            output.at<uchar>(y, x) = sum / (kernel_size * kernel_size);
        }
    }
    image = output;
    imwrite(data->outputFileName, image);
    pthread_mutex_unlock(data->mutex);

    pthread_exit(NULL);
}

void* gray_to_blackwhite(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    Mat& image = data->image;

    pthread_mutex_lock(data->mutex);
    double threshold_value = 127;
    for (int x = 0; x < image.rows; ++x) {
        for (int y = 0; y < image.cols; ++y) {
            uchar pixel_value = image.at<uchar>(x, y);
            image.at<uchar>(x, y) = (pixel_value > threshold_value) ? 255 : 0;
        }
    }
    imwrite(data->outputFileName, image);
    pthread_mutex_unlock(data->mutex);

    pthread_exit(NULL);
}

void* laplacian_edge_detection(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    Mat& image = data->image;

    pthread_mutex_lock(data->mutex);
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
    imwrite(data->outputFileName, image);
    pthread_mutex_unlock(data->mutex);

    pthread_exit(NULL);
}

void* pipeline1(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    pthread_t threads[3];
    ThreadData threadData[3];

    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);

    threadData[0] = *data;
    threadData[0].outputFileName = "h-revers.bmp";
    threadData[0].mutex = &mutex;
    pthread_create(&threads[0], NULL, h_revers, (void*)&threadData[0]);

    threadData[1] = *data;
    threadData[1].outputFileName = "v-reverse.bmp";
    threadData[1].mutex = &mutex;
    pthread_create(&threads[1], NULL, v_reverse, (void*)&threadData[1]);

    threadData[2] = *data;
    threadData[2].outputFileName = "sepia-filter.bmp";
    threadData[2].mutex = &mutex;
    pthread_create(&threads[2], NULL, sepia_filter, (void*)&threadData[2]);

    for (int i = 0; i < 3; ++i) {
        pthread_join(threads[i], NULL);
    }

    pthread_mutex_destroy(&mutex);

    pthread_exit(NULL);
}

void* pipeline2(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    pthread_t threads[3];
    ThreadData threadData[3];

    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);

    threadData[0] = *data;
    threadData[0].outputFileName = "box-blur.bmp";
    threadData[0].mutex = &mutex;
    pthread_create(&threads[0], NULL, box_blur, (void*)&threadData[0]);

    threadData[1] = *data;
    threadData[1].outputFileName = "blackwhite.bmp";
    threadData[1].mutex = &mutex;
    pthread_create(&threads[1], NULL, gray_to_blackwhite, (void*)&threadData[1]);

    threadData[2] = *data;
    threadData[2].outputFileName = "edge-detection.bmp";
    threadData[2].mutex = &mutex;
    pthread_create(&threads[2], NULL, laplacian_edge_detection, (void*)&threadData[2]);

    for (int i = 0; i < 3; ++i) {
        pthread_join(threads[i], NULL);
    }

    pthread_mutex_destroy(&mutex);

    pthread_exit(NULL);
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        cout << "Bad arguments!" << endl;
        exit(EXIT_FAILURE);
    }

    const string FILE_PATH(argv[1]);

    Mat image = imread(FILE_PATH, ImreadModes::IMREAD_COLOR);
    if (image.empty()) {
        cout << "Input image empty" << endl;
        exit(EXIT_FAILURE);
    }

    Mat img_gray = imread(FILE_PATH, ImreadModes::IMREAD_GRAYSCALE);
    if (img_gray.empty()) {
        cout << "Input grayscale image empty" << endl;
        exit(EXIT_FAILURE);
    }

    pthread_t threads[2];
    ThreadData threadData[2];

    auto t1 = high_resolution_clock::now();

    threadData[0].image = image.clone();
    pthread_create(&threads[0], NULL, pipeline1, (void*)&threadData[0]);

    threadData[1].image = img_gray.clone();
    pthread_create(&threads[1], NULL, pipeline2, (void*)&threadData[1]);

    for (int i = 0; i < 2; ++i) {
        pthread_join(threads[i], NULL);
    }

    auto t2 = high_resolution_clock::now();
    cout << "Execution Time : " << duration_cast<milliseconds>(t2 - t1).count() << endl;

    image.release();
    img_gray.release();

    return 0;
}
