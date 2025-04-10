#include <iostream>
#include <string>

#include <opencv4/opencv2/core.hpp>
#include <opencv4/opencv2/highgui.hpp>
#include <opencv4/opencv2/imgproc.hpp>


int main(int argc, char* argv[])
{
    if(argc != 2)
    {
        std::cout << "Bad arguments!" << std::endl;
        exit(EXIT_FAILURE);
    }
    const std::string FILE_PATH(argv[1]);
    cv::Mat img_color, img_gray;
    img_color = cv::imread(FILE_PATH, cv::ImreadModes::IMREAD_ANYCOLOR);
    cv::cvtColor(img_color, img_gray,
        cv::ColorConversionCodes::COLOR_BGR2GRAY);

    if(img_color.empty() || img_gray.empty())
    {
        std::cout << "input image empty" << std::endl;
        exit(EXIT_FAILURE);
    }
}