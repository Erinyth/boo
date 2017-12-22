
LEX=flex
YACC=bison
CXX=g++
CXXFLAGS=-Wall -std=c++11
LDFLAGS= 

TARGET=scanner

OBJS=parser.o scanner.o driver.o main.o
GENFILES=location.hh position.hh stack.hh parser.hh 

.PHONY: all
all: $(TARGET)

.PHONY: clean
clean:
	rm -f $(TARGET) $(OBJS) $(GENFILES)

$(TARGET): $(OBJS)
	$(CXX) $(LDFLAGS) -o $@ $^

%.cc: %.ll
	$(LEX) -o $@ $<

%.cc %.hh: %.yy
	$(YACC) $< -v -o $@


