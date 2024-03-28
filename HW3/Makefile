# Makefile for part3

CXX = g++
CXXFLAGS = -Wall

PART3_SOURCES = part3-lex.o part3.tab.o part3_helpers.o
PART3_OBJECTS = $(PART3_SOURCES:.cpp=.o)

rx-cc: $(PART3_OBJECTS)
	$(CXX) -o $@ $^

part3_helpers.o : part3_helpers.cpp part3_helpers.hpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

part3.tab.o: part3.tab.cpp part3.tab.hpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

part3-lex.o: part3-lex.cpp part3.tab.hpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

part3-lex.cpp: part3.lex part3_helpers.hpp part3_helpers.cpp
	flex -o $@ part3.lex

part3.tab.cpp part3.tab.hpp: part3.ypp
	bison -d $<

.PHONY: clean
clean:
	rm -f part3 part3-lex.cpp *.o part3.tab.cpp part3.tab.hpp
