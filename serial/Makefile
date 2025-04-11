CXX     := g++
CXXFLAG := -std=c++11 -ggdb
INC     := $(shell pkg-config --cflags opencv4)
INCFLAG := $(shell pkg-config --libs opencv4)
LIB     := -lpthread

all: main.out 

main.out: main.cpp
	$(CXX) $(CXXFLAG) $< -o $@ $(INC) $(INCFLAG)

clean:
	rm *.out