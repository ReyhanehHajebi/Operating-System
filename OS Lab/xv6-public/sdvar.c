#include "types.h"
#include "user.h"
#include "stat.h"
#include "fcntl.h"
#define MINDIFF 2.25e-308

int sqroot(int square)
{
    double root = square / 3, last, diff = 1;
    if (square == 2 || square == 1)
        return 1;
    if (square <= 0)
        return 0;
    do
    {
        last = root;
        root = (root + square / root) / 2;
        diff = root - last;
    } while (diff > MINDIFF || diff < -MINDIFF);
    return root;
}

double calcAverage(int numArray[], int size)
{
    double sum = 0;
    for (int i = 0; i < size; i++)
        sum += numArray[i];
    return sum / size;
}

int calcVariance(int numArray[], double size)
{
    double average = calcAverage(numArray, size);

    double squaredSum = 0;
    for (int i = 0; i < size; i++)
    {
        double a = numArray[i] - average;
        squaredSum += a * a;
    }

    return (int)squaredSum / size;
}

int calcStandardDeviation(int numArray[], int size)
{
    return sqroot(calcVariance(numArray, size));
}

char *intToStr(int number, int *size)
{
    char *reversedString;
    char *resultString;
    reversedString = malloc(16);
    resultString = malloc(16);
    int k = 0;
    if (number == 0)
        reversedString[k] = '0';
        
    while (number >= 1)
    {
        switch (number % 10)
        {
        case 1:
            reversedString[k] = '1';
            break;
        case 2:
            reversedString[k] = '2';
            break;
        case 3:
            reversedString[k] = '3';
            break;
        case 4:
            reversedString[k] = '4';
            break;
        case 5:
            reversedString[k] = '5';
            break;
        case 6:
            reversedString[k] = '6';
            break;
        case 7:
            reversedString[k] = '7';
            break;
        case 8:
            reversedString[k] = '8';
            break;
        case 9:
            reversedString[k] = '9';
            break;
        case 0:
            reversedString[k] = '0';
            break;
        default:
            break;
        }
        number = number / 10;
        k++;
    }
    int j = 0;
    for (int i = strlen(reversedString) - 1; i >= 0; i--)
    {
        char c = reversedString[i];
        resultString[j] = c;
        j++;
    }
    *size = strlen(reversedString);
    return resultString;
}

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf(1, "There are no input!\n");
        exit();
    }
    if (argc > 8)
    {
        printf(1, "There are more that 7 inputs!\n");
        exit();
    }

    char *AVStr;
    char *MVStr;
    char *LSDStr;
    int avSize;
    int mvSize;
    int lsdSize;
    AVStr = malloc(16);
    MVStr = malloc(16);
    LSDStr = malloc(16);
    int numOfNums = argc - 1;
    int numArray[numOfNums];

    for (int i = 1; i < argc; i++)
        numArray[i - 1] = atoi(argv[i]);

    int average = calcAverage(numArray, numOfNums);

    int k = 0, j = 0;
    for (int i = 0; i < numOfNums; i++)
    {
        if (numArray[i] > average)
            j++;
        else
            k++;
    }
    int lessThan[k];
    int moreThan[j];
    int x = 0, y = 0;
    for (int i = 0; i <= numOfNums; i++)
    {
        if (numArray[i] > average)
        {
            moreThan[x] = numArray[i];
            x++;
        }
        else
        {
            lessThan[y] = numArray[i];
            y++;
        }
    }
    int MVariance = calcVariance(moreThan, j);
    int LDerivation = calcStandardDeviation(lessThan, k);
    AVStr = intToStr(average, &avSize);
    MVStr = intToStr(MVariance, &mvSize);
    LSDStr = intToStr(LDerivation, &lsdSize);

    unlink("sdvar_result.txt");
    int fd = open("sdvar_result.txt", O_CREATE | O_WRONLY);

    if (fd < 0)
    {
        printf(1, "result_sdvar.:cannot create sdvar_result.txt\n");
        exit();
    }

    write(fd, AVStr, avSize);
    write(fd, " ", 1);
    write(fd, LSDStr, lsdSize);
    write(fd, " ", 1);
    write(fd, MVStr, mvSize);
    write(fd, "\n", 1);
    close(fd);

    exit();
}